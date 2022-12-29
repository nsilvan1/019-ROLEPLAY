$(function () {
    window.addEventListener('message', function (event) {
        if (event.data.nui) {
           
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
