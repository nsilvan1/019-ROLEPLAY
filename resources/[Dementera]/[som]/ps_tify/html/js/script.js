var _0x3e0531 = _0x2712;
(function(_0xd5fe36, _0x52fb1a) {
    var _0x4421c8 = _0x2712,
        _0x1be1ad = _0xd5fe36();
    while (!![]) {
        try {
            var _0x2c2d33 = parseInt(_0x4421c8(0x168)) / 0x1 + parseInt(_0x4421c8(0x16e)) / 0x2 + parseInt(_0x4421c8(0x193)) / 0x3 + -parseInt(_0x4421c8(0x178)) / 0x4 * (-parseInt(_0x4421c8(0x148)) / 0x5) + -parseInt(_0x4421c8(0x141)) / 0x6 + -parseInt(_0x4421c8(0x18a)) / 0x7 * (parseInt(_0x4421c8(0x167)) / 0x8) + -parseInt(_0x4421c8(0x1a8)) / 0x9 * (parseInt(_0x4421c8(0x183)) / 0xa);
            if (_0x2c2d33 === _0x52fb1a) break;
            else _0x1be1ad['push'](_0x1be1ad['shift']());
        } catch (_0x18c540) {
            _0x1be1ad['push'](_0x1be1ad['shift']());
        }
    }
}(_0x30f0, 0x2ee51));
var Radios = [document[_0x3e0531(0x17f)](_0x3e0531(0x1ad))],
    Radios_volum = [0x1],
    estados = [!![]],
    index_user_id = [0x0],
    musicaatual = [0x1],
    linkmusic = null,
    lastmusic = null,
    user_id = null,
    volumeMusic = null,
    token = null,
    license = null,
    youtube_key = null;
$(document)[_0x3e0531(0x156)](function() {
    var _0x2356b8 = _0x3e0531;
    window[_0x2356b8(0x16b)](_0x2356b8(0x16d), function(_0x5a2cdc) {
        var _0x511b37 = _0x2356b8;
        _0x5a2cdc[_0x511b37(0x14e)][_0x511b37(0x16f)] && (user_id = _0x5a2cdc[_0x511b37(0x14e)][_0x511b37(0x16f)]);
        let _0x5c846d = _0x5a2cdc[_0x511b37(0x14e)];
        switch (_0x5c846d['action']) {
            case _0x511b37(0x143):
                $(_0x511b37(0x19d))[_0x511b37(0x144)](0xc8);
                break;
            case _0x511b37(0x162):
                $(_0x511b37(0x19d))[_0x511b37(0x137)](0xc8);
                break;
            case _0x511b37(0x155):
                getTime(_0x5c846d[_0x511b37(0x1b8)], _0x5c846d[_0x511b37(0x198)]);
                break;
            case _0x511b37(0x145):
                setVolume(_0x5c846d[_0x511b37(0x185)]);
                break;
            case _0x511b37(0x19f):
                token = _0x5c846d[_0x511b37(0x15e)], license = _0x5c846d[_0x511b37(0x142)], youtube_key = _0x5c846d['youtube'];
                break;
        }
    }), document[_0x2356b8(0x1a0)] = function(_0x588b5c) {
        var _0x74ec05 = _0x2356b8;
        _0x588b5c[_0x74ec05(0x15b)] == 0x1b && $[_0x74ec05(0x176)](_0x74ec05(0x159), JSON[_0x74ec05(0x147)]({
            'action': _0x74ec05(0x1b3)
        }));
    };
}), $(document)['on'](_0x3e0531(0x1a4), _0x3e0531(0x14b), function(_0x34b88a) {
    var _0x2f3f35 = _0x3e0531;
    _0x34b88a['preventDefault']();
    var _0x486458 = $(this)[_0x2f3f35(0x195)](_0x2f3f35(0x1b9));
    if (_0x486458 == 'home') $(_0x2f3f35(0x15c))[_0x2f3f35(0x1bb)](), $(_0x2f3f35(0x1bf))['removeClass']('active'), $(this)[_0x2f3f35(0x14f)]('active');
    else _0x486458 == 'search' && ($(_0x2f3f35(0x15c))[_0x2f3f35(0x197)](), $('.general-options\x20.target-home')[_0x2f3f35(0x1a2)](_0x2f3f35(0x153)), $(this)['addClass'](_0x2f3f35(0x153)));
}), $(document)['on'](_0x3e0531(0x1a4), _0x3e0531(0x19b), function(_0x48473f) {
    var _0x4d3080 = _0x3e0531,
        _0x14c6f7 = $(this)['attr'](_0x4d3080(0x1b4));
    searchGender(_0x14c6f7);
}), $(document)['on'](_0x3e0531(0x1a4), _0x3e0531(0x16c), function(_0x9b1b0f) {
    var _0x11647c = _0x3e0531,
        _0x154b26 = $(this)[_0x11647c(0x195)](_0x11647c(0x1b4));
    searchGender(_0x154b26);
}), $(document)['on'](_0x3e0531(0x1a4), _0x3e0531(0x190), function(_0x4e0350) {
    currentMusic(0x0), playMusic();
}), item = document[_0x3e0531(0x179)]('.playlist__item'), like = document['querySelectorAll']('.song__like'), settings = document[_0x3e0531(0x179)](_0x3e0531(0x135)), menu = document[_0x3e0531(0x1a6)](_0x3e0531(0x19c)), search = document[_0x3e0531(0x1a6)](_0x3e0531(0x196)), song = document[_0x3e0531(0x179)]('.song__title'), artist = document['querySelectorAll']('.song__artist');

