$(() => {
	window.addEventListener("message", function (event) {
            switch (event.data.type) {
                case "notebook2":
				$("body").show()
				Dementera.init();
                openIndex();
				break;
		}
	});

});

function limpaTela(){
    $("#saldoBancario").html("");
    $("#saldoMao").html("");
    $("#saldoMulta").html("");
    $("#phoneNumber").html("");  
    $("#pass").html(""); 
    $("#rg").html(""); 
    $("#cnh").html(""); 
    $("#emprDinamico").html(""); 
}

function openIndex(){
    limpaTela();
    $.post("http://notebook/getIdentidade","", (data) => {
      let identidade = data.identidade[0].identidade[0]
      let multas = data.identidade[0].multas
      $("#saldoBancario").append(`
      <p class="mb-2">Saldo bancário</p>
      <h6 class="mb-0" >${formatarMoeda(identidade.bank*100)}</h6>
      `);
   
      $("#saldoMao").append(`
      <p class="mb-2">Total a mão</p>
      <h6 class="mb-0" >${formatarMoeda(identidade.wallet*100)}</h6>
      `);
   
     $("#pass").append(`
     <p class="mb-2">Passaporte</p>
     <h6 class="mb-0" >${identidade.user_id}</h6>
     `);
     
     $("#rg").append(`
     <p class="mb-2">Registro</p>
     <h6 class="mb-0">${identidade.registration}</h6>
     `);
     
     $("#phoneNumber").append(`
     <p class="mb-2">Fone</p>
     <h6 class="mb-0" >${identidade.phone}</h6>
     `);

     $("#saldoMulta").append(`
     <p class="mb-2">Multa</p>
     <h6 class="mb-0" >${formatarMoeda(multas*100)}</h6>
     `);

     $("#cnh").append(`
     <p class="mb-2">CNH</p>
     <h6 class="mb-0">0</h6>
     `);

     $("#emprDinamico").append(`
     <p class="mb-2">Empregos</p>
     <h6 class="mb-0" >Não</h6>
     `);

    })
    getCar();
}


const getCar = () => {
    $("#tblVeiculo").html("");
    $.post("http://notebook/getCars", JSON.stringify({}), (data) => {
        const nameList2 = data.cars.sort((a, b) => (a.name > b.name) ? 1 : -1);
        let tableVeiculo = ''
        for (let x = 1; x <= nameList2.length ; x++) {
            const v = nameList2[x - 1];
            tableVeiculo +=  `<tr>
            <td>${v.name}</td>
            <td>${returnDetido(v.detido)}</td>
            <td>${v.fuel}%</td>            
            <td>${v.body/10}%</td>
            <td>${v.engine/10}%</td>
             </tr>`
        }
        $("#tblVeiculo").append(tableVeiculo);
    });
  
}

const returnDetido = (sts) => {
    return (sts == 1) ? 'Detido' : 'Garagem'

}

function formatarMoeda(valor) {
    valor = valor + '';
    valor = parseInt(valor.replace(/[\D]+/g,''));
    valor = valor + '';
    valor = valor.replace(/([0-9]{2})$/g, ",$1");
  
    if (valor.length > 6) {
      valor = valor.replace(/([0-9]{3}),([0-9]{2}$)/g, ".$1,$2");
    }
  
   return valor;
  }