import M from 'materialize-css';

const startMaterial = ports => {
  let navbar;

  ports.openSideNav.subscribe(() => {
    getMaterialComponent('.sidenav', M.Sidenav).open();
  });

  ports.materialBox.subscribe(imageId => {
    getMaterialComponent(`#${imageId}`, M.Materialbox).open();
  });
};

const getMaterialComponent = (selectorString, materialComponent) => {
  const elem = document.querySelector(selectorString);

  const component = materialComponent.getInstance(elem);
  if (!!component) {
    return component;
  }

  return materialComponent.init(elem);
}

window.onhashchange = () => {
  getMaterialComponent('.sidenav', M.Sidenav).close();
}

export default startMaterial;