function active(_0x457178) {
    var _0x3751b5 = _0x3e0531;
    for (var _0x3b5a22 = 0x0; _0x3b5a22 < item[_0x3751b5(0x184)]; _0x3b5a22++) {
        item[_0x3b5a22][_0x3751b5(0x1c1)][_0x3751b5(0x1a7)](_0x3751b5(0x17a));
    }
    this[_0x3751b5(0x1c1)]['add'](_0x3751b5(0x17a));
}

function hideLike(_0x1fa09f) {
    var _0x4bc4cc = _0x3e0531;
    this[_0x4bc4cc(0x149)][_0x4bc4cc(0x1c1)][_0x4bc4cc(0x14c)](_0x4bc4cc(0x166));
}

function sett(_0x5a103f) {
    var _0x5f318d = _0x3e0531;
    menu[_0x5f318d(0x1c1)][_0x5f318d(0x16a)](_0x5f318d(0x1b6)), menu['classList']['toggle'](_0x5f318d(0x173));
}

function filterSearch(_0x12d084) {
    var _0x341ec8 = _0x3e0531,
        _0x236d2d = search[_0x341ec8(0x14a)]['toLowerCase']();
    for (var _0x3ba2d3 = 0x1; _0x3ba2d3 < song[_0x341ec8(0x184)]; _0x3ba2d3++) {
        var _0x5b6094 = song[_0x3ba2d3][_0x341ec8(0x1a5)]['toLowerCase'](),
            _0x499f9a = artist[_0x3ba2d3][_0x341ec8(0x1a5)][_0x341ec8(0x17b)]();
        _0x5b6094[_0x341ec8(0x15d)](_0x236d2d) || _0x499f9a[_0x341ec8(0x15d)](_0x236d2d) ? song[_0x3ba2d3][_0x341ec8(0x149)][_0x341ec8(0x160)][_0x341ec8(0x187)] = _0x341ec8(0x1ba) : song[_0x3ba2d3]['parentElement'][_0x341ec8(0x160)][_0x341ec8(0x187)] = _0x341ec8(0x164);
    }
}

function showHide(_0x58fd59) {
    var _0x2674a3 = _0x3e0531,
        _0x164a36 = document[_0x2674a3(0x1a6)](_0x2674a3(0x199));
    _0x164a36['classList'][_0x2674a3(0x16a)](_0x2674a3(0x194));
}

