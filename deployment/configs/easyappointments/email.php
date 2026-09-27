<?php defined('BASEPATH') or exit('No direct script access allowed');

$config['protocol']     = 'smtp';
$config['smtp_host']     = getenv('SMTP_HOST') ?: 'smtp.example.com';
$config['smtp_user']     = getenv('SMTP_USER') ?: '';
$config['smtp_pass']     = getenv('SMTP_PASS') ?: '';
$config['smtp_port']     = (int)(getenv('SMTP_PORT') ?: 465);
$config['smtp_crypto']   = getenv('SMTP_CRYPTO') ?: 'ssl'; // или 'tls' для 587 порта
$config['mailtype']      = 'html';
$config['charset']       = 'utf-8';
$config['newline']       = "\r\n";
$config['crlf']          = "\r\n";
$config['smtp_timeout']  = 10;