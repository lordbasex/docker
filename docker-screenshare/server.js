//https://github.com/muaz-khan/WebRTC-Experiment/tree/master/socketio-over-nodejs

var fs = require('fs');

// don't forget to use your own keys!
var options = {
    key: fs.readFileSync('/etc/letsencrypt/live/certificate/privkey.pem'),
    cert: fs.readFileSync('/etc/letsencrypt/live/certificate/fullchain.pem')
};

// HTTPs server
var app = require('https').createServer(options, function(request, response) {
    response.writeHead(200, {
        'Content-Type': 'text/html'
    });
    var link = process.env.LINK;
    response.write('<meta http-equiv="Refresh" content="0; url='+ link +'" />');
    response.end();
});

// socket.io goes below

var io = require('socket.io').listen(app, {
    log: true,
    origins: '*:*'
});

io.set('transports', [
    // 'websocket',
    'xhr-polling',
    'jsonp-polling'
]);

var channels = {};

io.sockets.on('connection', function (socket) {
    var initiatorChannel = '';
    if (!io.isConnected) {
        io.isConnected = true;
    }

    socket.on('new-channel', function (data) {
        if (!channels[data.channel]) {
            initiatorChannel = data.channel;
        }

        channels[data.channel] = data.channel;
        onNewNamespace(data.channel, data.sender);
    });

    socket.on('presence', function (channel) {
        var isChannelPresent = !! channels[channel];
        socket.emit('presence', isChannelPresent);
    });

    socket.on('disconnect', function (channel) {
        if (initiatorChannel) {
            delete channels[initiatorChannel];
        }
    });
});

function onNewNamespace(channel, sender) {
    io.of('/' + channel).on('connection', function (socket) {
        var username;
        if (io.isConnected) {
            io.isConnected = false;
            socket.emit('connect', true);
        }

        socket.on('message', function (data) {
            if (data.sender == sender) {
                if(!username) username = data.data.sender;
                
                socket.broadcast.emit('message', data.data);
            }
        });
        
        socket.on('disconnect', function() {
            if(username) {
                socket.broadcast.emit('user-left', username);
                username = null;
            }
        });
    });
}

// run app

app.listen(process.env.PORT || 9559);

process.on('unhandledRejection', (reason, promise) => {
  process.exit(1);
});

console.log('Please open SSL URL: https://localhost:'+(process.env.PORT || 9559)+'/');