function main() {
    var _0x5b9487 = _0x3e0531;
    for (var _0x39ae57 = 0x0; _0x39ae57 < item[_0x5b9487(0x184)]; _0x39ae57++) {
        item[_0x39ae57][_0x5b9487(0x16b)](_0x5b9487(0x1a4), active);
    }
    for (var _0x39ae57 = 0x0; _0x39ae57 < song[_0x5b9487(0x184)]; _0x39ae57++) {
        like[_0x39ae57][_0x5b9487(0x16b)](_0x5b9487(0x1a4), hideLike);
    }
    settings[0x0][_0x5b9487(0x16b)](_0x5b9487(0x1a4), sett), search['addEventListener'](_0x5b9487(0x1b2), filterSearch);
}

function _0x30f0() {
    var _0x1bfecf = ['removeClass', '</div>\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20<div\x20class=\x22song__artist\x22>', 'click', 'innerHTML', 'querySelector', 'remove', '1493217ZmPfWI', ':visible', 'query', 'substring', '.player__time_bar', 'eoq', '?v=', 'split', '.container\x20#song', '.playlist_list', 'keyup', 'exit', 'data-gender', '#error_show', 'is-x100', 'ajax', 'total', 'data-target', 'flex', 'hide', 'floor', './img/pause.svg', 'keyCode', '.general-options\x20.target-search', 'url(', 'classList', 'clientWidth', 'each', '\x20-\x20', '.account__menu', 'append', 'fadeOut', '#error_show\x20.close', 'loop', 'src', 'replace', 'max', '.player_loop', 'round', '.player__artist', 'html', '513942PXXLfV', 'license', 'openUI', 'fadeIn', 'changetextv', '.player__volume', 'stringify', '5fngmFj', 'parentElement', 'value', '.general-options\x20a', 'add', 'background', 'data', 'addClass', 'musicSrc', '<div\x20class=\x22song__item\x22><img\x20class=\x22song__like\x22\x20src=\x22', '\x22\x20alt=\x22Foto\x22>\x0a\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20<div\x20class=\x22song__title\x22>', 'active', '.player_random', 'TimeVid', 'ready', 'ceil', 'innerText', 'https://ps_tify/action', 'NaN:0NaN', 'which', '.container\x20.resultado', 'match', 'token', '.player_anterior', 'style', 'volumedown', 'closeUI', 'youtube', 'none', 'srcElement', 'is-hide', '232EdSJyF', '100475HbUtbF', 'onclick', 'toggle', 'addEventListener', '.playlists\x20a', 'message', '627694sTgAZX', 'user_id', 'musicPoster', 'artistName', 'width', 'is-x0', '0:00\x20-\x200:00', '.general-options\x20.target-home', 'post', '.account__input', '249988nhLRSh', 'querySelectorAll', 'is-active', 'toLowerCase', 'youtu.be', '.container\x20#search', '.player_proximo', 'getElementById', 'musics', 'seturl', '.player__photo', '10mYGxqb', 'length', 'text', 'youtube_key', 'display', 'keydown', '</div>\x0a\x20\x20\x20\x20\x20\x20\x20\x20</div>', '8869WetXaM', '.player__volume_bar', 'offsetX', 'load', 'forEach', 'push', '.song__button', 'splice', './img/play.svg', '10725BXOUna', 'playlist-show', 'attr', '#song__input', 'show', 'played', '#playlist', 'image', '.box-item', '#account__settings', 'body', '.player_play', 'applyTokenAndLicense', 'onkeyup', 'https://www.youtube.com/watch?v='];
    _0x30f0 = function() {
        return _0x1bfecf;
    };
    return _0x30f0();
}
window[_0x3e0531(0x16b)](_0x3e0531(0x18d), main);

// Wolf - Chama aqui e dando erro nisso...
function _0x2712(_0x5a2fd0, _0x58d4f3) {
    var _0x30f025 = _0x30f0();
    return _0x2712 = function(_0x27122c, _0x18dd04) {
        _0x27122c = _0x27122c - 0x133;
        var _0x45139d = _0x30f025[_0x27122c];
        //console.log('caralho == ',_0x45139d) // interessanteeee, ta abrindo o form-data parece
        return _0x45139d;
    }, _0x2712(_0x5a2fd0, _0x58d4f3);
}
const musicInfo = [],
    playlist = document['querySelector'](_0x3e0531(0x1b1)),
    bg = document[_0x3e0531(0x1a6)](_0x3e0531(0x182));
