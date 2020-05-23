var map;
  window.initMap = function(){
      map = new google.maps.Map(document.getElementById('map'), {
      center: {lat: 53.902237399546216, lng: 27.561849655943984},
      zoom: 12,
      });
}
