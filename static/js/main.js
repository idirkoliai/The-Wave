function openSearch() {
  var elements = document
    .getElementsByClassName("search-bar")[0]
    .getElementsByTagName("input");
  closeNav();
  for (var i = 0; i < elements.length; i++) {
    if (elements[i].getAttribute("type") === "text") {
      elements[i].style.width = "60%";
    }
  }
}

document.addEventListener("click", function (event) {
  const searchBar = document.querySelector('.search-bar input[type="text"]');
  if (!searchBar) {return;}
  let isClickInsideSearchBar = searchBar.contains(event.target);
  if (!isClickInsideSearchBar) {
    searchBar.style.width = "40%";
  }
});

function openNav() {
  document.getElementById("mySidenav").style.width = "300px";
  var elements = document.getElementsByClassName("main-content");
  for (var i = 0; i < elements.length; i++) {
    elements[i].style.marginLeft = "300px";
  }
}

function closeNav() {
  document.getElementById("mySidenav").style.width = "0";
  var elements = document.getElementsByClassName("main-content");
  for (var i = 0; i < elements.length; i++) {
    elements[i].style.marginLeft = "100px";
  }
}

function toggleFollow() {
  const followButton = document.getElementById("followButton");
  const groupID = followButton.getAttribute("groupID");
  fetch("/check_follow_status/" + groupID)
    .then((response) => {
      if (response.ok) {
        return response.text();
      }
      throw new Error("Network response was not ok.");
    })
    .then((data) => {
      if (data.trim() === "unfollowed") {
        fetch("/follow/0/" + groupID, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              followButton.innerText = "Following";
              updateFollowersCount();
            } else {
              throw new Error("Unfollow request failed.");
            }
          })
          .catch((error) => {
            console.error("Unfollow error:", error);
          });
      } else if (data.trim() === "followed") {
        fetch("/follow/1/" + groupID, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              followButton.innerText = "Follow";
              updateFollowersCount();
            } else {
              throw new Error("Follow request failed.");
            }
          })
          .catch((error) => {
            console.error("Follow error:", error);
          });
      }
    })
    .catch((error) => {
      console.error("Toggle follow error:", error);
    });
}

function checkInitialFollowStatus() {
  const followButton = document.getElementById("followButton");
  if (followButton) {
    const groupID = followButton.getAttribute("groupID");
    fetch("/check_follow_status/" + groupID)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok.");
        }
        return response.text();
      })
      .then((data) => {
        const followButton = document.getElementById("followButton");
        if (data.trim() === "unfollowed") {
          followButton.innerText = "Follow";
        } else if (data.trim() === "followed") {
          followButton.innerText = "Following";
        }
      })
      .catch((error) => {
        console.error("Check initial follow status error:", error);
      });
  }
}

function updateFollowersCount() {
  const followButton = document.getElementById("followButton");
  const groupID = followButton.getAttribute("groupID");
  fetch("/get_followers_count/" + groupID)
    .then((response) => {
      if (response.ok) {
        return response.text();
      }
      throw new Error("Network response was not ok.");
    })
    .then((count) => {
      const followersCount = document.getElementById("followersCount");
      if (followersCount) {
        followersCount.innerText = count;
      }
    })
    .catch((error) => {
      console.error("Followers count update error:", error);
    });
}


function changeStatus(){
  const playlistStatus = document.getElementById("playlistStatus");
  if(!playlistStatus){return;}
  const playlistID = playlistStatus.getAttribute("playlistID");
  fetch("/check_playlist_status/" + playlistID)
    .then((response) => {
      if (response.ok) {
        return response.text();
      }
      throw new Error("Network response was not ok.");
    })
    .then((data) => {
      if (data.trim() === "public") {
        fetch("/change_playlist_status/0/" + playlistID, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              playlistStatus.innerText = "Private";
            } else {
              throw new Error("Change status request failed.");
            }
          })
          .catch((error) => {
            console.error("Change status error:", error);
          });
      } else if (data.trim() === "private") {
        fetch("/change_playlist_status/1/" + playlistID, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              playlistStatus.innerText = "Public";
            } else {
              throw new Error("Change status request failed.");
            }
          })
          .catch((error) => {
            console.error("Change status error:", error);
          });
      }
    })
    .catch((error) => {
      console.error("Change status error:", error);
    });
}


