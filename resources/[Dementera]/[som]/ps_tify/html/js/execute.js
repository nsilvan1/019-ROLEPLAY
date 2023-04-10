var playKey = true
var vol = 50
var urlYoutube = 'https://www.youtube.com/watch?v='
var idGlobal, nameGlobal, likeGlobal, idLikeGlobal
var listSing = []
var lastId = 0
function execute(type, videoId = '') {
    switch (type) {
        case 'play':
            if (playKey) {
                $.post("http://ps_tify/action", JSON.stringify({ action: "play", link: videoId }));
                playKey = false
            } else {
                $.post("http://ps_tify/action", JSON.stringify({ action: "pause" }));
                playKey = true
            }
            break
        case 'volUp':
            $.post("http://ps_tify/action", JSON.stringify({ action: "volumeup" }));
            // if (vol <= 100) {
            //     vol += 5
            //     $('.player__volume_bar').attr('style', `width: ${vol}%`)
            // } else {
            //     $('.player__volume_bar').attr('style', `width: 100%`)
            // }
            break
        case 'volDown':
            $.post("http://ps_tify/action", JSON.stringify({ action: "volumedown" }));
            // if (vol > 0) {
            //     vol -= 5
            //     $('.player__volume_bar').attr('style', `width: ${vol}%`)
            // } else {
            //     $('.player__volume_bar').attr('style', `width: 0%`)

            // }
            break
        case 'back':
            $.post("http://ps_tify/action", JSON.stringify({ action: "back" }));
            break
        case 'forward':
            $.post("http://ps_tify/action", JSON.stringify({ action: "forward" }));

            break
        case 'loop':
            $.post("http://ps_tify/action", JSON.stringify({ action: "loop" }));
            break
        case 'find':
            find = $("#btnFind").val()
            if (find) {
                makeRequest(find, 'pesquisar');
            }
            break
        default:
            break

    }
}

function clearHome() {
    $(".resultado").hide()
    $(".collection-strip").hide()
    $(".createPlaylist").hide()
    $(".myPlaylistList").hide()
    $(".createPlaylistGlobal").hide()
    $("#addSongPlaylist").hide()
    $('#search').removeClass('active');
    $('#home').removeClass('active');
    $('#createPlaylist').removeClass('active');
    $('#myPlaylistList').removeClass('active')
    $(".addPlaylistlist").empty();
    $(".playlist_list").empty();
    $("#globalPlaylist").empty();
    $("#btnPlaylistGlobal").hide()
    $("#headerPrincipal").hide()

}

function atrib(type) {
    switch (type) {
        case 'search':
            clearHome()
            $(".resultado").show()
            $('#search').addClass('active');
            break;
        case 'home':
            clearHome()
            $('#home').addClass('active');
            $(".collection-strip").show()
            $("#headerPrincipal").show()
            $("#txtFindPlaylist").val('')
            break;
        case 'createPlaylist':
            clearHome()
            $('#btnIdPlaylist').val('')
            $('#btnPlaylist').val('')
            $('#createPlaylist').addClass('active');
            $(".createPlaylist").show()
            $("#btnAddPlaylist").show()
            $("#btnEditPlaylist").hide()
            $("#sondAddPlaylist").empty();
            break;
        case 'myPlaylist':
            clearHome()
            $('#createPlaylist').addClass('active');
            $(".createPlaylist").show()
            $("#addSongPlaylist").show()
            $("#btnEditPlaylist").show()
            $("#btnAddPlaylist").hide()
            let idPlaylist = $('#btnIdPlaylist').val();
            getMusicPlaylist(idPlaylist)
            break;
        case 'playlistGlobal':
            clearHome()
            $(".resultado").show()
            getPlaylistGlobal()
            break;
        case 'playlistMusicGlobal':
            clearHome()
            $(".createPlaylistGlobal").show()
            getPlaylistGlobalMsic()
            break;
        case 'myPlaylistList':
            clearHome()
            $(".myPlaylistList").show()
            $('#myPlaylistList').addClass('active')
            myplaylist()
            break;

    }
}

function clearplaysong() {
    // $("#error").hide()
    $("#song").hide()
}

