let userId = document.body.getAttribute('data-params-id');
let markers = [];

async function getPlaces(map) {
  let url_places = "/users/" + userId + "/places.json";
  let url_fav_places = "/users/" + userId + "/fav_places.json";
  let fav_places = [];

  let response = await fetch(url_places);

  if (response.ok) {
    let places = await response.json();

    let response_fav_places = await fetch(url_fav_places);

    if (response_fav_places.ok) {
      fav_places = await response_fav_places.json();
      
      for (var i = 0; i < places.length; i++) {
        let is_favorite = 'unfavorite';
        let marker_icon = '/assets/marker.png';
        if (fav_places.find(fav_place => fav_place.id === places[i].id)) {
          is_favorite = 'favorite';
          marker_icon = '/assets/marker-fav.png';
        }

        let location = new google.maps.LatLng(places[i].latitude, places[i].longitude);
        // Create marker
        let marker = new google.maps.Marker({
          position: location,
          map: map,
          icon: marker_icon,
        });
        setMarker(map, marker, places[i], is_favorite);
      }
    } else {
      alert("HTTP error: " + response.status);
    }
  } else {
    alert("HTTP error: " + response.status);
  }
};

function setMarker(map, marker, place, is_favorite) {

  markers.push(marker);
  let photos_html = '';
  if (typeof place.photos !== 'undefined' && place.photos.length > 0) {
    for (var i = 0; i < place.photos.length; i++) {
      let photo_url = place.photos[i].photo_url;
      let photo_alt = place.photos[i].photo_alt;
      photos_html += `</br><img class="place-photos" src="${photo_url}" alt="${photo_alt}">`;
    }
  }

  let content =
    `<div class="container delete-padding"><div><div class="${is_favorite}" id="favstatus-${place.id}"></div><p class="place-title">` +
    place.title +
    '</p><hr>' +
    '<p class="description-title">' +
    place.description.substring(0,150) +
    `<span class="collapse" id="more-${place.id}">${place.description.substring(150)}</span>` +
    `<span><a href="#more-${place.id}" data-toggle="collapse">... <span style="text-decoration:underline;">show more<i class="fa fa-caret-down"></i></span></p></div>` +
    `${photos_html}` +
    `<div class="row"><div class="col-3"><button id="editButton-${place.id}" class="btn  btn-outline-light btn-sm">Edit</button></div>` +
    `<div class="col-6"></div><div class="col-3"><button id="deleteButton-${place.id}" class="btn btn-outline-light btn-sm pad">Delete</button></div></div></div>`;

  let infoWindow = new google.maps.InfoWindow();
  google.maps.event.addListener(
    marker,
    "click",
    (function (marker, content, infoWindow) {
      return function () {
        infoWindow.setContent(content);
        infoWindow.open(map, marker);
        deletePlace(map, place, marker, infoWindow);
        toggleFavStatus(map, place, is_favorite, infoWindow);
      };
    })(marker, content, infoWindow)
  );
}

function deletePlace (map, place, marker, infoWindow) {
  google.maps.event.addListener(infoWindow, "domready", function () {
    let deleteButton = document.getElementById(`deleteButton-${place.id}`);

    deleteButton.addEventListener('click', async function(e) {
      let placeId = place.id;
      let response = await fetch("/users/" + userId + "/places/" + placeId, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": document
            .getElementsByName("csrf-token")[0]
            .getAttribute("content"),
        }
      })
      if (response.ok) {
        marker.setMap(null);
        infoWindow.close();
      } else {
        console.log('Something wrong with network')
      }

    })
  })
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

export { getPlaces, setMarker }
