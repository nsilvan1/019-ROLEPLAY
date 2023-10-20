const { io } = require("socket.io-client");
const fetch = require('./fetch')

const socket = io("http://localhost:3333");

const prefix = "bot:"
const responsePrefix = `${prefix}response:`

const emitServerEvent = (event, ...args) => emit(prefix + event, ...args);

socket.on("connect", () => {
  console.log('Conexão estabelecida: ' + socket.id);
});

// Commands
socket.on("send:bot", (data) => {
  console.log(data)

  socket.emit("receiver:bot",data);
});

socket.on("kick", ({ id, reason }) => {
  emitServerEvent("kick", id, reason);
});

socket.on("ban", ({ id, reason, adminId }) => {
  emitServerEvent("ban", id, reason, adminId);
});

socket.on("unban", ({ id, reason, adminId }) => {
  emitServerEvent("unban", id, reason, adminId);
});

socket.on("group", ({ id, group, adminId }) => {
  emitServerEvent("group", id, group, adminId);
});

socket.on("ungroup", ({ id, group, adminId }) => {
  emitServerEvent("ungroup", id, group, adminId);
});

socket.on("money", ({ id, money, adminId }) => {
  emitServerEvent("money", id, money, adminId);
});

socket.on("addcoins", ({ id, coins, author }) => {
  emitServerEvent("addcoins", id, coins, author);
});

socket.on("remcoins", ({ id, coins, author }) => {
  emitServerEvent("remcoins", id, coins, author);
});

socket.on("resetp", ({ id }) => {
  emitServerEvent("resetp", id);
});

socket.on("god", ({ id }) => {
  emitServerEvent("god", id);
});

socket.on("gud", ({ id }) => {
  emitServerEvent("gud", id);
});

socket.on("skin", ({ id, skin }) => {
  emitServerEvent("skin", id, skin);
});

socket.on("prender", ({ id, crimes, time }) => {
  emitServerEvent("prender", id, crimes, time);
});

socket.on("desprender", ({ id }) => {
  emitServerEvent("desprender", id);
});

socket.on("staff", ({ channel }) => {
  emitServerEvent("staff", channel);
});

socket.on("players", ({ channel }) => {
  emitServerEvent("players", channel);
});

socket.on("pegar", ({ userId, author }) => {
  emitServerEvent("pegar", Number(userId), author);
});

socket.on("pegarall", ({ userId, author }) => {
  emitServerEvent("pegarall", Number(userId), author);
});

socket.on("unwl", ({ id }) => {
  emitServerEvent("unwl", id);
});

// Responses
onNet(responsePrefix + 'prender', (id, crimes, time,channel) => {
  fetch('channels/1164603857909841921/messages', 'POST', {
    content: '',
    tts: false,
    embed: {
      author: {
        name: `${id} foi preso por ${crimes}, ${time} meses.`,
      },
      description: prender,
      timestamp: new Date(),
      color: 0x7289DA,
    }
  })
})

onNet(responsePrefix + 'staff', (staffQuantity, staffs,channel) => {
  fetch('channels/1164603857909841921/messages', 'POST', {
    content: '',
    tts: false,
    embed: {
      author: {
        name: `Quantidade de staffs online: ${staffQuantity}`,
      },
      description: staffs,
      timestamp: new Date(),
      color: 0x7289DA,
    }
  })
})

onNet(responsePrefix + 'pegar', (userId, author) => { 
  fetch('channels/1164603857909841921/messages', 'POST', {
    content: '',
    tts: false,
    embed: {
      author: {
        name: 'ADMIN',
      },
      description: `<@${author}> pegou a tela do ID: ${userId}`,
      timestamp: new Date(),
      color: 0x7289DA,
    }
  })
})
onNet(responsePrefix + 'pegarall', (userId, author) => {
  fetch('channels/1164603857909841921/messages', 'POST', {
    content: '',
    tts: false,
    embed: {
      author: {
        name: 'ADMIN',
      },
      description: `<@${author}> pegou a tela de todos os players.`,
      timestamp: new Date(),
      color: 0x7289DA,
    }
  })
})

onNet(responsePrefix + 'log', (description) => {
  fetch('channels/1164603857909841921/messages', 'POST', {
    content: '',
    tts: false,
    embed: {
      author: {
        name: `Logs`,
      },
      description,
      timestamp: new Date(),
      color: 0x7289DA,
    }
  })
})