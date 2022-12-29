$(() => {
	$("body").hide()
	cleanDiv();
	window.addEventListener("message", function (event) {
		switch (event.data.action) {
			case "cacador":
				$("body").show()
				Everest.init();
				break;
		}
	});

});

var permiteAlteracao = false
var Everest = {}
Everest = {
	init: function () {
		document.onkeyup = function (data) {
			if (data.which == 27) {
				$("body").hide()
				$.post("http://cacador_recompensa/ButtonClick", JSON.stringify({ action: "fecharCaca" }));
			}
		}
	}
}

function permiteAlterar() {
	$.post("http://cacador_recompensa/permiteAlterar", "", (data) => {
		permiteAlteracao = data.alterar == 'S' ? true : false;
	})
}

function openDiv(div) {
	cleanDiv()
	switch (div) {
		case 'empregado':
			$("#empregado").show()
			getCacadores()
			break;
		case 'procurado':
			$("#procurado").show()
			getProcurado()
			break;
		case 'hierarquia':
			$("#hierarquia").show()
			getHierarquia()
			break;
	}
}

function cleanDiv() {
	permiteAlterar();
	$("#empregado").hide()
	$("#procurado").hide()
	$("#hierarquia").hide()
}

function getCacadores() {
	$("#cacadoresTable").empty();
	if (permiteAlteracao){
		$("#btnEmpregado").show();
	}
	$.post("http://cacador_recompensa/requestCacadores", "", (data) => {
		let arrCacador = data.cacadores;
		let option = ""
		for (let i = 0; i < arrCacador.length; i++) {
			option += `
				<tr>
				  <td> ${arrCacador[i].user_id} </td>
				  <td> ${arrCacador[i].name}  </td>
				  <td> ${arrCacador[i].phone} </td>
				  <td> ${arrCacador[i].hierarquia_nome} `
			if (permiteAlteracao) {
				option += `</td> <td> 	<button class="badge btn-outline-info" onclick="modalEditeCacador('${arrCacador[i].name}', '${arrCacador[i].cacador_id}')">Alterar</button> </td>
					<td>`
				if (arrCacador[i].ativo === 'S') {
					option += `	<button class="badge badge-outline-danger" onclick="statusCacador('${arrCacador[i].cacador_id}', 'N')">Inativar</button>`
				} else {
					option += `<button class="badge badge-outline-success" onclick="statusCacador('${arrCacador[i].cacador_id}', 'S')">Ativar</button>`
				}
			}
			option += `	  </td>
				</tr>`
		}

		$('#cacadoresTable').append(option);

	})
}

function modalEditeCacador(nome, id) {
	$(".modal-content").empty();

	let header = `<div class="modal-header"> 
    <h4 class="modal-title modal-text">Alterando a hierarquia do caçador: ${nome}</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-12">
		    <h4 class='modal-text'> Hierarquia </h4>
			<select  class='modal-text' id="cmbHierarquia" name="cmbHierarquia">
				<option  class='modal-text' value="0">Selecione uma Hirarquia</option>
			</select>  
        </div>
	</div>
    <div class="modal-footer">      
	   <button type="button" class="badge btn-outline-info" onclick="updateCacadorHierarquia( ${id})">Alterar</button>
       <button type="button" class="badge btn-light" data-dismiss="modal">Fechar</button>
    </div>`;

	$(".modal-content").append(header)

	$("#myModal").modal({
		show: true
	});
	selectHierarquia()

}

function updateCacadorHierarquia(id) {
	let hierarquia_id = $("#cmbHierarquia option:selected").val();
	$.post("http://cacador_recompensa/updateHierarquiaCacador", JSON.stringify({ id: id, hierarquia_id: hierarquia_id }), (data) => { })
	$('#myModal').modal('hide');
	getCacadores()
}

function statusCacador(cacador_id, status) {
	$.post("http://cacador_recompensa/updateCacador", JSON.stringify({ id: cacador_id, status: status }), (data) => {
	})
	getCacadores()
}

function modalDinamicAddUser(page) {
	$(".modal-content").empty();

	let header = `<div class="modal-header"> 
    <h4 class="modal-title modal-text">Adicionar pessoa</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-6">
             <input class="modal-text input_full" id="txtPass" type="text" placeholder="Informe o passaporte">
         
        </div>
		<div class="col-6">
	    	<button type="button" class="badge btn-outline-info" onclick="pesquisarPessoa('${page}')">procurar</button>
	   </div>
	   <div class="col-12">
		 <div id='dvPass' class='row'>
		 </div>
		</div>
	</div>
    <div class="modal-footer">      

       <button type="button" class="badge btn-light" data-dismiss="modal">Close</button>
    </div>`;

	$(".modal-content").append(header)

	$("#myModal").modal({
		show: true
	});
}

