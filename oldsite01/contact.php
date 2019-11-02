<?php

$name = $_POST['name'];

$email = $_POST['email'];

$phone = $_POST['telephone'];

$subject = $_POST['message'];

$site = $_SERVER['HTTP_HOST'];



$msg="Name : ".$name."\n\rEmail : ".$email."\n\rContact : ".$phone."\n\rMessage : ".$subject;



$to = "tg@geochits.com";



$from =  $site;



//$from = 'Enquiry From '.$_SERVER['HTTP_HOST'].';

$subject='Enquiry';

$headers='From: '.$site;



mail($to,$subject,$msg,$headers);

header("Location: thanks.html");

?>
