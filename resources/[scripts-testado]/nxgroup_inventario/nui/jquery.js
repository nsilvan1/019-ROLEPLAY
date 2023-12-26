var selectShop = "selectShop";
var acao = "REVISTAR";

$(document).ready(function() {
    window.addEventListener("message", function(event) {
        switch (event.data.action) {
            case "showMenu":
                updateIdentity();
                updateMochila();
                $("#actionmenu").css("display", "flex")
                break;
            case "hideMenu":
                $("#actionmenu").css("display", "none")
                break;
            case "updateMochila":
                updateIdentity();
                updateMochila();
                break;
            case "updateChest":
                updateIdentity();
                updateChest();
                $("#actionmenu").css("display", "flex")
                break;
            case "updateTrunkChest":
                updateIdentity();
                updateTrunkChest();
                $("#actionmenu").css("display", "flex")
                break;
            case "updateShop":
                selectShop = event.data.name;
                updateIdentity();
                updateShop();
                $("#actionmenu").css("display", "flex")
                break;
            case "updateRevistar":
                acao = event.data.name;
                updateIdentity();
                updateRevistar();
                $("#actionmenu").css("display", "flex")
                break;
            case "updateHomeChest":
                updateIdentity();
                updateHomeChest();
                $("#actionmenu").css("display", "flex")
                break;
        }
    });

    document.onkeyup = function(data) {
        if (data.which == 27) {
            if (acao == "ROUBAR") {
                $.post("http://nxgroup_inventario/invClose2");
            } else {
                $.post("http://nxgroup_inventario/invClose");
            }
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
        start: function(event, ui) {
            $(this).children().children('img').hide();
            itemData = { key: $(this).data('item-key'), type: $(this).data('item-type') };

            if (itemData.key === undefined || itemData.type === undefined) return;

            let $el = $(this);
            $el.addClass("active");
        },
        stop: function() {
            $(this).children().children('img').show();

            let $el = $(this);
            $el.removeClass("active");
        }
    })

    $('.weapon').draggable({
        helper: 'clone',
        zIndex: 99999,
        revert: 'invalid',
        opacity: 0.5,
        start: function(event, ui) {
            $(this).children().children('img').hide();
            itemData = { key: $(this).data('item-key'), type: $(this).data('item-type') };

            if (itemData.key === undefined || itemData.type === undefined) return;

            let $el = $(this);
            $el.addClass("active");
        },
        stop: function() {
            $(this).children().children('img').show();

            let $el = $(this);
            $el.removeClass("active");
        }
    })

    $('.use').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key'), type: ui.draggable.data('item-type') };

            if (itemData.key === undefined || itemData.type === undefined) return;

            $.post("http://nxgroup_inventario/useItem", JSON.stringify({
                item: itemData.key,
                type: itemData.type,
                amount: Number($("#amount").val())
            }))

            document.getElementById("amount").value = "";
        }
    })

    $('.dropitem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };

            if (itemData.key === undefined) return;

            $.post("http://nxgroup_inventario/dropItem", JSON.stringify({
                item: itemData.key,
                amount: Number($("#amount").val())
            }))

            document.getElementById("amount").value = "";
        }
    })

    $('.takedropitem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            if (ui.draggable.data('item-key') === undefined) return;
            if (ui.draggable.data('slot') == undefined) {
                $.post("http://nxgroup_inventario/unEquip", JSON.stringify({
                    item: ui.draggable.data('item-key'),
                    nome: ui.draggable.data('item-name'),
                    amount: ui.draggable.data('item-muni'),
                }))
                document.getElementById("amount").value = "";
                updateMochila();
            }
        }
    })

    $('.send').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };

            if (itemData.key === undefined) return;

            $.post("http://nxgroup_inventario/sendItem", JSON.stringify({
                item: itemData.key,
                amount: Number($("#amount").val())
            }))

            document.getElementById("amount").value = "";
        }
    })

    $('.putHomeitem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };


            if (itemData.key === undefined) return;
            $.post("http://nxgroup_inventario/storeHomeItem", JSON.stringify({
                item: itemData.key,
                amount: Number($("#amount").val())
            }))
            document.getElementById("amount").value = "";
        }
    })

    $('.takeHomeitem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };

            if (itemData.key === undefined) return;
            $.post("http://nxgroup_inventario/takeHomeItem", JSON.stringify({
                item: itemData.key,
                amount: Number($("#amount").val())
            }))
            document.getElementById("amount").value = "";
        }
    })

    $('.roubarItem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };
            if (itemData.key === undefined) return;
            if (acao == "ROUBAR") {
                $.post("http://nxgroup_inventario/requestRoubar", JSON.stringify({
                    item: itemData.key,
                    amount: Number($("#amount").val())
                }))
                updateRevistar();
            }
            document.getElementById("amount").value = "";
        }
    })

    $('.itemchest').draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        opacity: 0.5,
        start: function(event, ui) {
            $(this).children().children('img').hide();
            itemData = { key: $(this).data('item-key'), type: $(this).data('item-type') };

            if (itemData.key === undefined || itemData.type === undefined) return;

            let $el = $(this);
            $el.addClass("active");
        },
        stop: function() {
            $(this).children().children('img').show();

            let $el = $(this);
            $el.removeClass("active");
        }
    })

    $('.itemchest2').draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        opacity: 0.5,
        start: function(event, ui) {
            $(this).children().children('img').hide();
            itemData = { key: $(this).data('item-key'), type: $(this).data('item-type') };

            if (itemData.key === undefined || itemData.type === undefined) return;

            let $el = $(this);
            $el.addClass("active");
        },
        stop: function() {
            $(this).children().children('img').show();

            let $el = $(this);
            $el.removeClass("active");
        }
    })

    $('.takechestitem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };

            if (itemData.key === undefined) return;
            $.post("http://nxgroup_inventario/takeItem", JSON.stringify({
                item: itemData.key,
                amount: Number($("#amount").val())
            }))
            document.getElementById("amount").value = "";
        }
    })

    $('.putchestitem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };


            if (itemData.key === undefined) return;
            $.post("http://nxgroup_inventario/storeItem", JSON.stringify({
                item: itemData.key,
                amount: Number($("#amount").val())
            }))
            document.getElementById("amount").value = "";
        }
    })

    $('.itemtrunkchest').draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        opacity: 0.5,
        start: function(event, ui) {
            $(this).children().children('img').hide();
            itemData = { key: $(this).data('item-key') };

            if (itemData.key === undefined) return;

            let $el = $(this);
            $el.addClass("active");
        },
        stop: function() {
            $(this).children().children('img').show();

            let $el = $(this);
            $el.removeClass("active");
        }
    })

    $('.itemtrunkchest2').draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        opacity: 0.5,
        start: function(event, ui) {
            $(this).children().children('img').hide();
            itemData = { key: $(this).data('item-key') };

            if (itemData.key === undefined) return;

            let $el = $(this);
            $el.addClass("active");
        },
        stop: function() {
            $(this).children().children('img').show();

            let $el = $(this);
            $el.removeClass("active");
        }
    })

    $('.taketrunkchestitem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };

            if (itemData.key === undefined) return;
            $.post("http://nxgroup_inventario/takeTrunkItem", JSON.stringify({
                item: itemData.key,
                amount: Number($("#amount").val())
            }))
            document.getElementById("amount").value = "";
        }
    })

    $('.puttrunkchestitem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };


            if (itemData.key === undefined) return;
            $.post("http://nxgroup_inventario/storeTrunkItem", JSON.stringify({
                item: itemData.key,
                amount: Number($("#amount").val())
            }))
            document.getElementById("amount").value = "";
        }
    })

    $('.buyitem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };
            method = "Buy"
            if (itemData.key === undefined) return;
            if (ui.draggable.data('slot') == "COMPRAR") {
                $.post("http://nxgroup_inventario/buyItem", JSON.stringify({
                    item: itemData.key,
                    amount: Number($("#amount").val()),
                    method: method,
                    shop: selectShop
                }))
            }

            document.getElementById("amount").value = "";
        }
    })

    $('.sellitem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };
            method = "Sell"
            if (itemData.key === undefined) return;
            console.log(method)
            if (ui.draggable.data('slot') == "VENDER") {
                $.post("http://nxgroup_inventario/sellItem", JSON.stringify({
                    item: itemData.key,
                    amount: Number($("#amount").val()),
                    method: method,
                    shop: selectShop
                }))
            }
            document.getElementById("amount").value = "";
        }
    })

    $('.takeItem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };
            method = "Buy"
            if (itemData.key === undefined) return;
            if (ui.draggable.data('slot') == "COMPRAR") {
                $.post("http://nxgroup_inventario/takeItem", JSON.stringify({
                    item: itemData.key,
                    amount: Number($("#amount").val()),
                    method: method,
                    type: selectShop
                }))
            }

            document.getElementById("amount").value = "";
        }
    })


    $('#bind1').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };
            if (itemData.key === undefined) return;

            $.post("http://nxgroup_inventario/bindItem", JSON.stringify({
                item: itemData.key,
                slot: "1"
            }))

            document.getElementById("amount").value = "";
            updateMochila();
        }

    })
    $('#bind2').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };
            if (itemData.key === undefined) return;

            $.post("http://nxgroup_inventario/bindItem", JSON.stringify({
                item: itemData.key,
                slot: "2"
            }))

            document.getElementById("amount").value = "";
            updateMochila();
        }
    })
    $('#bind3').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };
            if (itemData.key === undefined) return;

            $.post("http://nxgroup_inventario/bindItem", JSON.stringify({
                item: itemData.key,
                slot: "3"
            }))

            document.getElementById("amount").value = "";
            updateMochila();
        }
    })
    $('#bind4').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = { key: ui.draggable.data('item-key') };
            if (itemData.key === undefined) return;

            $.post("http://nxgroup_inventario/bindItem", JSON.stringify({
                item: itemData.key,
                slot: "4"
            }))

            document.getElementById("amount").value = "";
            updateMochila();
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

