<?php
require_once( __DIR__ . '/../vip-quickstart-config/local-proxy-config.php' );
define('AUTH_KEY',         'G-/O&gZ~k[1<*{md_dZR>$%+r|!.-hsajLtDAz{8:|[nQ=UhVdi-P}&%zI?V89Kf');
define('SECURE_AUTH_KEY',  '={k>rh$nP|BD2}s)Q>y43=1&tZ-DJ[@z46= rEO%==usM:SIe|s*]VQ$WCb&x*K*');
define('LOGGED_IN_KEY',    '-)twvZrH~FE i#l#-3lH=CxezV/(=Ut9!?pA-3shLQT>N:_s`RrII{CQ$%OK-$9z');
define('NONCE_KEY',        'JX_-`,zu} Be~ lCuntOY/xtmr83X-3rfbENii+kLCU2xCM52Y;)1/h0-XVc=vi8');
define('AUTH_SALT',        '!g[L#xfnmX>..8-t[o8,y!?yMT2+< i8M18gR!93k|}@TMwp75/.+cwRw%URE]{P');
define('SECURE_AUTH_SALT', 't]bbtJN8m `K0YWwE^ },TE`uE0.O()v;x-^<-,+*kMFsCx>SnJb,}pj1f@P4bd5');
define('LOGGED_IN_SALT',   'tsRMJaJY6@o27pCaQLj:(?7>xLCa@P9w)Tgtdm`Vvj7=,aD&g/DnjcQ!rh(d@y?,');
define('NONCE_SALT',       'NV%5+Yg&+T{p5_F%mawYG|s9p.YE}0q(;<HW]j+F}V_<N+sn3Xpf7Vx^/.?g8[m!');
define('JETPACK_DEV_DEBUG', true);
define('DB_HOST', getenv('MYSQL_PORT_3306_TCP_ADDR') );
define('SUBDOMAIN_INSTALL', true );
define('DEBUG', true);
