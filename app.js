//while true; do node app; done

global.documentRoot = __dirname;
global.config = require('./config.json');

require('coffee-script');
require('./app/log');
require('./app/app');
require('./app/loader');
