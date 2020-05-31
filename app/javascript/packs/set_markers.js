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
      places[i].description +
      '</br><button id="editButton" class="btn btn-link">Edit</button>' +
      '<button id="deleteButton" class="btn btn-link">Delete</button>';

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

export default setMarkers
