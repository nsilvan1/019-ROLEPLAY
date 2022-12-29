$(document).ready(function(){

	var bar = new ldBar("#speedLevel", {
		"stroke": '#f00',
		"stroke-width": 5,
		"preset": "fan",
		"value": 0
	 });

    window.addEventListener("message",function(action){
        var data = action.data
        switch (data.type) {
            case 'hud':

            
				$(".coleteDisplay").css("stroke-dashoffset",100-data.colete);
				$(".SedeDisplay").css("stroke-dashoffset",data.sede );
				$(".vidaDisplay").css("stroke-dashoffset",100-data.vida );
				$(".FomeDisplay").css("stroke-dashoffset",data.fome );
                $(".staminaDisplay").css("stroke-dashoffset",data.stamina );
                $("#ruas").html(data.street);
                $("#horas").html(data.horas +":"+ data.minutos);
        

                $("#cardurablidade").text(data.healthcar / 10 +"%");
                
                $(".nitrobar").css("width",data.nitroLevel +"%");

                $('#street').html(data.street)

                if(data.talkRange == 1) {
                    $('#voice').html(' Sussurando ');
    			} else if (data.talkRange == 2){
                    $('#voice').html(' Normal ');
                } else if (data.talkRange == 3){
                    $('#voice').html(' Gritando ');
                }


                 if(data.car == true) {
                    $("#car-container").fadeIn(800);
                     $("#item-ruas").fadeIn(800);
    			} else {
                     $("#car-container").fadeOut(800);
                    $("#item-ruas").fadeOut(800);
                }

                



            break;



            case 'radio':
                if (data.isTalking == 1) {
                    $("#voice").css("color", "rgb(248, 178, 72)");  
                } else {
                    $("#voice").css("color", "#fff");
                }
            break

            case 'system':

                // $("#car-container").css("display","block");

                bar.set(data.velocity/1.5,false);
                $("#gasolina").text(data.fuel + "%");

                if(data.seatbelt == true) {
                    $("#on").fadeIn(200);
                    $("#off").fadeOut(200);
    			} else {
                    $("#on").fadeOut(200);
                    $("#off").fadeIn(200);
                }

                if(data.locked == true) {
                    $("#lockon").fadeOut(200);
                    $("#lockoff").fadeIn(200);
    			} else {
                    $("#lockon").fadeIn(200);
                    $("#lockoff").fadeOut(200);
                }


                if(data.speed <= 9) {
                    $('#speed').html('00' + data.speed)
                    $('.ldBar path.mainline').css("stroke","rgb(147, 214, 59)")
                } else if(data.speed <= 44){
                    $('#speed').html('0' + data.speed)
                    $('.ldBar path.mainline').css("stroke","rgb(147, 214, 59)")
                } else if(data.speed <= 64){
                    $('#speed').html('0' + data.speed)
                    $('.ldBar path.mainline').css("stroke","rgb(87, 141, 17)")
                } else if(data.speed <= 65){
                    $('#speed').html('0' + data.speed)
                    $('.ldBar path.mainline').css("stroke","rgb(147, 214, 59)")
                } else if(data.speed <= 99){
                    $('#speed').html('0' + data.speed)
                    $('.ldBar path.mainline').css("stroke","rgb(214, 160, 59)")
    			} else {
                    $('#speed').html(data.speed)
                    $('.ldBar path.mainline').css("stroke","rgb(214, 59, 59)")
                }
               
            break

            case 'Vehicle':
                
            break
        }
})
})