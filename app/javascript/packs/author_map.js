import { setMarker, getPlaces } from './set_markers.js';

let map;

$(document).ready(initMap = function() {
  let Minsk = new google.maps.LatLng(53.90223918954443, 27.561849518192048);

  // Create instance of map
  map = new google.maps.Map(document.getElementById("map"), {
    center: Minsk,
    zoom: 12,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    styles: [
    {
        "featureType": "all",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "saturation": 36
            },
            {
                "color": "#000000"
            },
            {
                "lightness": 40
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#000000"
            },
            {
                "lightness": 16
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 17
            },
            {
                "weight": 1.2
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 21
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 17
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 29
            },
            {
                "weight": 0.2
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 18
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 16
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 19
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 17
            }
        ]
    }
  ]
  });

  // Add place after click and take LanLng of point
  google.maps.event.addListener(map, "click", function (event) {
    addPlace(event.latLng);
  });
  getPlaces(map);
});

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
        '<textarea class="form-control" id="description_input" rows="3" maxlength="500" placeholder="Enter description"></textarea>' +
      '</div>' +
    '</form>'+
    '<button id="inputButton" class="btn btn-outline-dark btn-sm">Set my Place!</button>';

  let infoWindow = new google.maps.InfoWindow();
  // Set infoWindow content
  infoWindow.setContent(inputForm);
  infoWindow.open(map, marker);

  savePlace(infoWindow, marker);
}

function savePlace(infoWindow, marker) {
  // Create infoWindow
  google.maps.event.addListener(infoWindow, "domready", function () {

    // Bind action for set title button
    let button = document.getElementById("inputButton");

    // On click of form submit buttons
    button.addEventListener('click', async function(e) {

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
        let submittableData = {
          title: inputTitle,
          description: inputDescription,
          latitude: marker.getPosition().lat(),
          longitude: marker.getPosition().lng(),
        };
        let userId = document.body.getAttribute('data-params-id');

        let response = await fetch("/users/" + userId + "/places", {
          method: "POST",
          headers: {
            "X-CSRF-Token": document
              .getElementsByName("csrf-token")[0]
              .getAttribute("content"),
            "Content-Type": "application/json",
          },
          body: JSON.stringify(submittableData),
        })

        let place = await response.json();
        setMarker(map, marker, place);
        infoWindow.close();
      }
    });

    document.getElementById("title_input").focus();
  });
}
