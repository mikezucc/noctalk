var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var usersconnected = 0;
var usersList = {};
var userSocketList = {};
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
        // userSocketList[credentialData['nochandle']] = socket.id;
        socket.join(credentialData['nochandle']);
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
      // delete userSocketList[currentUser];
      io.sockets.emit('noclist update', { listOfUsers: usersList });
      console.log('noc disconnected');
    });
    socket.on('chat sent', function(payloadDict){
        var targetData = payloadDict['target'];
        console.log(payloadDict['noc'] + ' sent chat to ' + targetData + " >> " + payloadDict['message']);
        if (targetData == "everybody")
        {
          console.log("sending everyone");
          io.sockets.emit('chat incoming', payloadDict);
        }
        else
        {
          // var sk = userSocketList[targetData];
          io.sockets.in(payloadDict['target']).emit('chat incoming', payloadDict);
        }
    });
    socket.on('noc typing active', function(payloadDict){
        var targetData = payloadDict['chat'];
        console.log(payloadDict['noc'] + ' started typing to ' + targetData);
        if (targetData == "everybody")
        {
          io.sockets.emit('noc typing update start', payloadDict);
        }
        else
        {
          // var sk = userSocketList[targetData];
          io.sockets.in(payloadDict['target']).emit('noc typing update start', payloadDict);
        }
    });
    socket.on('noc typing event', function(payloadDict){
        var targetData = payloadDict['chat'];
        console.log(payloadDict['noc'] + ' typing to ' + targetData + ' >> ' + payloadDict['message']);
        if (targetData == "everybody")
        {
          io.sockets.emit('noc typing eventbrc', payloadDict);
        }
        else
        {
          // var sk = userSocketList[targetData];
          io.sockets.in(targetData).emit('noc typing eventbrc', payloadDict);
        }
    });
});

http.listen(3000, function(){
  console.log('listening on *:3000');
});