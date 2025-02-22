$(document).ready(() => {
    updateSlider();

    $("#defaultbtn").click(function(){
        setSliderValues({
            boost: 0.25,
            curve: 22.5,
            lowspeed: 0.30,
            trafront: 0.48,
            clutchup: 7.0,
            clutchdown: 6.0
        });
    });

    $("#savebtn").click(function(){
        $.post("http://notebookcar/save",JSON.stringify(getSliderValues()));
    });

    window.addEventListener("message",function(event){
        if (event.data.type == "togglemenu"){
            menuToggle(event.data.state,false);
            if (event.data.data != null){
                setSliderValues(event.data.data);
            }
        }
    });

    $('input').on('input',function(){
        $(this).parent().find('.text').find('.value').text($(this).val());
    });

    function menuToggle(bool,send = false){
        if (bool){
            $("body").fadeIn(300)
        } else {
            $("body").fadeOut(300)
        }

        if (send){
            $.post("http://notebookcar/togglemenu",JSON.stringify({ state: false }));
        }
    }

    function setSliderValues(values){
        $(".styled-slider").each(function(){
            if (values[this.id] != null) {
                $(this).val(values[this.id]);
            }
        });

        updateSlider();
    }

    function getSliderValues(){
        return {
            boost: $("#boost").val(),
            curve: $("#curve").val(),
            lowspeed: $("#lowspeed").val(),
            trafront: $("#trafront").val(),
            clutchup: $("#clutchup").val(),
            clutchdown: $("#clutchdown").val(),
        };
    }

    function updateSlider() {
        for (let e of document.querySelectorAll('input[type="range"].slider-progress')){
            e.style.setProperty('--value',e.value);
            e.style.setProperty('--min',e.min == '' ? '0' : e.min);
            e.style.setProperty('--max',e.max == '' ? '100' : e.max);
            e.addEventListener('input',() => e.style.setProperty('--value',e.value));
            $(e).parent().find('.text').find('.value').text($(e).val())
        }
    }

    document.onkeyup = function(data){
        if (data.which == 27){
            menuToggle(false,true);
        }
    };
})