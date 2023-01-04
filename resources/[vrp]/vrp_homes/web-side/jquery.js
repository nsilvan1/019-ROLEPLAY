let maxinv = 1;
let disabled = false;
let disabledFunction = null;

function Interval(time) {
	var timer = false
	this.start = function() {
		if (this.isRunning()) {
			clearInterval(timer)
			timer = false
		}

		timer = setInterval(function() {
			disabled = false
		}, time)
	}
	this.stop = function() {
		clearInterval(timer)
		timer = false
	}
	this.isRunning = function() {
		return timer !== false
	}
}

const disableInventory = ms => {
	disabled = true

	if (disabledFunction === null) {
		disabledFunction = new Interval(ms)
		disabledFunction.start()
	} else {
		if (disabledFunction.isRunning()) {
			disabledFunction.stop()
		}

		disabledFunction.start()
	}
}

$(document).ready(function(){
	let actionChest = $(".container");
	actionChest.hide()

	window.addEventListener("message",function(event){
		let item = event.data;
		switch(item.action){
			case "showMenu":
				updateVault();
				actionChest.show()
			break;

			case "hideMenu":
				actionChest.hide()
			break;

			case "updateChest":
				updateVault();
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://vrp_homes/chestClose");
		}
	};
});

const updateDrag = () => {
	$('.item').draggable({
		helper: 'clone',
		appendTo: 'body',
		zIndex: 99999,
		revert: 'invalid',
		opacity: 0.5,
		start: function(event,ui){
			if (disabled) return false;

			$(this).children().children('img').hide();
			itemData = { key: $(this).data('item-key') };

			if (itemData.key === undefined) return;

			let $el = $(this);
			$el.addClass("active");
		},
		stop: function(){
			$(this).children().children('img').show();

			let $el = $(this);
			$el.removeClass("active");
		}
	})

	$('.item2').draggable({
		helper: 'clone',
		appendTo: 'body',
		zIndex: 99999,
		revert: 'invalid',
		opacity: 0.5,
		start: function(event,ui){
			if (disabled) return false;

			$(this).children().children('img').hide();
			itemData = { key: $(this).data('item-key') };

			if (itemData.key === undefined) return;

			let $el = $(this);
			$el.addClass("active");
		},
		stop: function(){
			$(this).children().children('img').show();

			let $el = $(this);
			$el.removeClass("active");
		}
	})

	$('.listaItens').droppable({
		hoverClass: 'hoverControl',
		accept: '.item2',
		drop: function(event,ui){
			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			console.log(JSON.stringify(itemData));
			
			if (itemData.key === undefined) return;

			disableInventory(500);
            console.log(maxinv);
			$.post("http://vrp_homes/takeItem", JSON.stringify({
				item: itemData.key,	
				slot: maxinv,	
				amount: Number($("#amount").val())
			}))
            maxinv = maxinv + 1 
			document.getElementById("amount").value = "";
			updateVault();
		}
	})

	$('.ListaItensBau').droppable({
		hoverClass: 'hoverControl',
		accept: '.item',
		drop: function(event,ui){
			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');
			if (itemData.key === undefined) return;

			disableInventory(500);

			$.post("http://vrp_homes/storeItem", JSON.stringify({
				item: itemData.key,				
				slot: itemData.slot,
				amount: Number($("#amount").val())
			}))

			document.getElementById("amount").value = "";
		}
	})

}

const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}

const updateVault = () => {
	$.post("http://vrp_homes/requestVault",JSON.stringify({}),(data) => {
		console.log(JSON.stringify(data.inventario))
		const nameList = data.inventario.sort((a,b) => (a.name > b.name) ? 1: -1);
		const nameList2 = data.inventario2.sort((a,b) => (a.name > b.name) ? 1: -1);
		maxinv = data.inventario.length + 3
		let divLista = ''
		$('.container').html(`
		<div class="row" >		
			<div class="esquerda">
				<div class="col">
					<div class="listaSlots">
				        <div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div>
                  	</div>
					<div class="listaItens">
					${nameList.map((item) => (`
						<div class="item" style="background-image: url('/${item.index}.png');  "data-item-key="${item.key}" data-item-type="${item.type}" data-name-key="${item.name}" data-slot="${item.slot}">
							<div class="amount">${formatarNumero(item.amount)}x</div>
							<div class="gozei" ><img src="http://189.1.172.114/inventario/${item.index}.png" alt="" class="img-item"></div>
							<div class="name-item ">${item.name}</div>
						</div>
						`)).join('')}
						</div>			
					</div>
				</div>

			<div class="meio">
				<div class="col" id="center">
					<input id="amount" class="buttons"></input>
				</div>
			</div>

		<div class="direita">
            <div class="col">
                <div class="listaSlots">
					<div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div><div class="slot"></div>
				 </div>
                <div class="ListaItensBau">
				${nameList2.map((item) => (`
					<div class="item2" style="background-image: url('/${item.index}.png');  "data-item-key="${item.key}" data-item-type="${item.type}" data-name-key="${item.name}"  data-slot="${item.slot}">
						<div class="amount">${formatarNumero(item.amount)}x</div>
						<div class="gozei" ><img src="http://189.1.172.114/inventario/${item.index}.png" alt="" class="img-item"></div>
						<div class="name-item ">${item.name}</div>
					</div>
					`)).join('')}
					</div>  
				</div> 
			</div>   
			<div class="peso"><b>OCUPADO:</b>  ${(data.peso).toFixed(2)}    <s>|</s>    <b>LIVRE:</b>  ${(data.maxpeso-data.peso).toFixed(2)}    <s>|</s>    <b>TAMANHO:</b>  ${(data.maxpeso).toFixed(2)}</div>
			<div class="peso2"><b>OCUPADO:</b>  ${(data.peso2).toFixed(2)}    <s>|</s>    <b>LIVRE:</b>  ${(data.maxpeso2-data.peso2).toFixed(2)}    <s>|</s>    <b>TAMANHO:</b>  ${(data.maxpeso2).toFixed(2)}</div>
		`);
		updateDrag();
	});
}