function checkInitialPlaylistStatus() {
  const playlistStatus = document.getElementById("playlistStatus");
  if (playlistStatus) {
    const playlistID = playlistStatus.getAttribute("playlistID");
    fetch("/check_playlist_status/" + playlistID)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok.");
        }
        return response.text();
      })
      .then((data) => {
        const playlistStatus = document.getElementById("playlistStatus");
        if (data.trim() === "public") {
          playlistStatus.innerText = "Public";
        } else if (data.trim() === "private") {
          playlistStatus.innerText = "Private";
        }
      })
      .catch((error) => {
        console.error("Check initial playlist status error:", error);
      });
  }
}

function addFavorites() {
  const favoriteButton = document.getElementById("favoriteButton");
  if (!favoriteButton) {
    return;
  }
  const songID = favoriteButton.getAttribute("trackID");
  fetch("/check_favorite_status/" + songID)
    .then((response) => {
      if (response.ok) {
        return response.text();
      }
      throw new Error("Network response was not ok.");
    })
    .then((data) => {
      if (data.trim() === "unfavorited") {
        fetch("/favorite/0/" + songID, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              favoriteButton.innerText = "Remove from favorites";
            } else {
              throw new Error("Unfavorite request failed.");
            }
          })
          .catch((error) => {
            console.error("Unfavorite error:", error);
          });
      } else if (data.trim() === "favorited") {
        fetch("/favorite/1/" + songID, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              favoriteButton.innerText = "Add to favorites";
            } else {
              throw new Error("Favorite request failed.");
            }
          })
          .catch((error) => {
            console.error("Favorite error:", error);
          });
      }
    })
    .catch((error) => {
      console.error("Toggle favorite error:", error);
    });
}

function checkInitialFavoriteStatus() {
  const favoriteButton = document.getElementById("favoriteButton");
  if (favoriteButton) {
    const songID = favoriteButton.getAttribute("trackID");
    fetch("/check_favorite_status/" + songID)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok.");
        }
        return response.text();
      })
      .then((data) => {
        const favoriteButton = document.getElementById("favoriteButton");
        if (data.trim() === "unfavorited") {
          favoriteButton.innerText = "Add to favorites";
        } else if (data.trim() === "favorited") {
          favoriteButton.innerText = "Remove from favorites";
        }
      })
      .catch((error) => {
        console.error("Check initial favorite status error:", error);
      });
  }
}


function addFavoritesAlbum() {
  const favoriteButton = document.getElementById("favoriteAlbumButton");
  if (!favoriteButton) {
    return;
  }
  const albumID = favoriteButton.getAttribute("albumID");
  fetch("/check_album_favorite_status/" + albumID)
    .then((response) => {
      if (response.ok) {
        return response.text();
      }
      throw new Error("Network response was not ok.");
    })
    .then((data) => {
      if (data.trim() === "unfavorited") {
        fetch("/favorite_album/0/" + albumID, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              favoriteButton.innerText = "Remove from favorites";
            } else {
              throw new Error("Unfavorite request failed.");
            }
          })
          .catch((error) => {
            console.error("Unfavorite error:", error);
          });
      } else if (data.trim() === "favorited") {
        fetch("/favorite_album/1/" + albumID, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              favoriteButton.innerText = "Add to favorites";
            } else {
              throw new Error("Favorite request failed.");
            }
          })
          .catch((error) => {
            console.error("Favorite error:", error);
          });
      }
    })
    .catch((error) => {
      console.error("Toggle favorite error:", error);
    });
}

function checkInitialFavoriteStatusAlbum() {
  const favoriteButton = document.getElementById("favoriteAlbumButton");
  if (favoriteButton) {
    const albumID = favoriteButton.getAttribute("albumID");
    fetch("/check_album_favorite_status/" + albumID)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok.");
        }
        return response.text();
      })
      .then((data) => {
        if (data.trim() === "unfavorited") {
          favoriteButton.innerText = "Add to favorites";
        } else if (data.trim() === "favorited") {
          favoriteButton.innerText = "Remove from favorites";
        }
      })
      .catch((error) => {
        console.error("Check initial favorite status error:", error);
      });
  }
}

