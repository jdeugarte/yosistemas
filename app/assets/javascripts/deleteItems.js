function eliminarItemDeVista(elemId)
  {
    var element = document.getElementById(elemId);
    element.parentNode.removeChild(element);
    var hidden = document.getElementById("elemsParaElim");
    hidden.value = hidden.value+"-"+elemId;
  }