function playGlobalPlaylist(id, name, like, idlike) {
    idGlobal = id;
    nameGlobal = name;
    likeGlobal = like;
    idLikeGlobal = idlike
    atrib('playlistMusicGlobal')
}

function getPlaylistGlobalMsic() {
    $(".createPlaylistGlobal").show()
    $("#btnIdPlaylistGlobal").val(idGlobal)
    $("#btnPlaylistGlobal").val(nameGlobal)
    $("#btnPlaylistGlobal").show()


    if (likeGlobal == 'like') {
        $("#btnLike").show()
        $("#btnUnlike").hide()
    } else {
        $("#btnLike").hide()
        $("#btnUnlike").show()
    }
    getMusicPlaylistGlobal(idGlobal)
}

function makeRequestPrincipal() {
    clearplaysong('Pesquisar');
    find = $("#txtFindPrincipal").val()
    makeRequest('Pesquisar', find)
}

function makeRequest(menu, pesquisar) {
    let playlist = ''
    if (menu == 'Pesquisar') {
        playlist += '<h1 class="song__main-title">Resultados</h1>'
        $(".playlist_list").empty();
        find = pesquisar ? pesquisar : $("#txtFind").val()
    } else if (menu == 'criarPlaylist') {
        playlist += '<h1 class="song__main-title"> Vamos incrementar sua playlist</h1>'
        find = $("#txtFindAdd").val()
        $(".addPlaylistlist").empty();
    }
    var settings = {
        "url": "http://191.239.249.168:8080/spotify?ip=191.239.249.168&cpf=101.101.09.09",
        "method": "POST",
        "timeout": 0,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "youtube_key": "AIzaSyA605k4T6Ut_j03rnnKgA0b3BN82bpz1tE",
            "query": find
        }),
    };
    $.ajax(settings).done(function (response) {
        playlist += `<table class="table" style="width: 91%;">
                        <thead>
                        <tr>
                            <th> </th>
                            <th> Titulo </th>
                            <th> </th>
                        </tr>
                        </thead>
                        <tbody>`

        for (let i = 0; i < response.length; i++) {
            let temp = response[i]
            let nome = ''
            if (temp.snippet.title.length > 50) {
                nome = temp.snippet.title.substring(0, 30) + '...'
            } else {
                nome = temp.snippet.title
            }
            playlist += `<tr> 
                         <td><img src="${temp.snippet.thumbnails.default.url}" ></td>
                         <td style=" text-align: center; font-size: 12px; ">${nome}</td>
                         <td >`
            if (menu == 'Pesquisar') {
                playlist += ` <a onclick="playSing('${temp.id.videoId}')"><img class="player__icon player_play paused" id="play" src="./img/play.svg" alt="Player"></a>`
            } else if (menu == 'criarPlaylist') {
                playlist += ` <a onclick="adicionarFav('${temp.id.videoId}','${temp.snippet.thumbnails.default.url}','${temp.snippet.title}')"><img class="player__icon player_play paused" id="play" src="./img/plus.svg" alt="Player"></a>`
            }
            playlist += `</td></tr>`

        }
        playlist += `</tbody></table>`
        if (menu == 'Pesquisar') {
            $("#txtFind").val('');
            $("#song").show()
            $('.playlist_list').append(playlist);
            $(".playlist_list").show()
        } else if (menu == 'criarPlaylist') {
            $("#txtFindAdd").val('')
            $("#song").show('')
            $('.addPlaylistlist').append(playlist);
            $(".addPlaylistlist").show()
        }
    }).fail(function (data) {
        // aqui devemos colocar a msg de erro
        alert("Try again champ!");
    });;


}

function adicionarFav(videoId, urlVideo, nome) {
    let idPlaylist = $("#btnIdPlaylist").val()
    var settings = {
        "url": "http://189.1.172.114:5003/playlist/music",
        "method": "POST",
        "timeout": 0,
        "headers": {
            "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "id_playlist": idPlaylist,
            "video_url": videoId,
            "imageUrl": urlVideo,
            "nome": nome
        }),
    };

    $.ajax(settings)
        .done(function (response) {
            getMusicPlaylist(idPlaylist)
        }).fail(function (data) {
            alert("Try again champ!");
        });

}

