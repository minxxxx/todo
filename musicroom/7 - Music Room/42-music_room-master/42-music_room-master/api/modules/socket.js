'use strict';

const playlistModel = require('../models/playlist');
const eventModel    = require('../models/event');

// if (!this.roomUsersIndex)
//     this.roomUsersIndex = [];
this.sortTracksByScore = (tracks) => {
    
    let tmpArray = tracks.reduce( (acc, elem) => {
        if (elem.status === 0) acc['toSort'].push(elem);
        else acc['played'].push(elem);
        return acc
    }, {toSort: [], played: []})
    tmpArray.toSort.sort((a, b) => { 
        return b.like - a.like;
    })
    tracks = tmpArray.played.concat(tmpArray.toSort)
    return tracks
}
module.exports = {
    sendPlaylist: async (playlistId) => {
        try {
            return await playlistModel.findOne({_id: playlistId});
        } catch (err) {
            return err
        }
    },
    getEvent: async (eventId) => {
        try {
            let event = await eventModel.findOne({_id: eventId});
            if (event) {
                return event
            }
            return null
        } catch (err) {
            return err
        }
    },
    updateScore: (room, trackID, points, userID) => {
        room.tracks.forEach((track) => {
            if (track._id.toString() === trackID.toString()) {
                let i = track.userLike.indexOf(userID)
                let j = track.userUnLike.indexOf(userID)
                if ((points === 1 && i !== -1) || (points === -1 && j !== -1))
                    return (room)
                if (i != -1) track.userLike.splice(i, 1);
                if (j != -1) track.userUnLike.splice(j, 1);
                points > 0 ? track.userLike.push(userID) : track.userUnLike.push(userID)
                track.like += points
            } 
        })
        return room
    },
    updateRoom: (tmpRoom) => {
        let ret = null;
        this.rooms.forEach((room) => {
            if (room.id === tmpRoom.id) {
                room.tracks = this.sortTracksByScore(tmpRoom.tracks)
                room.users  = tmpRoom.users;
                ret = room;
            }
        })
        return ret
    },
    updateTrackStatus: async (eventID, trackID) => {
        try {
            return await eventModel.findOneAndUpdate( {_id: eventID}, {currentTrack:trackID});
        } catch (e) {
            throw e
        }
    },
    updateStatus: async (eventId, trackID) => {
        try {
            return await eventModel.findOneAndUpdate({_id: eventId}, {'isPlaying': trackID}, {new: true})
        } catch (e) {
            return e
        }
    },
    // manageRooms: (type, roomID, userID) => {
    //     let currentRoom = {};

    //     if (type === 'join') {
    //         if (!this.roomUsersIndex || this.roomUsersIndex.length === 0)
    //         {
    //             currentRoom.id = roomID
    //             currentRoom.users = [userID]
    //             this.roomUsersIndex.push(currentRoom);
    //             return true
    //         } else {
    //             for (var i = 0; i < this.roomUsersIndex.length; i++) {
    //                 let room = this.roomUsersIndex[i];
    //                 if (room.id === roomID)
    //                 {
    //                     if (room.users.indexOf(userID) === -1) {
    //                         room.users.push(userID)
    //                         return true
    //                     }
    //                     else
    //                         return false
    //                 }
    //                 currentRoom.id = roomID
    //                 currentRoom.users = [userID]
    //                 this.roomUsersIndex.push(currentRoom);
    //                 return true
    //             }
    //         }
    //     }
    //     else {
    //         for (var i = 0; i < this.roomUsersIndex.length; i++) {
    //             let room = this.roomUsersIndex[i];
    //             if (room.id === roomID)
    //             {
    //                 let j = 0;
    //                 if ( (j = room.users.indexOf(userID)) != -1) {
    //                     room.users.splice(j, 1)
    //                 }
    //                 else
    //                     return false
    //             }
    //         }
    //     }
    // },
    getRoom: (roomID) => {
        let ret = null
        if (this.rooms) {
            for (let elem of this.rooms) {
                if (elem.id === roomID) {
                    ret = elem
                    break
                }
            }
        }
        return ret;
    },
    saveNewEvent: async (newEvent) => {
        if (newEvent._id)
            return await eventModel.updateOne({_id: newEvent._id}, newEvent, {new: true})
    },
    updatePlayStatus: async (roomID, value) => {
        if (roomID)
            return await eventModel.updateOne({_id: roomID}, {is_play:value}, {new: true})
    },
    updateEventTracks : async (eventId, tracks) => {
        try {
            return await eventModel.findOneAndUpdate({_id: eventId}, {'playlist.tracks.data': tracks}, {new: true})
        }catch (e) {
            return e
        }
    }
};
