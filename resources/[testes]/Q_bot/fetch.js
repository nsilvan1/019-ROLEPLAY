const axios = require('axios').default

module.exports = (endpoint, method, data) => axios(`https://discord.com/api/${endpoint}`,
    {
        method,
        data,
        headers: {
            Authorization: `Bot NzY3ODAxMTMzOTAwNDk2OTU3.X43Mhw.w0o2_hSh0iKzCESm8K29yioI-B4`,
            'Content-Type': 'application/json'
        }
    }).catch((error) => console.log('Erro', error))