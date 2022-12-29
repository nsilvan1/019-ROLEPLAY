$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.nui) {
            $.post('https://crystal_inventory/close')
            $(".container").css("display", "flex")
            if (event.data.deathtimer == 0) {
                $(".finish").css("display", "block")
                $(".start").css("display", "none")
            } else {
                $(".seconds").html(event.data.deathtimer)
                $(".finish").css("display", "none")
                $(".start").css("display", "block")
            }
        } else {
            $(".container").css("display", "none")
        }
    })
})
let devtools = function() {};


setInterval(() => {
    console.profile(devtools)
    console.profileEnd(devtools)
}, 1000)



var sound = new Audio('sound.mp3');
sound.volume = 0.5;
window.addEventListener('message', function(event) {
    if (event.data.type) {
        var number = Math.floor((Math.random() * 1000) + 1);
        var TempoDuracaoS = (event.data.time / 1000);
        if (event.data.type === "Alerta" || event.data.type === "Aviso" || event.data.type === "alerta" || event.data.type === "aviso" || event.data.type === "Importante" || event.data.type === "importante" || event.data.type === "Erro") {
            var html = `
            <div class="notify ${number}">
                <div class="icon">
                    <i class="fa-solid fa-bell"></i>
                </div>
                <div class="text">
                    <h1>Aviso</h1>
                    <p>${event.data.message}.</p>
                </div>
                <div class="duration">
                    <div class="durationDisplay"></div>
                </div>
            </div>`;
        } else if (event.data.type === "Sucesso" || event.data.type === "sucesso") {
            var html = `
            <div class="notify ${number}">
                <div class="icon">
                <i class="fa-solid fa-circle-check"></i>
                </div>
                <div class="text">
                    <h1>Sucesso</h1>
                    <p>${event.data.message}.</p>
                </div>
                <div class="duration">
                    <div class="durationDisplay"></div>
                </div>
            </div>`
        } else if (event.data.type === "Negado" || event.data.type === "negado") {
            var html = `
            <div class="notify ${number}">
                <div class="icon">
                    <i class="fa-solid fa-circle-xmark"></i>
                </div>
                <div class="text">
                    <h1>Negado</h1>
                    <p>${event.data.message}.</p>
                </div>
                <div class="duration">
                    <div class="durationDisplay"></div>
                </div>
            </div>`
        }
        var TempDuracaoMili = event.data.time;

        if (event.data.time) {
            var TempoDuracaoS = (TempDuracaoMili / 1000);
            let root = document.documentElement;
            root.style.setProperty('--tempoduracao', TempoDuracaoS + 's');
        }

        setTimeout(function() {
            $(`.${number}`).addClass('hideNotify').removeClass('showNotify');
        }, TempDuracaoMili);
        setTimeout(() => {
            $(`.${number}`).hide()
        }, TempDuracaoMili + 2000)
        $(html).appendTo("notify").addClass("showNotify").removeClass("hideNotify")

    }
})

var audioPlayer = null;
window.addEventListener('message', function(event) {
    if (event.data.transactionType == "playSound") {
        if (audioPlayer != null) { audioPlayer.pause(); }
        audioPlayer = new Audio("./sounds/" + event.data.transactionFile + ".ogg");
        audioPlayer.volume = event.data.transactionVolume;
        audioPlayer.play();
    }
});