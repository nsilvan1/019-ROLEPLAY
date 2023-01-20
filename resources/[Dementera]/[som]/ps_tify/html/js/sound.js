
var soundSpt = {}
// var vol = 50
var retorno = {}
var idXBL = ''
var closedApp = false
$(() => {
    soundSpt.init();
    $("#playerOffLine").hide()
    window.addEventListener("message", function (event) {
        switch (event.data.action) {
            case "openUI":
                console.log('entrou aqui')
                $("#principal").show()
                retorno = event.data
                vol = retorno.volume
                Radios_volum = vol
                volumeMusic = vol
                $('.player__volume_bar').attr('style', `width: ${vol}%`)
                token = retorno.token
                license = retorno.license
                youtube_key = retorno.youtube
                linkmusic = retorno.linkurl
                playSound = retorno.playSound
                idXBL = retorno.idXbl
                if (playSound) {
                    total = retorno.total
                    played = retorno.played
                } else {
                    total = '0'
                    played = '0'
                }
                $(".playerOffLine").hide()
                carregaPlaylist()
                break;
            case "changetextv":
                retorno = event.data
                Radios_volum = retorno.vol
                volumeMusic = retorno.volume
                $('.player__volume_bar').attr('style', `width: ${volumeMusic}%`)
                break;
            case "TimeVid":
                retorno = event.data
                total = retorno.total
                played = retorno.played
                timeProgessVideo(total, played)
                break;
            case "NextMusic":
                retorno = event.data
                closedApp = retorno.close
                nextMusic(closedApp);
                break;
            case "changetextl":
                retorno = event.data
                loop = retorno.loop
                break;
            case "closeUI":
                close()
                break;
        }
    });
})
soundSpt = {
    init: function () {
        document.onkeyup = function (data) {
            if (data.which == 27) {
                $("#principal").hide()
                $("#playerOffLine").hide()
                close()
            }
            if (data.which == 38) {
                execute('volUp')
            }
            if (data.which == 40) {
                execute('volDown')
            }
            if (data.which == 37) {
                execute('back')
            }
            if (data.which == 39) {
                execute('forward')
            }
            if (data.which == 32) {
                execute('play')
            }

        }
    }
}

function close() {
    $("#principal").hide()
    $.post("http://ps_tify/action", JSON.stringify({ action: "exit" }));
}

function closeplaylist() {
    $("#principal").hide()
    $.post("http://ps_tify/action", JSON.stringify({ action: "closeplaylist" }));
}


$("#play").click(function () {
    execute('play')
});

$("#pause").click(function () {
    execute('pause')
});

$("#loop").click(function () {
    execute('loop')
});

$("#anterior").click(function () {
    execute('back')
});

$("#proximo").click(function () {
    execute('forward')
});

$("#proximo").click(function () {
    execute('forward')
});


var elems = document.querySelectorAll('[data-target]');
for (var i = 0; i < elems.length; i++) {
    elems[i].addEventListener('click', function () {
        atrib(this.getAttribute('data-target'))
    });
}

function postPlaylist() {
    let playlist = $("#btnPlaylist").val();
    var settings = {
        "url": "http://189.1.172.114:5003/playlist",
        "method": "POST",
        "timeout": 0,
        "headers": {
            "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "nome": playlist,
            "id_xbl": idXBL
        }),
    };

    $.ajax(settings).done(function (response) {
        if (response.error) {
            $("#errorCreatePlaylist").show()
        } else {
            $("#addSongPlaylist").show()
            $("#btnEditPlaylist").show()
            $("#btnAddPlaylist").hide()
            $("#btnIdPlaylist").val(response.id)
        }
    });
}

function myplaylist() {
    let myplaylist = [];
    let playlist = ``;
    $("#listPlaylist").empty();
    var settings = {
        "url": "http://189.1.172.114:5003/playlist/getPlaylist/" + idXBL,
        "method": "GET",
        "timeout": 0,
    };

    $.ajax(settings).done(function (response) {
        playlist += `<table class="table" style="width: 91%;">
        <thead>
        <tr>
            <th  Titulo </th>
            <th> </th>
        </tr>
        </thead>
        <tbody>`
        myplaylist = response.response
        for (let i = 0; i < myplaylist.length; i++) {
            let loop = myplaylist[i]
            playlist += `<tr> 
            <td ><a data-gender="RapCaviar" onclick="myMusicList(${loop.id}, '${loop.nome}')">${loop.nome}</a></td>
            <td >
            <td> <a onclick="removePlaylist('${loop.id}')"><img class="player__icon player_play paused" id="play" src="./img/trash.svg" alt="Player"></a>            
            `
            playlist += `</tr>`

        }
        playlist += `</tbody></table>`
        $('#listPlaylist').append(playlist); 
    });
}


function removePlaylist(id) {
    console.log(id)
    var settings = {
        "url": "http://189.1.172.114:5003/playlist/remove/playlist/" + id,
        "method": "POST",
        "timeout": 0,
    };

    $.ajax(settings).done(function (response) {
        console.log(JSON.stringify(response))
        myplaylist();
    });
}

function myMusicList(idPlaylist, nome) {
    $('#btnIdPlaylist').val(idPlaylist);
    $('#btnPlaylist').val(nome);
    atrib('myPlaylist')
}


function carregaPlaylist() {
    $("#inner-strip").empty();
    let topPlaylist = ''
    var settings = {
        "url": "http://189.1.172.114:5003/playlist/topPlaylist/",
        "method": "GET",
        "timeout": 0,
    };

    $.ajax(settings).done(function (response) {
        let playlist = response.response
        let table = 1 
        let max = playlist.length
        let par = false
        topPlaylist += ` <table style="width: 100%;">`
        if (((max/2) % 2) == 0 ){
            par = true 
        }
        for (let i = 0; i < max; i++) {
            let loop = playlist[i]
            let img = "https://cdn.discordapp.com/attachments/908124664654602280/1023686642529214606/Elite_Community_Perfil.png"
          
                if( table == 1 ){
                    topPlaylist += `   
                    <tr>
                        <td>  
                            <table>
                                <tr>
                                    <td style="width: 20%;">
                                        <a onclick="playGlobalPlaylist('${loop.id}', '${loop.nome}', '${loop.icone}','${loop.idlike}')"> <img src="${img}" 
                                        alt="Foto de perfil"  class="account__photo" ></a>
                                    </td>
                                    <td style="font-size: 12px;width: 30%; " >
                                            <h4>${loop.nome}</h4>
                                            <h4>${loop.likes} likes</h4>
                                    </td> `
                                table += 1
                           if (max == (i + 1 ) && !par ){
                            console.log('entrou aqui ')
                            topPlaylist += `      
                                        <td style="width: 20%;">                                           
                                        </td>
                                        <td style="font-size: 12px;width: 30%; " >                                           
                                        </td>
                                    </tr> 
                                </table>
                                </td>                    
                            </tr>` 
                           }
                } else {
                        topPlaylist += `      
                                    <td style="width: 20%;">
                                        <a onclick="playGlobalPlaylist('${loop.id}', '${loop.nome}', '${loop.icone}','${loop.idlike}')"> <img src="${img}" 
                                        alt="Foto de perfil"  class="account__photo" ></a>
                                    </td>
                                    <td style="font-size: 12px;width: 30%; " >
                                            <h4>${loop.nome}</h4>
                                            <h4>${loop.likes} likes</h4>
                                    </td>
                                </tr> 
                            </table>
                            </td>                    
                        </tr>` 
                    table -= 1
                }    
                    
        }
        topPlaylist += ` </table>  ` 
        $('#inner-strip').append(topPlaylist);
    });
}


