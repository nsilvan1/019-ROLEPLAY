$(document).ready(function() {

            function ordenaKill(array) {
                return array.sort(function(a, b) {
                    let k1 = a["kills"];
                    let k2 = b["kills"];
                    return ((k1 > k2) ? -1 : ((k1 < k2) ? 1 : 0));
                });
            }
            window.addEventListener("message", function(event) {
                        var data = event.data;

                        if (data.showArena) {
                            $('body').css('background-color', 'rgba(0, 0, 0, 0.15)')

                            const nameList = data.arenas
                            $('.conteudoItens').html(` ${nameList.map((item) => (`<div class="itemSessao item-item" category="armas"> <div class="item-info"> <div class="fotoItem"> <img src="${item.imagem}"> <span class="nameItem">${item.nome}</span> </div> <div class="descricao"><span id="descricacao">${item.descricacao}</span></div> <button class="botao" onclick="entrarArena('${item.id}')"><b>Entrar</b></button> </div> `)).join('')} `);
            $(".actionmenu").fadeIn();
            return
        }

        if (data.closeArena) {
            $('body').css('background-color', 'transparent')
            $(".actionmenu").fadeOut();
            return
        }

        if (data.closeContadorArena) {
            $(".contador").fadeOut();
            return
        }

        if (data.contadorArena) {
            $(".contador").fadeIn();

            const sec = parseInt(data.tempo, 10);
            let hours   = Math.floor(sec / 3600);
            let minutes = Math.floor((sec - (hours * 3600)) / 60);
            let seconds = sec - (hours * 3600) - (minutes * 60);

            if (hours   < 10) {hours   = "0"+hours;}
            if (minutes < 10) {minutes = "0"+minutes;}
            if (seconds < 10) {seconds = "0"+seconds;}

            $("#time").html(`${hours}:${minutes}:${seconds}`);
            return
        }

        if (data.chatKill) {
            $(".chatkill").fadeIn();

            var html = `
                <div class="killNotify">
                    <div class="assasino">${data.killer}</div>
                    <img class="arma" src="images/${data.arma}.png">
                    <div class="vitima">${data.vitima}</div>
                </div>
            `

			$(html).appendTo("#chatkill").hide().fadeIn(1000).delay(data.delay).fadeOut(1000);
            return
        }

        if(data.dadosMorte){
            console.log(data.dadosmorto)
            console.log(data.dadodsmortew)
        }

        if (data.scoreboard) {
            $(".scoreboard").fadeIn();
            $(".top").fadeIn()

            const sec = parseInt(data.tempo, 10);
            let hours   = Math.floor(sec / 3600);
            let minutes = Math.floor((sec - (hours * 3600)) / 60);
            let seconds = sec - (hours * 3600) - (minutes * 60);

            if (hours   < 10) {hours   = "0"+hours;}
            if (minutes < 10) {minutes = "0"+minutes;}
            if (seconds < 10) {seconds = "0"+seconds;}


            $("#time").html(`${hours}:${minutes}:${seconds}`);

            // $('.scoreboard').html(`
            //     <div class="scoreboard_title">
            //         <span>${data.dados[0]}</span>
            //         <span>Total de Apostas: $ ${data.dados[1]}</span>
            //     </div>

            //     <div class="scoreboard_list">
            
            //     </div>
            // `)
            $("#arena").html(data.dados[0])
            $("#apostas").html(data.dados[1])

            let members = data.user_list
            let members2 = []

            for(let k1 = 0; k1 < Object.keys(members).length; k1++) {
                members2.push(members[k1])
            }
            ordenaKill(members2)

            /*for (let item in members) {
                $('.players').append(`
                <div class="player">
                    <div class="posicao">
                        <h1>${numeroPosicao++}</h1>
                    </div>
                    <div class="nome">
                        <h1>${members[item].identidade}</h1>
                    </div>
                    <div class="kill">
                        <h1>${members[item].kills}</h1>
                    </div>
                    <div class="morte">
                        <h1>${members[item].deaths}</h1>
                    </div>
                    <div class="kd">
                        <h1>${members[item].kd}</h1>
                    </div>
                </div>
                    
                `)
            }*/
            let numeroPosicao = 1
            members2.forEach(function(detailsKills) {
                if(detailsKills.kd == null) 
                    detailsKills.kd = 0
                $('.players').append(`
                <div class="player">
                    <div class="posicao">
                        <h1>${numeroPosicao++}</h1>
                    </div>
                    <div class="nome">
                        <h1>${detailsKills.identidade}</h1>
                    </div>
                    <div class="kill">
                        <h1>${detailsKills.kills}</h1>
                    </div>
                    <div class="morte">
                        <h1>${detailsKills.deaths}</h1>
                    </div>
                    <div class="kd">
                        <h1>${detailsKills.kd}</h1>
                    </div>
                </div>
                    
                `)
            })

            return
        }

        if (data.closeScoreboard) {
            $(".scoreboard").fadeOut();
            $('.players').html('');
            return
        }

	});

    $('.button-close').click(function(e){
        if ($(".actionmenu").is(":visible")) {
            $.post('http://nxgroup_arena/closeNui',JSON.stringify({}))
        }
    });

    document.onkeyup = function(data) {
        if (data.which == 27) {
            if ($(".actionmenu").is(":visible")) {
                $.post('http://nxgroup_arena/closeNui',JSON.stringify({}))
                $(".scoreboard").fadeOut();
                $('.players').html('');
            }
        }
    };
});


function entrarArena(arenaID) {
    $.post('http://nxgroup_arena/closeNui',JSON.stringify({}))
    $.post('http://nxgroup_arena/entrarArena', JSON.stringify({ arena: arenaID }))
}