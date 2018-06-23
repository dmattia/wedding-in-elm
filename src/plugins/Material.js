import M from 'materialize-css';

const startMaterial = ports => {
  let navbar;

  ports.openSideNav.subscribe(() => {
    getInitializedMaterialComponent('.sidenav', M.Sidenav).open();
  });

  ports.initMaterialSelects.subscribe(text => {
    getInitializedMaterialComponent('select', M.FormSelect);
  });

  ports.toast.subscribe(html => {
    M.toast({html});
  });
};

const getInitializedMaterialComponent = (selectorString, materialComponent) => {
  const elems = document.querySelectorAll(selectorString);

  const component = materialComponent.getInstance(elems);
  if (!!component) {
    return component;
  }

  return materialComponent.init(elems);
}

window.onhashchange = () => {
  getInitializedMaterialComponent('.sidenav', M.Sidenav).close();
}

export default startMaterial;
