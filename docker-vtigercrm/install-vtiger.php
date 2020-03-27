<?php

libxml_use_internal_errors(true);
date_default_timezone_set('America/Argentina/Buenos_Aires');

require_once __DIR__.'/vendor/autoload.php';

$client = new GuzzleHttp\Client([
    'base_uri' => 'http://localhost/',
    'cookies' => true,
]);

/**
 * @param $client
 * @param $path
 * @param null $returns
 * @return array
 */
function GET($client, $path, $returns = null)
{
    $response = $client->request('GET', $path);

    return VALUES($response->getBody()->getContents(), $returns);
}

/**
 * @param $client
 * @param $path
 * @param null $returns
 * @return array
 */
function POST($client, $path, $returns = null, $params = null)
{
    $response = $client->request('POST', $path, [ 'form_params' => $params ]);

    return VALUES($response->getBody()->getContents(), $returns);
}

/**
 * @param $html
 * @param $returns
 * @return array
 */
function VALUES($html, $returns)
{
    $doc = new DOMDocument();
    $doc->loadHTML($html);
    $xpath = new DOMXPath($doc);

    $returnValues = [];
    foreach ($returns as $key) {
        $returnValues[$key] = $xpath->query('//input[@name="'.$key.'"]/@value')->item(0)->nodeValue;
    }

    return $returnValues;
}

// Get session token
$values = GET($client, 'index.php?module=Install&view=Index&mode=Step4', ['__vtrftk']);

// Submit installation params
$values = POST(
    $client,
    'index.php',
    ['__vtrftk', 'auth_key'],
    [
        '__vtrftk' => $values['__vtrftk'],
        'module' => 'Install',
        'view' => 'Index',
        'mode' => 'Step5',
        'db_type' => 'mysqli',
        'db_hostname' => getenv('DB_HOSTNAME'),
        'db_username' => getenv('DB_USERNAME'),
        'db_password' => getenv('DB_PASSWORD'),
        'db_name' => getenv('DB_NAME'),
        'db_root_username' => '',
        'db_root_password' => '',
        'currency_name' => getenv('CURRENCIES') ?: 'USA, Dollars',
        'admin' => 'admin',
        'password' => getenv('ADMIN_PASSWORD') ?: 'admin',
        'retype_password' => getenv('ADMIN_PASSWORD') ?: 'admin',
        'firstname' => getenv('ADMIN_NAME') ?: '',
        'lastname' => getenv('ADMIN_LASTNAME') ?: 'Administrator',
        'admin_email' => getenv('ADMIN_EMAIL') ?: 'admin@hostname.com',
        'dateformat' =>  getenv('DATEFORMAT') ?: 'mm-dd-yyyy',
        'timezone' => getenv('TIMEZONE') ?: 'America/Los_Angeles',
    ]
);

// Confirm installation
$values = POST(
    $client,
    'index.php',
    ['__vtrftk', 'auth_key'],
    [
        '__vtrftk' => $values['__vtrftk'],
        'auth_key' => $values['auth_key'],
        'module' => 'Install',
        'view' => 'Index',
        'mode' => 'Step6',
    ]
);

// Select industry sector
$values = POST(
    $client,
    'index.php',
    ['__vtrftk'],
    [
        '__vtrftk' => $values['__vtrftk'],
        'auth_key' => $values['auth_key'],
        'module' => 'Install',
        'view' => 'Index',
        'mode' => 'Step7',
        'industry' => 'Accounting',
    ]
);

// First login
$values = POST(
    $client,
    'index.php?module=Users&action=Login',
    ['__vtrftk'],
    [
        '__vtrftk' => $values['__vtrftk'],
        'username' => 'admin',
        'password' => getenv('ADMIN_PASSWORD') ?: 'admin',
    ]
);

// Setup crm modules
$values = POST(
    $client,
    'index.php?module=Users&action=SystemSetupSave',
    ['__vtrftk'],
    [
        '__vtrftk' => $values['__vtrftk'],
        'packages[Tools]' => 'on',
        'packages[Sales]' => getenv('PACKAGES_SALE') ?: '',
        'packages[Marketing]' => getenv('PACKAGES_MARKETING') ?: '',
        'packages[Support]' => getenv('PACKAGES_SUPPORT') ?: '',
        'packages[Inventory]' => getenv('PACKAGES_INVENTORY') ?: '',
        'packages[Project]' => getenv('PACKAGES_PROJECT') ?: '',
    ]
);

// Save user settings
$values = POST(
    $client,
    'index.php?module=Users&action=UserSetupSave',
    ['__vtrftk'],
    [
        '__vtrftk' => $values['__vtrftk'],
        'currency_name' => getenv('CURRENCIES') ?: 'Euro',
        'lang_name' => getenv('LANGUAGE') ?: 'en_us',
        'time_zone' => getenv('TIMEZONE') ?: 'America/Los_Angeles',
        'date_format' => getenv('DATEFORMAT') ?: 'mm-dd-yyyy',
    ]
);

?>