//<span><s>IDADE:</s> ${data.infos[11]} anos</span>
//<span><s>MULTAS: </s> $${formatarNumero(data.infos[9])}</span> 
//<span><s>BANCO:</s> $${formatarNumero(data.infos[6])}</span>
//<span><s>RG:</s> ${data.infos[5]}</span>
//<span><s>PESO: </s> ${(data.peso).toFixed(2)} / ${(data.maxpeso).toFixed(2)}</span>
//<span><s>VIP: </s> ${data.infos[8]}</span>
const updateIdentity = () => {
    $.post("http://nxgroup_inventario/requestIdentity", JSON.stringify({}), (data) => {
        $(".myName").html(`
			<b>${data.infos[1]} ${data.infos[0]} <i>#${data.infos[3]}</i> </b>
			<div class="infosContent">
				<span><s>Nº:</s> ${data.infos[4]}</span>
				<span><s>CARTEIRA: </s> $${formatarNumero(data.infos[10])}</span>
				<span><s>TRABALHO: </s> ${data.infos[7]}</span>
				<span><s>PESO: </s> ${(data.infos[12]).toFixed(1)} / ${(data.infos[13]).toFixed(1)}</span>
			</div>
		`);
    });
}

var linkImagem = "http://189.1.172.224/img/"
$("#pesoChest").hide()
const updateMochila = () => {
    document.getElementById("amount").value = "";
    $("#invright").hide()
    $("#pesoChest").hide()
    $("#binds").show()
    $(".equipped").show()
    $(".use").show()
    $(".drop").show()
    $(".send").show()
    $("#invleft").css("width", "40vw")
    $("#myWeigth").css("marginTop", "0")
    $("#myWeigth2").hide();
    $(".qtd").css("marginLeft", "0")
    $(".qtd").css("width", "8.5vw")
    $("#myWeigth").css("height", "32%")
    $("#invmidle").css("justifyContent", "normal")
    $("#invmidle").css("width", "40vw")
    $.post("http://nxgroup_inventario/requestMochila", JSON.stringify({}), (data) => {
        linkImagem = data.images
        if (data.b1 != undefined) {
            $('.bind1').html(`<img class="bind-img" src="${linkImagem}${data.b1}.png">`);
        }

        if (data.b2 != undefined) {
            $('.bind2').html(`<img class="bind-img" src="${linkImagem}${data.b2}.png">`);
        }

        if (data.b3 != undefined) {
            $('.bind3').html(`<img class="bind-img" src="${linkImagem}${data.b3}.png">`);
        }

        if (data.b4 != undefined) {
            $('.bind4').html(`<img class="bind-img" src="${linkImagem}${data.b4}.png">`);
        }
        var aux = (data.peso * 100) / data.maxpeso

        if (data.peso == 0) {
            aux = 1
        }
        var elem = document.getElementById("myBar");
        var width = 0;
        var id = setInterval(frame, 5);

        function frame() {
            if (width >= aux) {
                clearInterval(id);
            } else {
                width++;
                elem.style.height = width + '%';
            }
        }

        weightLeft = data.peso;
        maxWeightLeft = data.maxpeso;
        $('#invleft').html("");
        $('#invright').html("");
        $('#equipped').html("");

        const nameList = data.drop.sort((a, b) => (a.name > b.name) ? 1 : -1);
        for (let x = 0; x <= 23; x++) {
            const slot = x.toString();
            if (data.inventario[slot] !== undefined) {
                const v = data.inventario[slot];
                const items = `
					<div class="item" style="background-image: url('${linkImagem}${v.index}.png'); background-size: 70%; background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-item-type="${v.type}" data-name-key="${v.name}" data-slot="${slot}">
						<div id="peso">${(v.peso * v.amount).toFixed(2)}</div>
						<div id="quantity">${formatarNumero(v.amount)}x</div>
						<div id="itemname">${v.name}</div>
						<img src"images/"></img>	
					</div>
				`;
                $('#invleft').append(items)
            } else {
                const items = `<div class="item takedropitem" data-slot="${slot}"></div>`
                $('#invleft').append(items)
            }
        }

        const arma = data.weapons
        for (let x = 0; x < arma.length; x++) {
            let equiped = `<div class="weapon" data-item-key="${arma[x].arma}" data-item-name="${arma[x].index}" data-item-muni="${arma[x].amount}"><img src="${linkImagem}${arma[x].index}.png" alt=""><h1 class="amount">${arma[x].amount}</h1></div>`;
            $('#equipped').append(equiped)
        }
        // updateMochila();
        updateDrag();
    });
}

