import './main.css';
import registerServiceWorker from './registerServiceWorker';
const Elm = require("expose-loader?Elm!./elm.js");

import startMaterial from './plugins/Material';
import startWatchingContent from './plugins/firebase';

import Map from './plugins/Map';

const app = Elm.Elm.Main.init(document.getElementById('root'));

window.initMap = Map.initMap; // for the Google Maps Api
app.ports.loadMap.subscribe(Map.pageWithMapLoaded);

startWatchingContent(app.ports.onContentFetch.send);
startMaterial(app.ports);
registerServiceWorker();