function savePlaylist() {
  const saveButton = document.getElementById("saveButton");
  if (!saveButton) {
    return;
  }
  const playlistID = saveButton.getAttribute("playlistID");
  fetch("/check_save_status/" + playlistID)
    .then((response) => {
      if (response.ok) {
        return response.text();
      }
      throw new Error("Network response was not ok.");
    })
    .then((data) => {
      if (data.trim() === "unsaved") {
        fetch("/save/0/" + playlistID, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              saveButton.innerText = "Remove from saved";
            } else {
              throw new Error("Unsave request failed.");
            }
          })
          .catch((error) => {
            console.error("Unsave error:", error);
          });
      } else if (data.trim() === "saved") {
        fetch("/save/1/" + playlistID, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              saveButton.innerText = "Save";
            } else {
              throw new Error("Save request failed.");
            }
          })
          .catch((error) => {
            console.error("Save error:", error);
          });
      }
    })
    .catch((error) => {
      console.error("Toggle save error:", error);
    });
}

function checkInitialSaveStatus() {
  const saveButton = document.getElementById("saveButton");
  if (saveButton) {
    const playlistID = saveButton.getAttribute("playlistID");
    fetch("/check_save_status/" + playlistID)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok.");
        }
        return response.text();
      })
      .then((data) => {
        const saveButton = document.getElementById("saveButton");
        if (data.trim() === "unsaved") {
          saveButton.innerText = "Save";
        } else if (data.trim() === "saved") {
          saveButton.innerText = "Remove from saved";
        }
      })
      .catch((error) => {
        console.error("Check initial save status error:", error);
      });
  }
}

function toggleUserFollow() {
  const followButton = document.getElementById("userFollowButton");
  const user = followButton.getAttribute("user");
  fetch("/check_user_following_status/" + user)
    .then((response) => {
      if (response.ok) {
        return response.text();
      }
      throw new Error("Network response was not ok.");
    })
    .then((data) => {
      if (data.trim() === "not_following") {
        fetch("/follow_user/0/" + user, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              followButton.innerText = "Following";
              updateUserFollowersCount();
            } else {
              throw new Error("Unfollow request failed.");
            }
          })
          .catch((error) => {
            console.error("Unfollow error:", error);
          });
      } else if (data.trim() === "following") {
        fetch("/follow_user/1/" + user, { method: "POST" })
          .then((response) => {
            if (response.ok) {
              followButton.innerText = "Follow";
              updateUserFollowersCount();
            } else {
              throw new Error("Follow request failed.");
            }
          })
          .catch((error) => {
            console.error("Follow error:", error);
          });
      }
    })
    .catch((error) => {
      console.error("Toggle follow error:", error);
    });
}

function checkInitialUserFollowStatus() {
  const followButton = document.getElementById("userFollowButton");
  if (followButton) {
    const user = followButton.getAttribute("user");
    fetch("/check_user_following_status/" + user)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok.");
        }
        return response.text();
      })
      .then((data) => {
        if (data.trim() === "not_following") {
          followButton.innerText = "Follow";
        } else if (data.trim() === "following") {
          followButton.innerText = "Following";
        }
      })
      .catch((error) => {
        console.error("Check initial follow status error:", error);
      });
  }
}

function updateUserFollowersCount() {
  const followButton = document.getElementById("userFollowButton");
  const user = followButton.getAttribute("user");
  fetch("/get_user_follower_count/" + user)
    .then((response) => {
      if (response.ok) {
        return response.text();
      }
      throw new Error("Network response was not ok.");
    })
    .then((count) => {
      const followingCount = document.getElementById("followerCount");
      if (followingCount) {
        followingCount.innerText = count;
      }
    })
    .catch((error) => {
      console.error("Followers count update error:", error);
    });
} 


function checkInitialStatus() {
  checkInitialFollowStatus();
  checkInitialFavoriteStatus();
  checkInitialFavoriteStatusAlbum();
  checkInitialPlaylistStatus();
  checkInitialSaveStatus();
  checkInitialUserFollowStatus();
}

onload = function () {
  closeNav();
  checkInitialStatus();
};