function getMusicPlaylist(id) {
    $("#sondAddPlaylist").empty();
    let playlist = '<h1 class="song__main-title">Adicionadas</h1>'
    var settings = {
        "url": `http://189.1.172.114:5003/playlist/${id}/playMusic`,
        "method": "GET",
        "timeout": 0,
    };

    $.ajax(settings).done(function (response) {
        playlist += `<table class="table">
        <thead>
        <tr>
            <th> </th>
            <th> Titulo </th>
            <th> </th>
            <th> </th>
        </tr>
        </thead>
        <tbody>`
        listSing = response.response
        for (let i = 0; i < listSing.length; i++) {
            let temp = listSing[i]
            playlist += `<tr> 
         <td><img src="${temp.imageUrl}" ></td>
         <td style=" text-align: center; ">${temp.nome}</td>
         <td> <a onclick="playSingList('${i}')"><img class="player__icon player_play paused" id="play" src="./img/play.svg" alt="Player"></a>            
         <td> <a onclick="removeSing('${temp.id}','${id}')"><img class="player__icon player_play paused" id="play" src="./img/trash.svg" alt="Player"></a>            
         </td></tr>`

        }
        playlist += `</tbody></table>`
        $('#sondAddPlaylist').append(playlist);
        $("#sondAddPlaylist").show()

    }).fail(function (data) {
        alert("Try again champ!");
    });
}

function getMusicPlaylistGlobal(id) {
    $("#sondAddPlaylistGlobal").empty();
    let playlist = '<h1 class="song__main-title">Adicionadas</h1>'
    var settings = {
        "url": `http://189.1.172.114:5003/playlist/${id}/playMusic`,
        "method": "GET",
        "timeout": 0,
    };

    $.ajax(settings).done(function (response) {
        playlist += `<table class="table" style=" width: 100%;">
        <thead>
        <tr>
            <th style=" width: 20%;"> </th>
            <th style=" width: 60%;"> Titulo </th>
            <th style=" width: 20%;"> </th>
        </tr>
        </thead>
        <tbody>`
        musicPlaylist = response.response
        for (let i = 0; i < musicPlaylist.length; i++) {
            let temp = musicPlaylist[i]
            playlist += `<tr> 
         <td><img class="imgList" src="${temp.imageUrl}" ></td>
         <td style=" text-align: center;" >${temp.nome}</td>
         <td> <a onclick="playSingList('${i}')"><img class="player__icon player_play paused" id="play" src="./img/play.svg" alt="Player"></a>                 
         </td></tr>`

        }
        playlist += `</tbody></table>`
        $('#sondAddPlaylistGlobal').append(playlist);
        $("#sondAddPlaylistGlobal").show()

    }).fail(function (data) {
        alert("Try again champ!");
    });
}

