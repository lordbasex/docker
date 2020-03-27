USE asteriskdb;


DROP TABLE IF EXISTS `extensions`;

CREATE TABLE `extensions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `context` varchar(20) NOT NULL DEFAULT 'from-trunk',
  `exten` varchar(20) NOT NULL DEFAULT '',
  `priority` tinyint(4) NOT NULL DEFAULT 1,
  `app` varchar(20) NOT NULL DEFAULT 'Macro',
  `appdata` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`context`,`exten`,`priority`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `meetme`;

CREATE TABLE `meetme` (
  `confno` varchar(80) NOT NULL DEFAULT '0',
  `pin` varchar(20) DEFAULT NULL,
  `adminpin` varchar(20) DEFAULT NULL,
  `members` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`confno`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `queue_member_table`;

CREATE TABLE `queue_member_table` (
  `uniqueid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `membername` varchar(40) DEFAULT NULL,
  `queue_name` varchar(128) DEFAULT NULL,
  `interface` varchar(128) DEFAULT NULL,
  `penalty` int(11) DEFAULT NULL,
  `paused` int(11) DEFAULT NULL,
  PRIMARY KEY (`uniqueid`),
  UNIQUE KEY `queue_interface` (`queue_name`,`interface`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `queue_table`;

CREATE TABLE `queue_table` (
  `name` varchar(128) NOT NULL,
  `musiconhold` varchar(128) DEFAULT NULL,
  `announce` varchar(128) DEFAULT NULL,
  `context` varchar(128) DEFAULT 'aero',
  `timeout` int(11) DEFAULT 10,
  `monitor_join` tinyint(1) DEFAULT NULL,
  `monitor_format` varchar(128) DEFAULT NULL,
  `queue_youarenext` varchar(128) DEFAULT 'silence/1',
  `queue_thereare` varchar(128) DEFAULT 'silence/1',
  `queue_callswaiting` varchar(128) DEFAULT 'silence/1',
  `queue_holdtime` varchar(128) DEFAULT NULL,
  `queue_minutes` varchar(128) DEFAULT NULL,
  `queue_seconds` varchar(128) DEFAULT NULL,
  `queue_lessthan` varchar(128) DEFAULT NULL,
  `queue_thankyou` varchar(128) DEFAULT NULL,
  `queue_reporthold` varchar(128) DEFAULT NULL,
  `announce_frequency` int(11) DEFAULT NULL,
  `announce_round_seconds` int(11) DEFAULT NULL,
  `announce_holdtime` varchar(128) DEFAULT 'no',
  `retry` int(11) DEFAULT 0,
  `wrapuptime` int(11) DEFAULT 0,
  `maxlen` int(11) DEFAULT 30,
  `servicelevel` int(11) DEFAULT 60,
  `strategy` enum('rrordered','ringall','rrmemory','linear','leastrecent','fewestcalls','random','wrandom') DEFAULT 'rrordered',
  `joinempty` varchar(128) DEFAULT 'yes',
  `leavewhenempty` varchar(128) DEFAULT 'no',
  `eventmemberstatus` varchar(11) DEFAULT 'no',
  `eventwhencalled` varchar(11) DEFAULT 'no',
  `reportholdtime` varchar(11) DEFAULT 'no',
  `memberdelay` int(11) DEFAULT 0,
  `weight` int(11) DEFAULT 0,
  `timeoutrestart` tinyint(1) DEFAULT NULL,
  `periodic_announce` varchar(50) DEFAULT NULL,
  `periodic_announce_frequency` int(11) DEFAULT 0,
  `ringinuse` varchar(11) DEFAULT 'no',
  `setinterfacevar` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `sip_buddies` */

DROP TABLE IF EXISTS `sip_buddies`;

CREATE TABLE `sip_buddies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `ipaddr` varchar(30) DEFAULT NULL,
  `port` int(5) DEFAULT NULL,
  `regseconds` int(11) DEFAULT NULL,
  `defaultuser` varchar(10) DEFAULT NULL,
  `fullcontact` varchar(35) DEFAULT NULL,
  `regserver` varchar(20) DEFAULT NULL,
  `useragent` varchar(20) DEFAULT NULL,
  `lastms` int(11) DEFAULT NULL,
  `host` varchar(40) DEFAULT 'dynamic',
  `type` enum('friend','user','peer') DEFAULT 'friend',
  `context` varchar(40) DEFAULT 'aero',
  `permit` varchar(40) DEFAULT NULL,
  `deny` varchar(40) DEFAULT NULL,
  `secret` varchar(40) DEFAULT 'aintelisis530780',
  `md5secret` varchar(40) DEFAULT NULL,
  `remotesecret` varchar(40) DEFAULT NULL,
  `transport` enum('ws,wss,udp','ws','wss,udp','ws,udp') DEFAULT 'ws,wss,udp',
  `dtmfmode` enum('rfc2833','info','shortinfo','inband','auto') DEFAULT NULL,
  `directmedia` enum('yes','no','nonat','update') DEFAULT 'no',
  `nat` enum('force_rport,comedia','yes','no','never') DEFAULT 'force_rport,comedia',
  `callgroup` varchar(40) DEFAULT '1',
  `pickupgroup` varchar(10) DEFAULT '1',
  `language` varchar(10) DEFAULT NULL,
  `allow` enum('g722,g729,gsm','g729,g722,gsm','g722','gsm,g722,g729','g722,g729,gsm,ulaw','g729') DEFAULT 'g722,g729,gsm',
  `disallow` varchar(40) DEFAULT 'all',
  `insecure` varchar(40) DEFAULT NULL,
  `trustrpid` enum('yes','no') DEFAULT NULL,
  `progressinband` enum('yes','no','never') DEFAULT NULL,
  `promiscredir` enum('yes','no') DEFAULT NULL,
  `useclientcode` enum('yes','no') DEFAULT NULL,
  `accountcode` varchar(40) DEFAULT NULL,
  `setvar` varchar(40) DEFAULT NULL,
  `callerid` varchar(40) DEFAULT NULL,
  `amaflags` varchar(40) DEFAULT NULL,
  `callcounter` enum('yes','no') DEFAULT NULL,
  `busylevel` int(11) DEFAULT NULL,
  `allowoverlap` enum('yes','no') DEFAULT NULL,
  `allowsubscribe` enum('yes','no') DEFAULT NULL,
  `videosupport` enum('yes','no') DEFAULT 'no',
  `maxcallbitrate` int(11) DEFAULT NULL,
  `rfc2833compensate` enum('yes','no') DEFAULT NULL,
  `mailbox` varchar(40) DEFAULT NULL,
  `session-timers` enum('accept','refuse','originate') DEFAULT NULL,
  `session-expires` int(11) DEFAULT NULL,
  `session-minse` int(11) DEFAULT NULL,
  `session-refresher` enum('uac','uas') DEFAULT NULL,
  `t38pt_usertpsource` varchar(40) DEFAULT NULL,
  `regexten` varchar(40) DEFAULT NULL,
  `fromdomain` varchar(40) DEFAULT NULL,
  `fromuser` varchar(40) DEFAULT NULL,
  `qualify` enum('yes','no') DEFAULT 'yes',
  `defaultip` varchar(40) DEFAULT NULL,
  `rtptimeout` int(11) DEFAULT NULL,
  `rtpholdtimeout` int(11) DEFAULT NULL,
  `sendrpid` enum('yes','no') DEFAULT NULL,
  `outboundproxy` varchar(40) DEFAULT NULL,
  `callbackextension` varchar(40) DEFAULT NULL,
  `registertrying` enum('yes','no') DEFAULT NULL,
  `timert1` int(11) DEFAULT NULL,
  `timerb` int(11) DEFAULT NULL,
  `qualifyfreq` int(11) DEFAULT NULL,
  `constantssrc` enum('yes','no') DEFAULT NULL,
  `contactpermit` varchar(40) DEFAULT NULL,
  `contactdeny` varchar(40) DEFAULT NULL,
  `usereqphone` enum('yes','no') DEFAULT NULL,
  `textsupport` enum('yes','no') DEFAULT NULL,
  `faxdetect` enum('yes','no') DEFAULT NULL,
  `buggymwi` enum('yes','no') DEFAULT NULL,
  `auth` varchar(40) DEFAULT NULL,
  `fullname` varchar(40) DEFAULT NULL,
  `trunkname` varchar(40) DEFAULT NULL,
  `cid_number` varchar(40) DEFAULT NULL,
  `callingpres` enum('allowed_not_screened','allowed_passed_screen','allowed_failed_screen','allowed','prohib_not_screened','prohib_passed_screen','prohib_failed_screen','prohib') DEFAULT NULL,
  `mohinterpret` varchar(40) DEFAULT NULL,
  `mohsuggest` varchar(40) DEFAULT NULL,
  `parkinglot` varchar(40) DEFAULT NULL,
  `hasvoicemail` enum('yes','no') DEFAULT NULL,
  `subscribemwi` enum('yes','no') DEFAULT NULL,
  `vmexten` varchar(40) DEFAULT NULL,
  `autoframing` enum('yes','no') DEFAULT NULL,
  `rtpkeepalive` int(11) DEFAULT NULL,
  `call-limit` int(11) DEFAULT 3,
  `g726nonstandard` enum('yes','no') DEFAULT NULL,
  `ignoresdpversion` enum('yes','no') DEFAULT NULL,
  `allowtransfer` enum('yes','no') DEFAULT 'yes',
  `dynamic` varchar(40) DEFAULT NULL,
  `encryption` enum('yes','no') DEFAULT 'yes',
  `avpf` varchar(40) DEFAULT 'yes',
  `icesupport` varchar(40) DEFAULT 'yes',
  `force_avp` varchar(40) DEFAULT 'yes',
  `dtlsenable` varchar(40) DEFAULT 'yes',
  `dtlsverify` varchar(40) DEFAULT 'no',
  `dtlscertfile` varchar(40) DEFAULT '/etc/ssl/certs/v2p.crt',
  `dtlsprivatekey` varchar(40) DEFAULT '/etc/ssl/certs/v2p.key',
  `dtlssetup` varchar(40) DEFAULT 'actpass',
  `srtpcapable` varchar(40) DEFAULT 'yes',
  `description` varchar(20) DEFAULT 'AgenteRT',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ipaddr` (`ipaddr`,`port`),
  KEY `host` (`host`,`port`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `usercalls`;

CREATE TABLE `usercalls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `max_callsin` int(11) DEFAULT NULL,
  `max_callsout` int(11) DEFAULT NULL,
  `max_callint` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

