var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var usersconnected = 0;
var usersList = {};
var chatHistory = {};
var userTypingList = {};
var notificationHistory = [];

io.on('connection', function(socket){
    usersconnected++;
    var currentUser = "";
    var currentFullname = "";
    console.log('unwired user is connected');
    socket.emit('initializeConnect', { welcome: 'handshakestart', numUsers: usersconnected });
    socket.on('handshakeauth', function(credentialData){
        console.log(credentialData['nochandle'] + ' successful handshake');
        socket.emit('handshakecomplete', { success: 'success' });
        currentUser = credentialData['nochandle'];
        currentFullname = credentialData['fullname'];
        usersList[credentialData['nochandle']] = {fullname: credentialData['fullname']};
        io.sockets.emit('noclist update', { listOfUsers: usersList });
        io.sockets.emit('noc connected', { nochandle: credentialData['nochandle'], fullname: credentialData['fullname'] });
        socket.emit('noti history', { notiHistory: notificationHistory });
        var connectedString = currentFullname.concat(" connected!");
        if (notificationHistory.length >= 20)
        {
            notificationHistory.shift();
        }
        notificationHistory.push(connectedString);
    });
    socket.on('disconnect', function(){
      usersconnected--;
      var disconnectedString = currentFullname.concat(" disconnected!");
      if (notificationHistory.length >= 20)
      {
          notificationHistory.shift();
      }
      notificationHistory.push(disconnectedString);
      delete usersList[currentUser];
      io.sockets.emit('noclist update', { listOfUsers: usersList });
      console.log('noc disconnected');
    });
    socket.on('chat sent', function(payloadDict){
        var targetData = payloadDict['target'];
        console.log(payloadDict['noc'] + ' sent chat to ' + targetData + " >> " + payloadDict['message']);
        if (targetData == currentUser || targetData == "everybody")
        {
          socket.emit('chat incoming', payloadDict);
        }
    });
    socket.on('noc typing active', function(payloadDict){
        var targetData = payloadDict['chat'];
        console.log(payloadDict['noc'] + ' started typing to ' + targetData);
        if (targetData == currentUser || targetData == "everybody")
        {
          socket.emit('noc typing update start', payloadDict);
        }
    });
    socket.on('noc typing event', function(payloadDict){
        var targetData = payloadDict['chat'];
        console.log(payloadDict['noc'] + ' typing to ' + targetData + ' >> ' + payloadDict['message']);
        if (targetData == currentUser || targetData == "everybody")
        {
          socket.emit('noc typing eventbrc', payloadDict);
        }
    });
});

http.listen(3000, function(){
  console.log('listening on *:3000');
});