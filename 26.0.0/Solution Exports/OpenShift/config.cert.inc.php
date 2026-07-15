<?php
    $config['imap_conn_options'] = array(
        'ssl' => array(
            'verify_peer'       => false,
            'allow_self_signed' => true,
            'peer_name'         => 'mailserver',
            'ciphers'           => 'TLSv1+HIGH:!aNull:@STRENGTH',
            'cafile'            => '/var/www/html/config/mailserver.pem',
        ),
    );

    $config['smtp_conn_options'] = array(
        'ssl' => array(
            'verify_peer'       => false,
            'allow_self_signed' => true,
            'peer_name'         => 'mailserver',
            'ciphers'           => 'TLSv1+HIGH:!aNull:@STRENGTH',
            'cafile'            => '/var/www/html/config/mailserver.pem',
        ),
    );
