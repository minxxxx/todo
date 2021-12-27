'use strict';

const ftSocket = require('./socket');

module.exports = function (io) {
    let playlistBlocked = []
    io.on('connection', (socket) => {

        /* Socket For Playlist */

        socket.on('updatePlaylist', async (playlistId) => {
            console.log("JE SUIS LA ET JE VAIS updatePLaylist")
            let playlist = await ftSocket.sendPlaylist(playlistId)
            playlistBlocked.splice(playlistBlocked.indexOf(playlistId), 1)
            socket.to(playlistId).emit('playlistUpdated', playlist)
        });
        socket.on('blockPlaylist', (playlistId) => {
            console.log("BLOCK PLAYLIST -> " + playlistId)
            console.log(playlistBlocked)
            console.log(playlistBlocked.indexOf(playlistId))
            if (playlistBlocked.indexOf(playlistId) === -1) {
                playlistBlocked.push(playlistId)
                console.log("BLOCK PLAYLIST EVENT")
                setTimeout(() => {
                    if (playlistBlocked.indexOf(playlistId) !== -1) {
                        io.in(playlistId).emit('playlistUpdated');
                        console.log("UNLOCK")
                    }
                }, 5000)
            }
            socket.to(playlistId).emit('blockPlaylist')
        });
        socket.on('joinPlaylist', (playlistId) => {
            console.log("[Socket] -> joinPlaylist", playlistId)
            socket.join(playlistId);
            console.log("Nb clients in room " + playlistId + " -> " + io.sockets.adapter.rooms[playlistId].length)
        });
        socket.on('leavePlaylist', (playlistId) => {
            console.log("[Socket] -> leavePlaylist")
            socket.leave(playlistId);
            if (io.sockets.adapter.rooms[playlistId])
                console.log("Nb clients in room " + playlistId + " -> " + io.sockets.adapter.rooms[playlistId].length)
            else
                console.log("No more room for " + playlistId)
        });
        /* Socket For LiveEvent */
        socket.on('getRoomPlaylist', async (roomID) => {
            console.log("[Socket] -> getRoomPlaylist")
            try {
                let event = await ftSocket.getEvent(roomID);
            console.log(event)
            console.log(event.isPlaying)
            io.sockets.in(roomID).emit('getRoomPlaylist', event.playlist.tracks.data, event.isPlaying)
            } catch (e) {
                io.sockets.in(roomID).emit('error', e.message)
            }

            
        });

        socket.on('createRoom', (roomID, userID) => {
            /* For Swift Team */
            if (typeof roomID === 'object') {
                let obj = JSON.parse(roomID);
                roomID = obj.roomID
                userID = obj.userID
            }
            socket.join(roomID);
        });
        socket.on('leaveRoom', (roomID, userID) => {
            /* For Swift Team */
            if (typeof roomID === 'object') {
                let obj = JSON.parse(roomID);
                roomID = obj.roomID
                userID = obj.userID
            }
            console.log("[Socket] -> leaveRoom")
            //ftSocket.manageRooms("leave", roomID, userID)
            socket.leave(roomID);
            if (io.sockets.adapter.rooms[roomID])
                console.log("Nb clients in room " + roomID + " -> " + io.sockets.adapter.rooms[roomID].length)
            else
                console.log("No more room for " + roomID)
        });
        socket.on('updateTracks', async (roomID, tracks) => {
            try {
            console.log("[Socket] -> updateTracks")
              /* For Swift Team */
              if (typeof roomID === 'object') {
                let obj = JSON.parse(roomID);
                roomID = obj.roomID
                tracks = obj.tracks
            }
            let event = await ftSocket.updateEventTracks(roomID, tracks)
            io.sockets.in(roomID).emit('updateTracks', event.playlist.tracks.data)
        } catch (e) {
            console.log(e)
            io.sockets.in(roomID).emit('error', e.message)
        }
        });
        socket.on('updateTrack', (roomID, track) => {
            console.log("[Socket] -> updateTrack")
              /* For Swift Team */
            if (typeof roomID === 'object') {
                let obj = JSON.parse(roomID);
                roomID = obj.roomID
                track = obj.track
            }
            /* =============== */
            let room = ftSocket.getRoom(roomID)
            if (room) {
                room.tracks.forEach(music => {
                    if (music._id === track._id)
                        music = track
                });
            }
        });
        socket.on('updateStatus', async (eventID, trackID) => {
            console.log("[Socket] -> updateStatus");
            /* For Swift Team */
            if (typeof eventID === 'object') {
                let obj = JSON.parse(eventID);
                eventID = obj.eventID;
                trackID = obj.trackID;
            }
            /* =============== */
            let tracks = await ftSocket.updateTrackStatus(eventID, trackID)
            io.in(eventID).emit('updateStatus', trackID);
        })
        socket.on('updateScore', async (roomID, userCoord) => {
            console.log("roomid -> " + roomID)
            try {
              /* For Swift Team */
            if (typeof roomID === 'object') {
                let obj = JSON.parse(roomID);
                roomID = obj.roomID
                userCoord = obj.userCoord
            }
            /* =============== */
            let event = await ftSocket.getEvent(roomID)
            io.in(roomID).emit('updateScore', event.playlist.tracks.data)

        } catch (e) {
            io.in(roomID).emit('error', e.message)
        }

        });
        socket.on('updateEvent', (roomID, newEvent) => {
            console.log("[Socket] -> updateEvent")
              /* For Swift Team */
              console.log("Update Event : ", typeof roomID)
            if (typeof roomID === 'object') {
                let obj = JSON.parse(roomID);
                roomID = obj.roomID
                newEvent = obj.newEvent
            }
            /* =============== */
            ftSocket.saveNewEvent(newEvent);
            io.in(roomID).emit('updateEvent', newEvent);
        });
        /* Socket for Player */
        socket.on('updatePlayer', (roomID, newEvent, data) => {
            console.log("[Socket] -> updatePlayer");
            /* For Swift Team */
            if (typeof roomID === 'object') {
                let obj = JSON.parse(roomID);
                roomID = obj.roomID
                newEvent = obj.newEvent
            }
            if (newEvent === 'pause' || newEvent === 'play')
                ftSocket.updatePlayStatus(roomID, newEvent === 'pause' ? false : true)
            /* =============== */
            console.log(newEvent)
            io.in(roomID).emit('updatePlayer', newEvent, data);
        })
    });
    io.on('disconnect', (socket) => {
        console.log("IN SOCKET DISCONNECT", socket)
    });
};