function selectHierarquia() {
	$("#cmbHierarquia").empty();

	$.post("http://cacador_recompensa/getHierarquia", "", (data) => {
		let arrHierarquia = data.hierarquia;
		let option = ""
		for (let i = 0; i < arrHierarquia.length; i++) {
			option += `	<option value="${arrHierarquia[i].id}">${arrHierarquia[i].nome} </option>`
		}

		$('#cmbHierarquia').append(option);

	})
}

function pesquisarPessoa(page) {
	let passporte = $("#txtPass").val()
	$('#dvPass').empty();
	$.post("http://cacador_recompensa/requestPassport", JSON.stringify({ user_id: passporte }), (data) => {
		let passport = data.passport;
		if (page == 'empregado') {
			addPessoaModal(passport)
		} else {
			addProcuradoModal(passport)
		}
	})
}

function addPessoaModal(passport) {
	let option = `
			<div class="table-responsive">
			<table class="table">
			  <thead>
				<tr>
				  <th> Fone </th>
				  <th> Nome </th>
				  <th> Hierarquia </th>
				  <th> </th>
				</tr>
			  </thead>
			  <tbody>`
	for (let i = 0; i < passport.length; i++) {
		option += `
				<tr>
				  <td>  ${passport[i].phone} </td>
				  <td> ${passport[i].name}  </td>
				  <td>   
				    <select  class='modal-text' id="cmbHierarquia" name="cmbHierarquia" >
						<option  class='modal-text' value="0">Selecione uma Hirarquia</option>
					</select>  </td>
				  <td>
					<button class="badge btn-outline-info" onclick="addCacador('${passport[i].user_id}')">Adicionar</button>
				  </td>`

	}
	option += `</tr>
				</tbody>
			</table>
			</div>`;
	$('#dvPass').append(option);
	selectHierarquia()
}

function addCacador(user_id) {
	let hierarquia_id = $("#cmbHierarquia option:selected").val();
	$.post("http://cacador_recompensa/addCacador", JSON.stringify({ user_id: user_id, hierarquia_id: hierarquia_id }), (data) => {

	})
	$('#myModal').modal('hide');
	getCacadores()
}

// -------------------  procurado ---------------

function getProcurado() {
	$("#procuradosTable").empty();
	if (permiteAlteracao){
		$("#btnProcurado").show();
	}
	$.post("http://cacador_recompensa/requestProcurados", "", (data) => {
		let arrProcurado = data.procurados;
		let option = ""

		for (let i = 0; i < arrProcurado.length; i++) {
			option += `
				<tr>
				  <td> ${arrProcurado[i].user_id} </td>
				  <td> ${arrProcurado[i].name}  </td>
				  <td> ${arrProcurado[i].firstname} </td>
				  <td> ${arrProcurado[i].recompensa}  </td> `
			if (permiteAlteracao) {
				option += `<td> 	<button class="badge btn-outline-info" 
				                 onclick="modalPagamentoProcurado('${arrProcurado[i].name}'
								                         ,'${arrProcurado[i].recompensa}'
														 ,'${arrProcurado[i].procurado_id}')">Pagar</button> </td>
				  <td>	<button class="badge badge-outline-danger" onclick="removerProcurado('${arrProcurado[i].procurado_id}')">Remover</button> </td>`
			}
			option += `</tr>`
		}

		$('#procuradosTable').append(option);

	})
}

function addProcuradoModal(passport) {
	let option = `
		<div class="table-responsive">
		<table class="table">
		  <thead>
			<tr>
			  <th> Nome </th>
			  <th> Recompensa </th>
			  <th> </th>
			</tr>
		  </thead>
		  <tbody>`
	for (let i = 0; i < passport.length; i++) {
		option += `
			<tr>
			  <td> ${passport[i].name}  </td>
			  <td> <input type="number" class="modal-text input_full" id="recompensa" > </input>
				
			  <td>
				<button class="badge btn-outline-info" onclick="addProcurado('${passport[i].user_id}')">Adicionar</button>
			  </td>`

	}
	option += `</tr>
			</tbody>
		</table>
		</div>`;
	$('#dvPass').append(option);
}

