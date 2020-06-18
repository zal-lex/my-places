let map;
let places = [];
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

async function getPlaces (map) {
  let userId = document.body.getAttribute('data-params-id');
  let url = "/users/" + userId + "/fav_places.json";
  let response = await fetch(url);

  if (response.ok) {
    places = await response.json();
  } else {
    console.log("HTTP error: " + response.status);
  }

  setMarkers(map, places);
};

function setMarkers(map, places) {
  for (let i = 0; i < places.length; i++) {
    let position = new google.maps.LatLng(
      places[i].latitude,
      places[i].longitude
    );
    let photos_html = '';
    if (typeof places[i].photos !== 'undefined' && places[i].photos.length > 0) {
      for (var j = 0; j < places[i].photos.length; j++) {
        let photo_url = places[i].photos[j].photo_url;
        let photo_alt = places[i].photos[j].photo_alt;
        photos_html += `</br><img class="place-photos" src="${photo_url}" alt="${photo_alt}">`;
      }
    }
    let content =
      `<div class="container delete-padding"><div><div class="favorite" id="favstatus-${places[i].id}"></div><p class="place-title">` +
      places[i].title +
      '</p><hr>' +
      '<p class="description-title">' +
      places[i].description.substring(0,150) +
      `<span class="collapse" id="more-${places[i].id}">${places[i].description.substring(150)}</span>` +
      `<span><a href="#more-${places[i].id}" data-toggle="collapse">... <span style="text-decoration:underline;">show more<i class="fa fa-caret-down"></i></span></p></div>` +
      `${photos_html}`;
    let marker = new google.maps.Marker({
      map: map,
      position: position,
      icon: '/assets/marker-fav.png'
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
          let is_favorite = 'favorite';
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
