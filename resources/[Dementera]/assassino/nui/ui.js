$(() => {
	$("body").hide()
	cleanDiv();
	window.addEventListener("message", function (event) {
		switch (event.data.action) {
			case "cacador":
				$("body").show();
				Everest.init();
				permitePolicia();
				openDiv('addprocuradoAll');
				break;
		}
	});

});
 
var permiteAlteracao = false
var policia = false
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

function permitePolicia() {
	$.post("http://cacador_recompensa/permitePolicia", "", (data) => {
		policia = data.permissao;
		let menu =  ""
		$("#menuPRocurado").empty();
		if (policia){
			menu =	`
			<li class="nav-item menu-items active">
				<button class="nav-link" onclick="openDiv('addprocuradoAll')">
				<span class="menu-title">Procurados</span>
				</button>
			</li>
			`
		}else {
			menu =	`
			<li class="nav-item menu-items active">
				<button class="nav-link" onclick="openDiv('empregado')">
				<span class="menu-title">Empregados</span>
				</button>
			</li>
			<li class="nav-item menu-items active">
				<button class="nav-link" onclick="openDiv('procurado')">
				<span class="menu-title">Recompensas</span>
				</button>
			</li>
			<li class="nav-item menu-items active">
				<button class="nav-link" onclick="openDiv('hierarquia')">
				<span class="menu-title">Hierarquia</span>
				</button>
			</li>
			<li class="nav-item menu-items active">
				<button class="nav-link" onclick="openDiv('addprocuradoAll')">
				<span class="menu-title">Procurados</span>
				</button>
			</li>

			`
		}
		$('#menuPRocurado').append(menu);
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
		case 'procuradosatt':
			$("#procuradosatt").show()
			getProcurados()
			break;
		case 'addprocuradoAll':{
			$("#addprocuradoAll").show()
			getProcuradoAll()
			break;
		}
	}
}

function cleanDiv() {
	permiteAlterar();
	$("#empregado").hide()
	$("#procurado").hide()
	$("#hierarquia").hide()
	$("#procuradosatt").hide()
	$("#addprocuradoAll").hide()
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
				  <td> ${arrCacador[i].firstname}  </td>
				  <td> ${arrCacador[i].phone} </td>
				  <td> ${arrCacador[i].hierarquia_nome} `
			if (permiteAlteracao) {
				option += `</td> <td> 	<button class="badge btn-outline-info" onclick="modalEditeCacador('${arrCacador[i].name}', '${arrCacador[i].cacador_id}')">Alterar</button> </td>
					<td>`
				if (arrCacador[i].ativo === 'S') {
					option += `	<button class="badge badge-outline-danger" onclick="statusCacador('${arrCacador[i].cacador_id}', 'N')">Remover</button>`
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
	
	$.post("http://cacador_recompensa/updateHierarquiaCacador", JSON.stringify({ id: id, hierarquia_id: hierarquia_id }), (data) => { 
		
	})
	setTimeout(function(){
		getCacadores()
		$('#myModal').modal('hide');
	  }, 500);
	  
	
}

function statusCacador(cacador_id, status) {
	$.post("http://cacador_recompensa/updateCacador", JSON.stringify({ id: cacador_id, status: status }), (data) => {
	
	})
	setTimeout(function(){
		getCacadores()
		$('#myModal').modal('hide');
	  }, 500);
	  

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
		switch (page) {
			case 'empregado':
				addPessoaModal(passport);
				break;
		    case 'procuradoAll':
				addProcuradoAllModal(passport)
				break;
			case 'procurado':
				addProcuradoModal(passport)
				break;
		}
	})
}

function addPessoaModal(passport) {
	let option = `
			<div class="table-responsive">
			<table class="table">
			  <thead>
				<tr>
				<th> Nome </th>
				<th> Sobrenome </th>
				<th> Celular </th>
				  <th> Hierarquia </th>
				  <th> </th>
				</tr>
			  </thead>
			  <tbody>`
	for (let i = 0; i < passport.length; i++) {
		option += `
				<tr>
				<td> ${passport[i].name}  </td>
				<td> ${passport[i].firstname}  </td>
				<td>  ${passport[i].phone} </td>
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
	setTimeout(function(){
		getCacadores()
		$('#myModal').modal('hide');
	  }, 500);
	
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
				  <td> R$ ${arrProcurado[i].recompensa}  </td> `
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


function getProcuradoAll() {
	$("#procuradosAllTable").empty();
	if (permiteAlteracao){
		$("#btnProcuradoAll").show();
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
				  <td> ${arrProcurado[i].motivo} </td> `
			if (permiteAlteracao) {
				option += `<td> 	<button class="badge btn-outline-info" 
				                 onclick="modaRecopensaProcurado('${arrProcurado[i].name}'
														 ,'${arrProcurado[i].procurado_id}')">Adicionar Recompensa</button> </td>
				  <td>	<button class="badge badge-outline-danger" onclick="removerProcuradoAll('${arrProcurado[i].procurado_id}')">Remover</button> </td>`
			}
			option += `</tr>`
		}

		$('#procuradosAllTable').append(option);

	})
}

