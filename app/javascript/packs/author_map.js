import setMarkers from './set_markers.js';
let map;
let places = [];
$(document).ready(function initMap() {
  let Minsk = new google.maps.LatLng(53.90223918954443, 27.561849518192048);

  // Create instance of map
  map = new google.maps.Map(document.getElementById("map"), {
    center: Minsk,
    zoom: 12,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
  });

  // Add place after click and take LanLng of point
  google.maps.event.addListener(map, "click", function (event) {
    addPlace(event.latLng);
  });

  getPlaces();
});

async function getPlaces () {
  let url = window.location.pathname + "/places.json";
  let response = await fetch(url);

  if (response.ok) {
    places = await response.json();
  } else {
    alert("Ошибка HTTP: " + response.status);
  }

  setMarkers(map, places);
};

function addPlace(location) {
  let latitude = location.toJSON().lat;
  let longitude = location.toJSON().lng;

  // Create marker
  let marker = new google.maps.Marker({
    position: location,
    map: map,
  });

  // Create form and submit button
  let inputForm =
    '<form>' +
      '<div class="form-group">' +
        '<label for="title">Title:</label>' +
        '<input type="text" class="form-control" id="title_input" rows="1" required maxlength="60" placeholder="Enter title">' +
      '</div>' +
      '<div class="form-group">' +
        '<label for="description">Description:</label>' +
        '<textarea class="form-control" id="description_input" rows="3" maxlength="500" placeholder="Enter title"></textarea>' +
      '</div>' +
    '</form>'+
    '<button id="inputButton" class="btn btn-success">Set my Place!</button>';

  let infoWindow = new google.maps.InfoWindow();
  // Set infoWindow content
  infoWindow.setContent(inputForm);
  infoWindow.open(map, marker);

  savePlace(latitude, longitude, infoWindow);
}

function savePlace(lat, lng, infoWindow) {
  // Create infoWindow
  google.maps.event.addListener(infoWindow, "domready", function () {

    // Bind action for set title button
    let button = document.getElementById("inputButton");

    // On click of form submit buttons
    button.addEventListener('click', function(e) {
      let input = document.querySelectorAll("input")[0];

      if ( input.validity.valueMissing ) {
        input.insertAdjacentHTML('afterend', '<p class="error-message">' + 
          input.validationMessage + '</p>')
        var stopSubmit = true;
      }

      if ( stopSubmit ) { e.preventDefault(); } else {
        // Get input value and call setMarkerData function
        let inputTitle = document.getElementById("title_input").value;
        let inputDescription = document.getElementById("description_input").value;
        let url = window.location.pathname;
        let submittableData = {
          title: inputTitle,
          description: inputDescription,
          latitude: lat,
          longitude: lng,
        };

        fetch(url + "/places", {
          method: "POST",
          headers: {
            "X-CSRF-Token": document
              .getElementsByName("csrf-token")[0]
              .getAttribute("content"),
            "Content-Type": "application/json",
          },
          body: JSON.stringify(submittableData),
        }).then((response) => {
          places.push(submittableData);
          setMarkers(map, places);
        });
        infoWindow.close();
      }
    });

    document.getElementById("title_input").focus();
  });
}
