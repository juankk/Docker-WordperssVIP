CREATE DATABASE IF NOT EXISTS wordpress;
grant all on wordpress.* to 'wordpress'@'%' identified by 'wordpress';

CREATE DATABASE IF NOT EXISTS wptests;
grant all on wptest.* to 'wptests'@'%' identified by 'wptests';
