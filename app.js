global.documentRoot = __dirname;
global.config = require('./config.json');

config.startModules.forEach(require);