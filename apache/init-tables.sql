CREATE DATABASE 'wordpress';
CREATE USER 'wordpress' IDENTIFIED BY 'wordpress';
GRANT ALL on wordpress.* to 'wordpress';


CREATE DATABASE 'wptests';
CREATE USER 'wptests' IDENTIFIED BY 'wptests';
GRANT ALL on wptests.* to 'wptests';