function getPlaylistGlobal() {
    $("#globalPlaylist").empty();
    let name = $("#txtFindPlaylist").val()
    let topPlaylist = ''
    let playlist = ''
    var settings = {
        "url": "http://189.1.172.114:5003/playlist/find/name/" + name + '/' + idXBL,
        "method": "GET",
        "timeout": 0,
    };


    $.ajax(settings).done(function (response) {
        let playlist = response.response
        let table = 1
        let max = playlist.length
        let par = false
        topPlaylist += ` <table style="width: 100%;">`
        if (((max / 2) % 2) == 0) {
            par = true
        }

        for (let i = 0; i < max; i++) {
            let loop = playlist[i]
            let img = "https://cdn.discordapp.com/attachments/908124664654602280/1023686642529214606/Elite_Community_Perfil.png"

            if (table == 1) {
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
                                            <h4>${loop.nome}</h4>`
                if (loop.icone == 'like') {
                    topPlaylist += `<a onclick="like('${loop.id}')"><img class="player__icon player_play paused" id="play" src="./img/heart.svg" alt="Player"></a>  `
                } else {
                    topPlaylist += `<a onclick="unlike('${loop.idlike}')"><img class="player__icon player_play paused" id="play" src="./img/unlike.svg" alt="Player"></a> `
                }
                topPlaylist += `          </td> `
                table += 1
                if (max == (i + 1) && !par) {
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
                                            <h4>${loop.nome}</h4>`
                if (loop.icone == 'like') {
                    topPlaylist += `<a onclick="like('${loop.id}')"><img class="player__icon player_play paused" id="play" src="./img/heart.svg" alt="Player"></a>  `
                } else {
                    topPlaylist += `<a onclick="unlike('${loop.idlike}')"><img class="player__icon player_play paused" id="play" src="./img/unlike.svg" alt="Player"></a> `
                }

                topPlaylist += `</td>
                                </tr> 
                            </table>
                            </td>                    
                        </tr>`
                table -= 1
            }

        }
        topPlaylist += ` </table>  `

        // let musicPlaylist = response.response
        // for (let i = 0; i < musicPlaylist.length; i++) {
        //     let temp = musicPlaylist[i]
        //       playlist += `
        //     <div class="box-item" data-gender="Trap BR">
        //         <div class="box-item__image">
        //         <a onclick="playGlobalPlaylist('${temp.id}', '${temp.nome}', '${temp.icone}','${temp.idlike}')"><img src="./img/Elite_Community_Perfil.png"></sa>
        //         </div>
        //         <h4>${temp.nome}</h4>`

        //         if (temp.icone == 'like') {
        //             playlist += `<a onclick="like('${temp.id}')"><img class="player__icon player_play paused" id="play" src="./img/heart.svg" alt="Player"></a>  `
        //         } else {
        //             playlist += `<a onclick="unlike('${temp.idlike}')"><img class="player__icon player_play paused" id="play" src="./img/unlike.svg" alt="Player"></a> `
        //         }
        //       playlist += `</div>    `

        // }

        $('#globalPlaylist').append(topPlaylist);
        $("#song").show()

    }).fail(function (data) {
        alert("Try again champ!");
    });
}


function removeSing(id, idPlaylist) {
    var settings = {
        "url": "http://189.1.172.114:5003/playlist/remove/song/" + id,
        "method": "POST",
        "timeout": 0,
    };

    $.ajax(settings).done(function (response) {
        getMusicPlaylist(idPlaylist);
    });
}

function like(id, reload = true) {
    var settings = {
        "url": "http://189.1.172.114:5003/playlist/like",
        "method": "POST",
        "timeout": 0,
        "headers": {
            "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "id_playlist": id,
            "id_xbl": idXBL
        }),
    };

    $.ajax(settings).done(function (response) {
        if (reload) {
            getPlaylistGlobal()
            carregaPlaylist()
        }
    });
}

function unlike(id, reload = true) {
    var settings = {
        "url": "http://189.1.172.114:5003/playlist/unlike",
        "method": "POST",
        "timeout": 0,
        "headers": {
            "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "idLike": id
        }),
    };

    $.ajax(settings).done(function (response) {
        if (reload) {
            getPlaylistGlobal()
            carregaPlaylist()
        }
    });
}

function editPlaylist() {
    let id = $('#btnIdPlaylist').val();
    let name = $('#btnPlaylist').val();
    var settings = {
        "url": "http://189.1.172.114:5003/playlist/edit/" + id,
        "method": "POST",
        "timeout": 0,
        "headers": {
            "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "nome": name
        }),
    };

    $.ajax(settings).done(function (response) {
        // myplaylist();
    });
}

function playSingList(Id) {
    playKey = true
    let videoId = listSing[Id].video_url
    lastId = Id
    execute('play', videoId)
}

function previoMusic() {
    let id = Number(lastId) - 1
    playSingList(id)
}

function nextMusic(closedApp = true) {
    let id = Number(lastId) + 1
    if (!closedApp) {
        if (Number(listSing.length) > id) {
            playSingList(id)
            close()
        } else {
            closeplaylist()
        }
    }

}

function playSing(videoId) {
    playKey = true
    execute('play', videoId)
}


function likePlaylist() {
    like(idLikeGlobal, false);
    $("#btnLike").hide()
    $("#btnUnlike").show()
}

function unlikePlaylist() {
    unlike(idLikeGlobal, false);
    $("#btnLike").show()
    $("#btnUnlike").hide()
}

function timeProgessVideo(total, atual) {
    let percent = (atual / total) * 100
    document.getElementsByClassName("player__time_bar")[0].style.width = percent + "%"
}