const updateChest = () => {
    document.getElementById("amount").value = "";
    $("#invright").show();
    $(".equipped").hide()
    $("#invleft").css("width", "694px")
    $("#invright").css("width", "694px")
    $("#binds").hide()
    $("#myWeigth").css("marginTop", ".45vw")
    $("#myWeigth").css("height", "24.5%")
    $("#myWeigth2").show();
    $("#invleft").css("marginBottom", "4vw")
    $(".use").hide()
    $(".drop").hide()
    $(".send").hide()
    $(".qtd").css("padding", "13px")
    $("#invmidle").css("justifyContent", "center")
    $("#invmidle").css("width", "694px")
    $("#invmidle").css("marginTop", "15vw")
    $.post("http://nxgroup_inventario/requestChest", JSON.stringify({}), (data) => {
        
        $(".myName").html(`
			<div class="infosContent">
            <span><s>PESO DA MOCHILA: </s> ${(data.peso).toFixed(1)} / ${(data.maxpeso).toFixed(1)} KG</span>
            <span><s>PESO SUPORTADO DO BAU: </s> ${(data.maxpeso2).toFixed(1)} KG</span>
			</div>
		`);

        $('#invleft').html("");
        $('#invright').html("");
        const nameList = data.inventario.sort((a, b) => (a.name > b.name) ? 1 : -1);
        const nameList2 = data.inventario2.sort((a, b) => (a.name > b.name) ? 1 : -1);
        for (let x = 0; x <= 24; x++) {
            const slot = x.toString();
            if (nameList2[x] !== undefined) {
                const v = nameList2[x];
                const items = `
					<div class="itemchest takechestitem" style="background-image: url('${linkImagem}${v.index}.png'); background-size: 70%; background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-item-type="${v.type}" data-name-key="${v.name}" data-slot="${slot}">
						<div id="peso">${(v.peso * v.amount).toFixed(2)}</div>
						<div id="quantity">${formatarNumero(v.amount)}x</div>
						<div id="itemname">${v.name}</div>
					</div>
				`;
                $('#invleft').append(items)
            } else {
                const items = `<div class="itemchest takechestitem" data-slot="${slot}"></div>`
                $('#invleft').append(items)
            }
        }
        for (let x = 0; x <= 47; x++) {
            const slot = x.toString();
            if (nameList[x] !== undefined) {
                const v = nameList[x];
                const items = `
					<div class="itemchest2 putchestitem" style="background-image: url('${linkImagem}${v.index}.png'); background-size: 70%; background-position: center; background-repeat: no-repeat;" data-item-id="${v.id}" data-item-key="${v.key}" data-item-type="${v.type}" data-name-key="${v.name}" data-slot="${slot}">
						<div id="peso">${(v.peso * v.amount).toFixed(2)}</div>	
						<div id="quantity">${formatarNumero(v.amount)}x</div>
						<div id="itemname">${v.name}</div>
					</div>
				`;
                $('#invright').append(items)
            } else {
                const items = `<div class="itemchest2 putchestitem" data-slot="${slot}"></div>`
                $('#invright').append(items)
            }
        }
        updateDrag();
    });
}

