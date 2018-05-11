import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

import startMaterial from './plugins/Material';
import startWatchingContent from './plugins/firebase';

const app = Main.embed(document.getElementById('root'));

startWatchingContent(app.ports.onContentFetch.send);
startMaterial(app.ports);
registerServiceWorker();