function addProcuradoModal(passport) {
	let option = `
		<div class="table-responsive">
		<table class="table">
		  <thead>
			<tr>
			  <th> Nome </th>
			  <th> Sobrenome </th>
			  <th> Recompensa </th>
			  <th> </th>
			</tr>
		  </thead>
		  <tbody>`
	for (let i = 0; i < passport.length; i++) {
		option += `
			<tr>
			  <td> ${passport[i].name}  </td>
			  <td> ${passport[i].firstname}  </td>
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
	getProcurado()
}

function addProcuradoAllModal(passport) {
	let option = `
		<div class="table-responsive">
		<table class="table">
		  <thead>
			<tr>
			  <th> Nome </th>
			  <th> Sobrenome </th>
			  <th> Motivo </th>
			  <th> </th>
			</tr>
		  </thead>
		  <tbody>`
	for (let i = 0; i < passport.length; i++) {
		option += `
			<tr>
			  <td> ${passport[i].name}  </td>
			  <td> ${passport[i].firstname}  </td>
			  <td> <input type="text" class="modal-text input_full" id="motivo" > </input>
				
			  <td>
				<button class="badge btn-outline-info" onclick="addProcAll('${passport[i].user_id}')">Adicionar</button>
			  </td>`

	}
	option += `</tr>
			</tbody>
		</table>
		</div>`;
	$('#dvPass').append(option);
	getProcuradoAll()
}


function addProcurado(user_id) {
	let recompensa = $("#recompensa").val();
	$.post("http://cacador_recompensa/insertRecompensa", JSON.stringify({ user_id: user_id, recompensa: recompensa, motivo: '' }), (data) => {
		
	})
	setTimeout(function(){
		getProcurado()	
		$('#myModal').modal('hide');	
	  }, 500);
	  
	
}

function addProcAll(user_id) {
	let motivo = $("#motivo").val();
	$.post("http://cacador_recompensa/insertRecompensa", JSON.stringify({ user_id: user_id, recompensa: 0 ,motivo: motivo }), (data) => {
		
	})
	setTimeout(function(){
		getProcuradoAll()
		$('#myModal').modal('hide');
	  }, 500);
	
}


function removerProcurado(id) {
	$.post("http://cacador_recompensa/removeProcurado", JSON.stringify({ id: id }), (data) => {
		
	})
	setTimeout(function(){
		getProcurado()	
	  }, 500);
	
}

function removerProcuradoAll(id) {
	$.post("http://cacador_recompensa/removeProcurado", JSON.stringify({ id: id }), (data) => {
		
	})
	setTimeout(function(){
		getProcuradoAll()
	  }, 500);
	
	
}

function modalPagamentoProcurado(nome, valor, id) {
	$(".modal-content").empty();

	let header = `<div class="modal-header"> 
    <h4 class="modal-title modal-text">Pagar pelo procurado: ${nome}</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-6">
		    <h4 class="modal-text"> Recompensa </h4>
			<h4 class="modal-text">  R$${valor} </h4>
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

function modaRecopensaProcurado(nome, id) {
	$(".modal-content").empty();

	let header = `<div class="modal-header"> 
    <h4 class="modal-title modal-text">Adicionar recompensa para o procurado: ${nome}</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-6">
		    <h4 class="modal-text"> Recompensa </h4>
			<input class="modal-text input_full" type="number" id="reconpensaValor" >
        </div>
	</div>
	</div>
    <div class="modal-footer">      
	   <button type="button" class="badge btn-outline-info" onclick="updateRecompensaInset( ${id})">Alterar</button>
       <button type="button" class="badge btn-light" data-dismiss="modal">Fechar</button>
    </div>`;

	$(".modal-content").append(header)

	$("#myModal").modal({
		show: true
	});
	selectHierarquia()

}

function updateRecompensaInset( id) {
	let recompensa = $("#reconpensaValor").val()
	   $.post("http://cacador_recompensa/updateRecompensa", JSON.stringify({ id: id, recompensa: recompensa }), (data) => {
	})
	
	setTimeout(function(){
		getProcuradoAll()
		$('#myModal').modal('hide');
	  }, 500);
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
	
	setTimeout(function(){
		getHierarquia()
		$('#myModal').modal('hide');
	  }, 500);
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