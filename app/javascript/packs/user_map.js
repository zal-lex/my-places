let map;
let places = [];
let fav_places = [];
let markers = [];
let userId = document.body.getAttribute('data-params-id');

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
                "color": "#ffffff"
            },
            {
                "lightness": 20
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
                "lightness": 20
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
                "lightness": 23
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
                "lightness": 20
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
                "lightness": 45
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
                "lightness": 40
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
                "lightness": 35
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
                "lightness": 32
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
                "lightness": 35
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
                "lightness": 35
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
                "lightness": 35
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
                "lightness": 40
            }
        ]
    }
  ]
  });

  getPlaces(map);
});

async function getPlaces(map) {
  let userId = document.body.getAttribute('data-params-id');
  let url = "/users/" + userId + "/places.json";
  let url_fav_places = "/users/" + userId + "/fav_places.json";
  let response = await fetch(url);

  if (response.ok) {
    places = await response.json();
    let response_fav_places = await fetch(url_fav_places);

    if (response_fav_places.ok) {
      fav_places = await response_fav_places.json();
    } else {
      alert("HTTP error: " + response.status);
    }
  } else {
    alert("HTTP error: " + response.status);
  }

  setMarkers(map, places, fav_places);
};

function setMarkers(map, places, fav_places) {
  for (let i = 0; i < places.length; i++) {
    let is_favorite = 'unfavorite';
    let marker_icon = '/assets/marker.png';
    if (fav_places.find(fav_place => fav_place.id === places[i].id)) {
      is_favorite = 'favorite';
      marker_icon = '/assets/marker-fav.png';
    }

    let position = new google.maps.LatLng(
      places[i].latitude,
      places[i].longitude
    );
    let content =
      '<div class="container"><div class="row">' +
      `<div class="col-9"><p class="place-title">${places[i].title}</p><hr><p class="description-title">${places[i].description}</p></div>` +
      `<div class="col-3 ${is_favorite}" id="favstatus-${places[i].id}"></div></div></div>`;

    let marker = new google.maps.Marker({
      map: map,
      position: position,
      icon: marker_icon,
    });
    markers.push(marker);
    let infowindow = new google.maps.InfoWindow();

    google.maps.event.addListener(
      marker,
      "click",
      (function (marker, content, infowindow) {
        return function () {
          infowindow.setContent(content);
          infowindow.open(map, marker);
          toggleFavStatus(map, places[i], is_favorite, infowindow);
        };
      })(marker, content, infowindow)
    );
  }
}

function toggleFavStatus(map, place, is_favorite, infoWindow) {
  google.maps.event.addListener(infoWindow, "domready", function () {
    let favStatus = document.getElementById(`favstatus-${place.id}`);
    
    favStatus.addEventListener('click', async function() {
      if (is_favorite === 'favorite') {
        let response = await fetch("/users/" + userId + "/places/" + place.id + "/likes", {
          method: "DELETE",
          headers: {
            "X-CSRF-Token": document
              .getElementsByName("csrf-token")[0]
              .getAttribute("content"),
          },
        })
        if (response.ok) {
          for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
          }
          markers = [];
          getPlaces(map);
        } else {
          alert("HTTP error: " + response.status);
        }

      } else if (is_favorite === 'unfavorite') {
        let submittableData = {
          user_id: userId,
          place_id: place.id,
        }

        let response = await fetch("/users/" + userId + "/places/" + place.id + "/likes", {
          method: "POST",
          headers: {
            "X-CSRF-Token": document
              .getElementsByName("csrf-token")[0]
              .getAttribute("content"),
            "Content-Type": "application/json",
          },
          body: JSON.stringify(submittableData),
        })
        if (response.ok) {
          infoWindow.close();
          for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
          }
          markers = [];
          getPlaces(map);
        } else {
          alert("HTTP error: " + response.status);
        }
      } else {
        alert("Error with place favorite status");
      }
    })
  })
}
