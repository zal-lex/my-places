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
        let is_favorite = 'unfavorite'
        if (fav_places.find(fav_place => fav_place.id === places[i].id)) {
          is_favorite = 'favorite'
        }
        let location = new google.maps.LatLng(places[i].latitude, places[i].longitude);
        // Create marker
        let marker = new google.maps.Marker({
          position: location,
          map: map,
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
  let content =
    '<div class="container"><div class="row"><div class="col-9"><strong>Title:</strong></br>' +
    place.title +
    '</br><strong>Description:</strong></br>' +
    place.description +
    `</div><div class="col-3 ${is_favorite}" id="favstatus-${place.id}"></div></div>` +
    `<div class="row"><button id="editButton-${place.id}" class="btn  btn-outline-dark btn-sm">Edit</button>` +
    `<button id="deleteButton-${place.id}" class="btn btn-outline-dark btn-sm pad">Delete</button></div></div>`;

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
        console.log(marker.map)
        marker.setMap(null);
        console.log(marker.map)
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