const updateHomeChest = () => {
    document.getElementById("amount").value = "";
    $.post("http://nxgroup_inventario/requestHomeChest", JSON.stringify({}), (data) => {

        $(".myName").html(`
			<div class="infosContent">
            <span><s>PESO DA MOCHILA: </s> ${(data.peso).toFixed(1)} / ${(data.maxpeso).toFixed(1)} KG</span>
            <span><s>PESO SUPORTADO DO BAU: </s> ${(data.maxpeso2).toFixed(1)} KG</span>
			</div>
		`);
    
        $('#invleft').html("");
        $('#invright').html("");
        $("#invright").show();
        $(".equipped").hide()
        $("#invleft").css("width", "694px")
        $("#invright").css("width", "694px")
        $("#binds").hide()
        $("#myWeigth").css("marginTop", ".45vw")
        $("#myWeigth").css("height", "24.5%")
        $("#myWeigth2").show();
        $("#invleft").css("marginBottom", "4vw")
        $(".use").hide()
        $(".drop").hide()
        $(".send").hide()
        $(".qtd").css("padding", "13px")
        $("#invmidle").css("justifyContent", "center")
        $("#invmidle").css("width", "694px")
        $("#invmidle").css("marginTop", "15vw")
        const nameList = data.inventario.sort((a, b) => (a.name > b.name) ? 1 : -1);
        const nameList2 = data.inventario2.sort((a, b) => (a.name > b.name) ? 1 : -1);
        for (let x = 0; x <= 23; x++) {
            const slot = x.toString();
            if (nameList2[x] !== undefined) {
                const v = nameList2[x];
                const items = `
					<div class="itemchest takeHomeitem" style="background-image: url('${linkImagem}${v.index}.png'); background-size: 70%; background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-item-type="${v.type}" data-name-key="${v.name}" data-slot="${slot}">
						<div id="peso">${(v.peso * v.amount).toFixed(2)}</div>
						<div id="quantity">${formatarNumero(v.amount)}x</div>
						<div id="itemname">${v.name}</div>
					</div>
				`;
                $('#invleft').append(items)
            } else {
                const items = `<div class="itemchest takeHomeitem" data-slot="${slot}"></div>`
                $('#invleft').append(items)
            }
        }
        for (let x = 0; x <= 23; x++) {
            const slot = x.toString();
            if (nameList[x] !== undefined) {
                const v = nameList[x];
                const items = `
					<div class="itemchest2 putHomeitem" style="background-image: url('${linkImagem}${v.index}.png'); background-size: 70%; background-position: center; background-repeat: no-repeat;" data-item-id="${v.id}" data-item-key="${v.key}" data-item-type="${v.type}" data-name-key="${v.name}" data-slot="${slot}">
						<div id="peso">${(v.peso * v.amount).toFixed(2)}</div>	
						<div id="quantity">${formatarNumero(v.amount)}x</div>
						<div id="itemname">${v.name}</div>
					</div>
				`;
                $('#invright').append(items)
            } else {
                const items = `<div class="itemchest2 putHomeitem" data-slot="${slot}"></div>`
                $('#invright').append(items)
            }
        }
        updateDrag();
    });
}

