let tempban = false;
let multa = false;

$(document).ready(function() {
    window.addEventListener("message", function(event) {
        if (event.data.action) {
            tempban = true
            $("#displayNui").css("display", "flex")
            $('.confirm').click(() => {
                let id = $("#id").val()
                let tempo = $("#tempo").val()
                $.post("http://nxgroup_tempban/sendInformations", JSON.stringify({ id, tempo }))
            })
        } else {
            $("#displayNui").css("display", "none")

        }

        if (event.data.action2) {
            multa = true
            $("#displayNui2").css("display", "flex")
            $('.confirm2').click(() => {
                let idm = $("#idm").val()
                let valor = $("#valor").val()
                let descricao = $("#descricao").val()
                $.post("http://nxgroup_tempban/sendInformationMulta", JSON.stringify({ idm, valor, descricao }))
            })
        } else {
            $("#displayNui2").css("display", "none")
        }
    })
});

$(document).keyup(function(event) {
    if (tempban == true) {
        if (event.which === 27) {
            $("#displayNui").css("display", "none")
            $.post("http://nxgroup_tempban/closeTempbanNui", true)
        }
    }
    if (multa == true) {
        if (event.which === 27) {
            $("#displayNui2").css("display", "none")
            $.post("http://nxgroup_tempban/closeMultaNui", true)
        }
    }
});