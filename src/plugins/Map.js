let isInitialized = false;
const bufferedOptions = null;

/**
 * Callback for when the maps api registers the key with google. If this occurs after
 * a message was received for loading a map, that message is executed.
 */
const initMap = () => {
  /*
  if (!isInitialized && !!bufferedOptions) {
    loadMap(bufferedOptions);
  }

  isInitialized = true;
  */
  console.log("init map called");
};

/**
 * Callback for when Elm tells javascript to load the map. The map is only loaded
 * if the api has been successfully registered, otherwise the options are stored in
 * a buffer until the map is initialized.
 */
const pageWithMapLoaded = mapOptions => {
  /*
  if (!isInitialized) {
    bufferedOptions = mapOptions;
    return;
  } 

  loadMap(mapOptions);
  */
  window.requestAnimationFrame(() => loadMap(mapOptions));
}

/**
 * I'm not a fan of the maps api having the map be a part of the options object in the
 * Marker constructor. This method makes the construcot more similar to the infowindow
 * object which has a nicer api.
 */
const addMarker = (map, markerInfo) => {
  markerInfo.map = map;
  return new google.maps.Marker(markerInfo);
};

const addInfoWindow = (map, marker, content) => {
    const infowindow = new google.maps.InfoWindow({
      content
    });

    marker.addListener('click', function() {
      infowindow.open(map, marker);
    });
};

const listenForHover = title => {

};

/**
 * Loads a map onto the #map element on the page. The map is initialized
 * by an object looking like:
 * {
 *   mapOptions: {
 *     ...object to instantiate google.maps.Map...
 *   }
 *   markers: [
 *     ...object to instantiate google.maps.Marker...
 *     ...object to instantiate google.maps.Marker...
 *     ...
 *   ]
 * }
 */
const loadMap = options => {
  const el = document.getElementById('map');

  const map = new google.maps.Map(el, options.mapOptions);

  options.markers.forEach(markerInfo => {
    const marker = addMarker(map, markerInfo);

    addInfoWindow(map, marker, markerInfo.infoText);
  });
}

export default {
  initMap,
  pageWithMapLoaded
};