const updateTrunkChest = () => {
    document.getElementById("amount").value = "";
    $.post("http://nxgroup_inventario/requestTrunkChest", JSON.stringify({}), (data) => {

        $(".myName").html(`
            <div class="infosContent">
            <span><s>PESO DA MOCHILA: </s> ${(data.peso).toFixed(1)} / ${(data.maxpeso).toFixed(1)} KG</span>
            <span><s>PESO SUPORTADO DO BAU: </s> ${(data.maxpeso2).toFixed(1)} KG</span>
            </div>
        `);


        $('#invleft').html("");
        $('#invright').html("");
        $("#invright").show();
        $(".equipped").hide()
        $("#invleft").css("width", "694px")
        $("#invright").css("width", "694px")
        $("#binds").hide()
        $("#myWeigth").css("marginTop", ".45vw")
        $("#myWeigth").css("height", "24.5%")
        $("#invleft").css("marginBottom", "4vw")
        $(".use").hide()
        $(".drop").hide()
        $(".send").hide()
        $(".qtd").css("padding", "13px")
        $("#invmidle").css("justifyContent", "center")
        $("#invmidle").css("width", "694px")
        $("#invmidle").css("marginTop", "15vw")
        const nameListTrunk = data.inventario.sort((a, b) => (a.name > b.name) ? 1 : -1);
        const nameListTrunk2 = data.inventario2.sort((a, b) => (a.name > b.name) ? 1 : -1);
        for (let x = 0; x <= 23; x++) {
            const slot = x.toString();
            if (nameListTrunk2[x] !== undefined) {
                const v = nameListTrunk2[x];
                const items = `
					<div class="itemchest taketrunkchestitem" style="background-image: url('${linkImagem}${v.index}.png'); background-size: 70%; background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-item-type="${v.type}" data-name-key="${v.name}" data-slot="${slot}">
						<div id="peso">${(v.peso * v.amount).toFixed(2)}</div>
						<div id="quantity">${formatarNumero(v.amount)}x</div>
						<div id="itemname">${v.name}</div>
					</div>
				`;
                $('#invleft').append(items)
            } else {
                const items = `<div class="itemchest taketrunkchestitem" data-slot="${slot}"></div>`
                $('#invleft').append(items)
            }
        }
        for (let x = 0; x <= 23; x++) {
            const slot = x.toString();
            if (nameListTrunk[x] !== undefined) {
                const v = nameListTrunk[x];
                const items = `
					<div class="itemchest2 puttrunkchestitem" style="background-image: url('${linkImagem}${v.index}.png'); background-size: 70%; background-position: center; background-repeat: no-repeat;" data-item-id="${v.id}" data-item-key="${v.key}" data-item-type="${v.type}" data-name-key="${v.name}" data-slot="${slot}">
						<div id="peso">${(v.peso * v.amount).toFixed(2)}</div>	
						<div id="quantity">${formatarNumero(v.amount)}x</div>
						<div id="itemname">${v.name}</div>
					</div>
				`;
                $('#invright').append(items)
            } else {
                const items = `<div class="itemchest2 puttrunkchestitem" data-slot="${slot}"></div>`
                $('#invright').append(items)
            }
        }
        updateDrag();
    });
}