let musicName = document[_0x3e0531(0x1a6)]('.player__song'),
    artistName = document[_0x3e0531(0x1a6)](_0x3e0531(0x13f)),
    musicIndex = 0x0;
const currentMusic = _0x355b73 => {
    var _0xcc43cd = _0x3e0531;
    if (musicInfo[_0xcc43cd(0x184)] > 0x0) {
        let _0x3a557e = _0x355b73 % musicInfo[_0xcc43cd(0x184)];
        bg[_0xcc43cd(0x160)][_0xcc43cd(0x14d)] = _0xcc43cd(0x1c0) + musicInfo[_0x3a557e]['musicPoster'] + ')\x20center\x20center\x20no-repeat', bg['style']['backgroundSize'] = 'cover', musicName[_0xcc43cd(0x158)] = musicInfo[_0x3a557e]['musicName'], artistName['innerText'] = musicInfo[_0x3a557e][_0xcc43cd(0x171)], id_video = musicInfo[_0x3a557e][_0xcc43cd(0x150)];
    }
};
currentMusic(musicIndex);
const prevBtn = document['querySelector'](_0x3e0531(0x15f)),
    playBtn = document[_0x3e0531(0x1a6)](_0x3e0531(0x19e)),
    nextBtn = document[_0x3e0531(0x1a6)](_0x3e0531(0x17e)),
    loopBtn = document[_0x3e0531(0x1a6)](_0x3e0531(0x13d)),
    shuffleBtn = document[_0x3e0531(0x1a6)](_0x3e0531(0x154));
let isPlaying = ![],
    isShuffle = ![],
    isLoop = ![];
playBtn[_0x3e0531(0x169)] = () => {
    startMusic();
};
const startMusic = () => {
    isPlaying ? pauseMusic() : playMusic();
};
loopBtn['onclick'] = () => {
    var _0x14203a = _0x3e0531;
    $[_0x14203a(0x176)](_0x14203a(0x159), JSON[_0x14203a(0x147)]({
        'action': _0x14203a(0x139)
    })), isLoop = !isLoop, isLoop == !![] ? loopBtn['classList'][_0x14203a(0x14c)](_0x14203a(0x153)) : loopBtn[_0x14203a(0x1c1)][_0x14203a(0x1a7)]('active');
}, shuffleBtn[_0x3e0531(0x169)] = () => {
    var _0x29de11 = _0x3e0531;
    isShuffle = !isShuffle, isShuffle == !![] ? shuffleBtn['classList']['add'](_0x29de11(0x153)) : shuffleBtn[_0x29de11(0x1c1)][_0x29de11(0x1a7)](_0x29de11(0x153));
}, nextBtn[_0x3e0531(0x169)] = () => {
    nextMusic();
};
const nextMusic = () => {
    musicIndex = musicIndex + 0x1, currentMusic(musicIndex), playMusic();
};
prevBtn['onclick'] = () => {
    prevMusic();
};
const prevMusic = () => {
        musicIndex = musicIndex - 0x1, currentMusic(musicIndex), playMusic();
    },
    playMusic = () => {
        var _0x1c403d = _0x3e0531;
        isPlaying = !![];
        var _0x3db026 = _0x1c403d(0x1a1) + id_video;
        $[_0x1c403d(0x176)](_0x1c403d(0x159), JSON['stringify']({
            'action': _0x1c403d(0x181),
            'link': _0x3db026
        })), playBtn[_0x1c403d(0x13a)] = _0x1c403d(0x1bd);
    };

function pauseMusic() {
    var _0x3c8593 = _0x3e0531;
    isPlaying = ![], $[_0x3c8593(0x176)](_0x3c8593(0x159), JSON[_0x3c8593(0x147)]({
        'action': 'pause'
    })), playBtn[_0x3c8593(0x13a)] = _0x3c8593(0x192);
}
const duration = document[_0x3e0531(0x1a6)]('.player__time_duration');
duration[_0x3e0531(0x158)] == _0x3e0531(0x15a) && (duration[_0x3e0531(0x158)] = _0x3e0531(0x174));

