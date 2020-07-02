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
  let description_html = '';
  if (place.description.length >= 100) {
    description_html = `<p class="description-title">${place.description.substring(0,150)}` +
    `<span class="collapse" id="more-${place.id}">${place.description.substring(150)}</span>` +
    `<span><a href="#more-${place.id}" data-toggle="collapse">... <span style="text-decoration:underline;">show more<i class="fa fa-caret-down"></i></span></p>`
  } else {
    description_html = `<p class="description-title">${place.description}</p>`
  }
  let content =
    `<div class="container delete-padding"><div><div class="${is_favorite}" id="favstatus-${place.id}"></div>` +
    `<p class="place-title">${place.title}</p><hr>${description_html}</div>${photos_html}` +
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
        editPlace(map, place, is_favorite, marker, infoWindow);
        deletePlace(map, place, marker, infoWindow);
        toggleFavStatus(map, place, is_favorite, infoWindow);
      };
    })(marker, content, infoWindow)
  );
}

function editPlace (map, place, is_favorite, marker, infoWindow) {
  google.maps.event.addListener(infoWindow, "domready", function () {
    let editButton = document.getElementById(`editButton-${place.id}`);

    editButton.addEventListener('click', async function(e) {
        // Create form and submit button
      let inputForm =
        '<form>' +
          '<div class="form-group">' +
            '<label for="title">Title:</label>' +
            `<input type="text" class="form-control" id="title_input_edit" rows="1" required maxlength="60" placeholder="Enter title" value="${place.title}">` +
          '</div>' +
          '<div class="form-group">' +
            '<label for="description">Description:</label>' +
            `<input type="text" class="form-control" id="description_input" rows="3" maxlength="500" placeholder="Enter description" value="${place.description}">` +
          '</div>' +
        '</form>'+
        '<button id="inputButton" class="btn btn-outline-light btn-sm">Set my Place!</button>';
      infoWindow.close();
      infoWindow = null;
      let editWindow = new google.maps.InfoWindow();
      editWindow.setContent(inputForm);
      editWindow.open(map, marker);

      google.maps.event.addListener(editWindow, "domready", function () {
        // Bind action for set title button
        let button = document.getElementById("inputButton");

        // On click of form submit buttons
        button.addEventListener('click', async function(e) {
          let input = document.getElementById("title_input_edit");

          if ( input.validity.valueMissing ) {
            input.insertAdjacentHTML('afterend', '<p class="error-message">' + 
              input.validationMessage + '</p>')
            var stopSubmit = true;
          }

          if ( stopSubmit ) { e.preventDefault(); } else {
            // Get input value and call setMarkerData function
            let inputTitle = document.getElementById("title_input_edit").value;
            let inputDescription = document.getElementById("description_input").value;
            let submittableData = {
              title: inputTitle,
              description: inputDescription,
            };
            let placeId = place.id;

            let response = await fetch("/users/" + userId + "/places/" + placeId, {
              method: "PATCH",
              headers: {
                "X-CSRF-Token": document
                  .getElementsByName("csrf-token")[0]
                  .getAttribute("content"),
                "Content-Type": "application/json",
              },
              body: JSON.stringify(submittableData),
            })
            if (response.ok) {
              editWindow.close();
              editWindow = null;
              let updated_place = await response.json();
              google.maps.event.clearListeners(marker, 'click');
              setMarker(map, marker, updated_place, is_favorite)

            } else {
              console.log('Something wrong with network')
            }
          }
        })

        document.getElementById("title_input_edit").focus();
      })
    })
  })
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