const updateShop = () => {
    document.getElementById("amount").value = "";
    $.post("http://nxgroup_inventario/requestShop", JSON.stringify({ shop: selectShop }), (data) => {
        weightLeft = data.peso;
        maxWeightLeft = data.maxpeso;
        $('#invleft').html("");
        $('#invright').html("");

        $("#invright").show();
        $(".equipped").hide()
        $("#invleft").css("width", "760px")
        $("#invright").css("width", "760px")
        $("#binds").hide()
        $("#myWeigth").css("marginTop", ".45vw")
        $("#myWeigth").css("height", "24.5%")
        $("#invleft").css("marginBottom", "4vw")
        $(".use").hide()
        $(".drop").hide()
        $(".send").hide()
        $(".qtd").css("padding", "13px")
        $("#invmidle").css("justifyContent", "center")
        $("#invmidle").css("width", "694px")
        $("#invmidle").css("marginTop", "15vw")
        const nameList = data.shops.sort((a, b) => (a.name > b.name) ? 1 : -1);
        for (let x = 0; x <= 23; x++) {
            const slot = x.toString();
            if (data.inventario[x] !== undefined) {
                const v = data.inventario[slot];
                const items = `
					<div class="item" style="background-image: url('${linkImagem}${v.index}.png'); background-size: 70%; background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-item-type="${v.type}" data-name-key="${v.name}" data-slot="VENDER">
						<div id="peso">${(v.peso * v.amount).toFixed(2)}</div>
						<div id="quantity">${formatarNumero(v.amount)}x</div>
						<div id="itemname">${v.name}</div>
						<img src"images/"></img>	
					</div>
				`;
                $('#invleft').append(items)
            } else {
                const items = `<div class="item buyitem" data-slot="VENDER"></div>`
                $('#invleft').append(items)
            }
        }
        for (let x = 0; x <= 23; x++) {
            const slot = x.toString();
            if (nameList[x] !== undefined) {
                const v = nameList[x];
                const items = `
					<div class="item" style="background-image: url('${linkImagem}${v.index}.png'); background-size: 60%; background-position: center; background-repeat: no-repeat;" data-item-id="${v.id}" data-item-key="${v.key}" data-item-type="${v.type}" data-name-key="${v.name}" data-slot="COMPRAR">
						<div id="peso">${(v.weight).toFixed(2)}</div>
						<div id="quantity">$${formatarNumero(v.price)}</div>
						<div id="itemname">${v.name}</div>
					</div>
				`;
                $('#invright').append(items)
            } else {
                const items = `<div class="item sellitem" data-slot="COMPRAR"></div>`
                $('#invright').append(items)
            }
        }
        updateDrag();
    });
}