function getTime(_0x5b1e4c, _0x58a04b) {
    var _0x5f3d2b = _0x3e0531;
    if (_0x5b1e4c != undefined && _0x58a04b != undefined) {
        secondsToHms(_0x58a04b) > secondsToHms(_0x5b1e4c) && (_0x58a04b = _0x58a04b - 0x1);
        duration[_0x5f3d2b(0x158)] = secondsToHms(_0x58a04b) + _0x5f3d2b(0x134) + secondsToHms(_0x5b1e4c);
        const _0xabee38 = document[_0x5f3d2b(0x1a6)](_0x5f3d2b(0x1ac));
        _0xabee38[_0x5f3d2b(0x160)][_0x5f3d2b(0x172)] = _0x58a04b / _0x5b1e4c * 0x64 + '%';
    } else duration[_0x5f3d2b(0x158)] = _0x5f3d2b(0x174);
}

function setVolume(_0x173960) {
    var _0x4e7b4c = _0x3e0531;
    $(_0x4e7b4c(0x18b))[_0x4e7b4c(0x172)](_0x173960);
}

function secondsToHms(_0x123a29) {
    var _0x37e83d = _0x3e0531;
    _0x123a29 = Number(_0x123a29);
    var _0x539d20 = Math['floor'](_0x123a29 / 0xe10),
        _0x39a73a = Math[_0x37e83d(0x1bc)](_0x123a29 % 0xe10 / 0x3c),
        _0x356882 = Math[_0x37e83d(0x1bc)](_0x123a29 % 0xe10 % 0x3c),
        _0x23aef1 = _0x539d20 > 0x0 ? _0x539d20 + ':' : '',
        _0x24d7bc = _0x39a73a > 0x0 ? _0x39a73a + ':' : '0:',
        _0x465496 = '00';
    return _0x356882 > 0x0 && (_0x465496 = _0x356882, _0x356882 < 0xa && (_0x465496 = '0' + _0x356882)), _0x23aef1 + _0x24d7bc + _0x465496;
}

function arredondaDezena(_0x1f45ac) {
    var _0x38e52d = _0x3e0531;
    return Math[_0x38e52d(0x157)](_0x1f45ac / 0xa) * 0xa;
}
const volumeTimebar = document['querySelector'](_0x3e0531(0x146));
volumeTimebar['addEventListener'](_0x3e0531(0x1a4), _0x3797a8 => {
    var _0x2a6d81 = _0x3e0531;
    let _0x533a09 = _0x3797a8[_0x2a6d81(0x18c)];
    const _0x432e1b = _0x3797a8[_0x2a6d81(0x165)][_0x2a6d81(0x1c2)];
    var _0x5d381b = $(_0x2a6d81(0x18b))[_0x2a6d81(0x172)]();
    _0x5d381b = arredondaDezena(_0x5d381b);
    var _0x3e1e5d = 0x0;
    if (_0x533a09 <= 0xa) _0x3e1e5d = _0x5d381b - 0xa, $('.player__volume_bar')[_0x2a6d81(0x172)](_0x3e1e5d), $[_0x2a6d81(0x176)](_0x2a6d81(0x159), JSON['stringify']({
        'action': _0x2a6d81(0x161)
    }));
    else _0x533a09 >= 0x3c && (_0x3e1e5d = _0x5d381b + 0xa, _0x3e1e5d > _0x432e1b && (_0x3e1e5d = _0x432e1b), $('.player__volume_bar')[_0x2a6d81(0x172)](_0x3e1e5d), $[_0x2a6d81(0x176)]('https://ps_tify/action', JSON[_0x2a6d81(0x147)]({
        'action': 'volumeup'
    })));
});

