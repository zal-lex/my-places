async function getPlaces(map) {
  let userId = document.body.getAttribute('data-params-id');
  let url_places = "/users/" + userId + "/places.json";
  let response = await fetch(url_places);

  if (response.ok) {
    let places = await response.json();
    for (var i = 0; i < places.length; i++) {

      let location = new google.maps.LatLng(places[i].latitude, places[i].longitude);
      // Create marker
      let marker = new google.maps.Marker({
        position: location,
        map: map,
      });
      setMarker(map, marker, places[i]);
    }
  } else {
    alert("Ошибка HTTP: " + response.status);
  }
};

function setMarker(map, marker, place) {

  let content =
    "<strong>Title:</strong></br>" +
    place.title +
    "</br><strong>Description:</strong></br>" +
    place.description +
    
    '</br><button id="editButton" class="btn btn-outline-dark btn-sm">Edit</button>' +
    '<button id="deleteButton" class="btn btn-outline-dark btn-sm pad">Delete</button>';

  let infoWindow = new google.maps.InfoWindow();

  google.maps.event.addListener(
    marker,
    "click",
    (function (marker, content, infoWindow) {
      return function () {
        infoWindow.setContent(content);
        infoWindow.open(map, marker);
        deletePlace(map, place, marker, infoWindow);
      };
    })(marker, content, infoWindow)
  );
}

function deletePlace (map, place, marker, infoWindow) {
  google.maps.event.addListener(infoWindow, "domready", function () {
    let deleteButton = document.getElementById("deleteButton");

    deleteButton.addEventListener('click', function() {
      let userId = document.body.getAttribute('data-params-id');
      let placeId = place.id;

      fetch("/users/" + userId + "/places/" + placeId, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": document
            .getElementsByName("csrf-token")[0]
            .getAttribute("content"),
        },
      }).then((response) => {
        marker.setMap(null);
        infoWindow.close();
      });
    })
  })
}

export { getPlaces, setMarker }