const updateRevistar = () => {
    document.getElementById("amount").value = "";
    $.post("http://nxgroup_inventario/requestRevistar", JSON.stringify({}), (data) => {
        $('#invleft').html("");
        $('#invright').html("");

        $("#invright").show();
        $(".equipped").hide()
        $("#invleft").css("width", "760px")
        $("#invright").css("width", "760px")
        $("#binds").hide()
        $("#myWeigth").css("marginTop", ".45vw")
        $("#myWeigth").css("height", "24.5%")
        $("#invleft").css("marginBottom", "4vw")
        $(".use").hide()
        $(".drop").hide()
        $(".send").hide()
        $(".qtd").css("padding", "13px")
        $("#invmidle").css("justifyContent", "center")
        $("#invmidle").css("width", "694px")
        $("#invmidle").css("marginTop", "15vw")

        for (let x = 0; x <= 23; x++) {
            const slot = x.toString();
            if (data.inventario[x] !== undefined) {
                const v = data.inventario[slot];
                const items = `
            			<div class="item" style="background-image: url('${linkImagem}${v.index}.png'); background-size: 70%; background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-item-type="${v.type}" data-name-key="${v.name}" data-slot="REVISTAR">
            				<div id="peso">${(v.peso * v.amount).toFixed(2)}</div>
            				<div id="quantity">${formatarNumero(v.amount)}x</div>
            				<div id="itemname">${v.name}</div>
            				<img src"images/"></img>	
            			</div>
            		`;
                $('#invleft').append(items)
            } else {
                const items = `<div class="item roubarItem" data-slot="ROUBAR"></div>`
                $('#invleft').append(items)
            }
        }

        for (let x = 0; x <= 23; x++) {
            const slot = x.toString();
            if (data.nInventario[x] !== undefined) {
                const v = data.nInventario[slot];
                const items = `
        			<div class="item" style="background-image: url('${linkImagem}${v.index}.png'); background-size: 70%; background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-item-type="${v.type}" data-name-key="${v.name}" data-slot="REVISTAR">
        				<div id="peso">${(v.peso * v.amount).toFixed(2)}</div>
        				<div id="quantity">${formatarNumero(v.amount)}x</div>
        				<div id="itemname">${v.name}</div>
        				<img src"images/"></img>	
        			</div>
        		`;
                $('#invright').append(items)
            } else {
                const items = `<div class="item" data-slot="REVISTAR"></div>`
                $('#invright').append(items)
            }
        }
        updateDrag();
    });
}