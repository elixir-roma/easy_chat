const Elm = require('../elm/Main.elm');

const websocketProtocol = location.protocol === 'https:' ? 'wss:' : 'ws:';

const websocketHost = websocketProtocol + '//' + location.host + '/ws';

var app = Elm.Main.fullscreen({
    websocketHost: websocketHost
});
