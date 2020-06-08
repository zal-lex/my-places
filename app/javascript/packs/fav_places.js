let map;
let places = [];

$(document).ready(initMap = function() {
  let Minsk = new google.maps.LatLng(53.90223918954443, 27.561849518192048);

  // Create instance of map
  map = new google.maps.Map(document.getElementById("map"), {
    center: Minsk,
    zoom: 12,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
  });

  getPlaces();
});

async function getPlaces () {
  let userId = document.body.getAttribute('data-params-id');
  let url = "/users/" + userId + "/fav_places.json";
  let response = await fetch(url);

  if (response.ok) {
    places = await response.json();
  } else {
    console.log("Ошибка HTTP: " + response.status);
  }

  setMarkers(map, places);
};

function setMarkers(map, places) {
  for (let i = 0; i < places.length; i++) {
    let position = new google.maps.LatLng(
      places[i].latitude,
      places[i].longitude
    );
    let content =
      "<strong>Title:</strong></br>" +
      places[i].title +
      "</br><strong>Description:</strong></br>" +
      places[i].description;

    let marker = new google.maps.Marker({
      map: map,
      position: position,
    });

    let infowindow = new google.maps.InfoWindow();

    google.maps.event.addListener(
      marker,
      "click",
      (function (marker, content, infowindow) {
        return function () {
          infowindow.setContent(content);
          infowindow.open(map, marker);
        };
      })(marker, content, infowindow)
    );
  }
}
