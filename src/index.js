import './main.css';
import registerServiceWorker from './registerServiceWorker';
const Elm = require("expose-loader?Elm!./elm.js");

import startMaterial from './plugins/Material';
import startWatchingContent from './plugins/firebase';

const app = Elm.Elm.Main.fullscreen(document.getElementById('root'));

startWatchingContent(app.ports.onContentFetch.send);
startMaterial(app.ports);
registerServiceWorker();