function addProcurado(user_id) {
	let recompensa = $("#recompensa").val();
	$.post("http://cacador_recompensa/insertRecompensa", JSON.stringify({ user_id: user_id, recompensa: recompensa }), (data) => {

	})
	$('#myModal').modal('hide');
	getProcurado()
}

function removerProcurado(id) {
	$.post("http://cacador_recompensa/removeProcurado", JSON.stringify({ id: id }), (data) => {

	})
	getProcurado()
}

function modalPagamentoProcurado(nome, valor, id) {
	$(".modal-content").empty();

	let header = `<div class="modal-header"> 
    <h4 class="modal-title modal-text">Pagar pelo procurado: ${nome}</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-6">
		    <h4 class="modal-text"> Recompensa </h4>
			<h4 class="modal-text">  ${valor} </h4>
        </div>
		<div class="col-6">
		<h4 class="modal-text"> Passaporte </h4>
		<input class="modal-text input_full" type="number" id="userIdPagamento" >
	</div>
	</div>
    <div class="modal-footer">      
	   <button type="button" class="badge btn-outline-info" onclick="pagamentoProcurado( ${valor}, ${id})">Pagar</button>
       <button type="button" class="badge btn-light" data-dismiss="modal">Fechar</button>
    </div>`;

	$(".modal-content").append(header)

	$("#myModal").modal({
		show: true
	});
	selectHierarquia()

}

function pagamentoProcurado(valor, id) {
	let passaporte = $("#userIdPagamento").val()
	$.post("http://cacador_recompensa/pagamentoRecompensa", JSON.stringify({ id: id, valor: valor, passaporte: passaporte }), (data) => {

	})
	$('#myModal').modal('hide');
	getProcurado()
}

// ------------------- Hierarquia ----------------
function inclusaoHierarquia() {
	let nameHierarquia = $('#txtNameH').val()
	$.post("http://cacador_recompensa/postCacadorHierarquia",
		JSON.stringify({ nome: nameHierarquia, id: 0 }), (data) => { })
	openDiv('hierarquia')
}

function updateHierarquia(id) {
	let nameHierarquia = $('#txtPass').val()
	let altera = $("#cmbHierarquiaAltera option:selected").val();
	$.post("http://cacador_recompensa/postCacadorHierarquia",
		JSON.stringify({ nome: nameHierarquia, id: id, altera: altera }), (data) => { })
	$('#myModal').modal('hide');
	openDiv('hierarquia')
}

function getHierarquia() {
	$("#hierarquiaTable").empty();
	if (permiteAlteracao){
		$("#btnHierarquia").show();
		$("#txtNameH").show();		
	}
	$.post("http://cacador_recompensa/getHierarquia", "", (data) => {
		let arrHierarquia = data.hierarquia;
		let option = ""
		for (let i = 0; i < arrHierarquia.length; i++) {
			let alterar = arrHierarquia[i].altera == 'N' ? 'NÃO' : 'SIM'
			option += `
				<tr>
				  <td> ${arrHierarquia[i].nome} </td>
				  <td> ${alterar} </td>
				  <td>`
			if (permiteAlteracao) {
				option += `<button class="badge badge-outline-success" onclick="modalAlteracaoHirarquia('${arrHierarquia[i].nome}', ${arrHierarquia[i].id}, '${arrHierarquia[i].altera}')">Alterar</button>`
			}
			option += `	  </td>
				</tr>`
		}

		$('#hierarquiaTable').append(option);

	})
}

function modalAlteracaoHirarquia(nome, id, altera) {
	$(".modal-content").empty();

	let header = `<div class="modal-header"> 
    <h4 class="modal-title modal-text">Alterar descição</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-6">
             <input class="modal-text input_full"  id="txtPass" type="text" placeholder="Informe a nova Hierarquia">
        </div>
		<div class="col-6">
		<select  class='modal-text' id="cmbHierarquiaAltera" name="cmbHierarquiaAltera">
		<option  class='modal-text' value="N">Não</option>
		<option  class='modal-text' value="S">Sim</option>
	</select>  
        </div>
	</div>
    <div class="modal-footer">      
	   <button type="button" class="badge btn-outline-info" onclick="updateHierarquia( ${id})">Alterar</button>
       <button type="button" class="badge btn-light" data-dismiss="modal">Fechar</button>
    </div>`;

	$(".modal-content").append(header)

	$("#myModal").modal({
		show: true
	});
	$("#txtPass").val(nome)
	$("#cmbHierarquiaAltera").val(altera);

}