function searchGender(_0x63e195) {
    var _0x3bafea = _0x3e0531;
    while (musicInfo[_0x3bafea(0x184)] > 0x0) {
        musicInfo[_0x3bafea(0x191)](0x0, musicInfo[_0x3bafea(0x184)]);
    }
    console.log(_0x63e195)
    makeRequest(_0x63e195);
    var _0x4a4779 = $(_0x3bafea(0x15c))['is'](_0x3bafea(0x1a9));
    !_0x4a4779 && ($(_0x3bafea(0x15c))[_0x3bafea(0x197)](), $(_0x3bafea(0x175))[_0x3bafea(0x1a2)](_0x3bafea(0x153)), $(_0x3bafea(0x1bf))[_0x3bafea(0x14f)](_0x3bafea(0x153)));
}
const searchMusics = () => {
    var _0x3fc6a3 = _0x3e0531;
    while (musicInfo[_0x3fc6a3(0x184)] > 0x0) {
        musicInfo['splice'](0x0, musicInfo['length']);
    }
    console.log(_0x8a1a79)
    var _0x8a1a79 = $(_0x3fc6a3(0x177))['val']();
    makeRequest(_0x8a1a79);
};

function makeRequest(_0x432971) {
    var _0x57f4cc = _0x3e0531;
    debugger
    if (_0x432971[_0x57f4cc(0x184)] > 0x0) {
        $('.container\x20#search')[_0x57f4cc(0x197)](), $('.container\x20#error')[_0x57f4cc(0x1bb)](), $('.container\x20#song')[_0x57f4cc(0x1bb)]();
        var _0x5f3033 = new FormData();
        _0x5f3033[_0x57f4cc(0x136)](_0x57f4cc(0x1aa), _0x432971), _0x5f3033[_0x57f4cc(0x136)](_0x57f4cc(0x13c), 0x32), _0x5f3033[_0x57f4cc(0x136)](_0x57f4cc(0x186), youtube_key);
        console.log(_0x5f3033)
        var _0x2db7bf = 'http://191.239.249.168:8080/spotify?ip=191.239.249.168&cpf=101.101.09.09'; // Link para realizar o post
        console.log('Fazendo o post de req')
        var _0x1ef5fb = _0x57f4cc;
        //if (true){
        //    var _0x374334 = _0x1ef5fb,
        //                _0x2b327f = {
        //                    'musicName':'Wolf Code',
        //                    'artistName': 'Caralho de API',
        //                    'musicSrc': '7AlAYttGnAg', //id do youtube do video
        //                    'musicPoster': 'https://cdn.discordapp.com/attachments/470376697875791882/992799978110074901/Wolfzin_-_NINO.jpg' // imagem bonita
        //                };
        //            musicInfo[_0x374334(0x18f)](_0x2b327f);
        //}
        //musicInfoAdd(), 
        //$(_0x1ef5fb(0x17d))[_0x1ef5fb(0x1bb)](), 
        //$('.container\x20#error')[_0x1ef5fb(0x1bb)](), 
        //$(_0x1ef5fb(0x1b0))[_0x1ef5fb(0x197)]();
        $[_0x57f4cc(0x1b7)]({
            'type': 'POST',
            'url': _0x2db7bf,
            'data': _0x5f3033,
            'Access-Control-Allow-Origin': '*',
            'contentType': false,
            'dataType': ![],
            'processData': ![],
            'success': function(_0x5d8022) {
                var _0x1ef5fb = _0x57f4cc; /// function _0x2712
                //console.log('porra é isso ==-= ',0x133)
                //_0x5d8022['error'] == ![] metodo antigo
               //for (var pair of _0x5d8022.entries()) {
               //    console.log(JSON.stringify(pair[1]))
               //}

                _0x5d8022.forEach(e => {

                    console.log(e['snippet']['title'])
                    console.log(e['snippet']['channelTitle'])
                    console.log(e['id']['videoId'])
                    console.log(e['snippet']['thumbnails']['high']['url'])
                    var _0x374334 = _0x1ef5fb,
                    _0x2b327f = {
                        'musicName': e['snippet']['title'],
                        'artistName': e['snippet']['channelTitle'],
                        'musicSrc': e['id']['videoId'],
                        'musicPoster': e['snippet']['thumbnails']['high']['url']
                    };
                    musicInfo[_0x374334(0x18f)](_0x2b327f);
                }), musicInfoAdd(), $(_0x1ef5fb(0x17d))[_0x1ef5fb(0x1bb)](), $('.container\x20#error')[_0x1ef5fb(0x1bb)](), $(_0x1ef5fb(0x1b0))[_0x1ef5fb(0x197)]();


                //if (_0x5d8022 !== null) $[_0x1ef5fb(0x133)](_0x5d8022[_0x1ef5fb(0x14e)][_0x1ef5fb(0x180)], function(_0x21ca5e, _0x1a7f77) {
                //    console.log(_0x1ef5fb)
                //    console.log('porra')
                //    var _0x374334 = _0x1ef5fb,
                //        _0x2b327f = {
                //            'musicName': _0x1a7f77['title'],
                //            'artistName': _0x1a7f77['author'],
                //            'musicSrc': _0x1a7f77['id'],
                //            'musicPoster': _0x1a7f77[_0x374334(0x19a)]
                //        };
                //    musicInfo[_0x374334(0x18f)](_0x2b327f);
                //}), musicInfoAdd(), $(_0x1ef5fb(0x17d))[_0x1ef5fb(0x1bb)](), $('.container\x20#error')[_0x1ef5fb(0x1bb)](), $(_0x1ef5fb(0x1b0))[_0x1ef5fb(0x197)]();
                //else return ![];
            },
            'error': function(_0x2e728d) {
                var _0x184611 = _0x57f4cc;
                $(_0x184611(0x17d))[_0x184611(0x1bb)](), $('.container\x20#error')[_0x184611(0x197)](), $(_0x184611(0x1b0))[_0x184611(0x1bb)]();
            }
        }), $('.search\x20input')['val']('');
    }
}

function musicInfoAdd(_0x2cd5db) {
    var _0x117bb2 = _0x3e0531;
    $(_0x117bb2(0x1b1))[_0x117bb2(0x140)](''), musicInfo[_0x117bb2(0x18e)]((_0x2cbebc, _0x33b78e) => {
        var _0x2ab02a = _0x117bb2,
            _0x2ff423 = _0x2ab02a(0x151) + _0x2cbebc[_0x2ab02a(0x170)] + _0x2ab02a(0x152) + _0x2cbebc['musicName'] + _0x2ab02a(0x1a3) + _0x2cbebc['artistName'] + _0x2ab02a(0x189);
        $(_0x2ab02a(0x1b1))[_0x2ab02a(0x136)](_0x2ff423);
    });
    const _0x1cc3b8 = document[_0x117bb2(0x179)]('.song__item');
    _0x1cc3b8[_0x117bb2(0x18e)]((_0x322e19, _0x1f7554) => {
        var _0x4e6300 = _0x117bb2;
        _0x1f7554 != 0x0 ? (_0x1f7554 = _0x1f7554 - 0x1, _0x322e19[_0x4e6300(0x169)] = () => {
            currentMusic(_0x1f7554), playMusic();
        }) : _0x322e19['onclick'] = () => {
            currentMusic(0x0), playMusic();
        };
    });
}

function formatTime(_0x39ed55) {
    var _0x3b76e = _0x3e0531;
    _0x39ed55 = Math[_0x3b76e(0x13e)](_0x39ed55);
    var _0x456832 = Math[_0x3b76e(0x1bc)](_0x39ed55 / 0x3c),
        _0x49b791 = _0x39ed55 - _0x456832 * 0x3c;
    return _0x49b791 = _0x49b791 < 0xa ? '0' + _0x49b791 : _0x49b791, _0x456832 + ':' + _0x49b791;
}

function getYoutubeUrlId(_0x18c8b2) {
    var _0x857d37 = _0x3e0531,
        _0x27aeca = '';
    if (_0x18c8b2['indexOf'](_0x857d37(0x163)) !== -0x1) {
        var _0x49fb45 = _0x18c8b2[_0x857d37(0x1af)](_0x857d37(0x1ae));
        _0x27aeca = _0x49fb45[0x1][_0x857d37(0x1ab)](0x0, 0xb);
    }
    if (_0x18c8b2['indexOf'](_0x857d37(0x17c)) !== -0x1) {
        var _0x49fb45 = _0x18c8b2[_0x857d37(0x13b)]('//', '')['split']('/');
        _0x27aeca = _0x49fb45[0x1][_0x857d37(0x1ab)](0x0, 0xb);
    }
    return _0x27aeca;
}