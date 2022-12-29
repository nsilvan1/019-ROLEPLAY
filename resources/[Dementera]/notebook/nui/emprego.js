var idEmp = 0
var processado = 0;

$(function () {
    openJob();
});

function openJob() {
    $("#checkJob").html("");
    $.post("http://vrp_control_people/getUserAtivo", JSON.stringify({}), (data) => {
        const empAtivo = data.empAtivo[0];
        let Job = '';
        let StatusJob = '';
        $("#ativo").hide()
        $("#empregado").hide()
        $("#status").html('');
        if (empAtivo) {
            idEmp = empAtivo.id?empAtivo.id: 0 ;
            // cleanDivEmp()
            if (empAtivo.ativo === 'S') {
                getJob(idEmp);
                $("#status").append(' Status do Emprego: Ativo');
                Job += ` 
                <button type="button" class="btn btn-primary m-2" onclick="changeStatus('Inativo')">Inativar </button>`
                 $("#ativo").show()
            } else {    
                $("#status").append('Status do Emprego: Inativo');
                Job += ` 
                <button type="button" class="btn btn-primary m-2" onclick="changeStatus('Ativo')">Ativar</button>`
            
            }
        } else {
            Job += ` 
            <input type="radio" class="btn-check" name="btnradio" id="Inativo" autocomplete="off" onclick="changeStatus('Inativo')">
            <label class="btn btn-outline-primary" for="Inativo" checked }>Inativo</label>
        
            <input type="radio" class="btn-check" name="btnradio" id="Ativo" autocomplete="off" onclick="changeStatus('Ativo')">
            <label class="btn btn-outline-primary" for="Ativo" }>Ativo</label>
             `
                
            $("#ativo").hide()
            $("#empregado").hide()
        }

        if (StatusJob == 'Ativo') { $("#ativo").show() }
        if (StatusJob == 'Trabalhando') { $("#empregado").show() }

        $("#checkJob").append(Job);
    });
}

function getAceptJob() {
    $("#txtLivre").hide();
    $("#txtEmprego").show();
    getJob(idEmp);
}

function getNewJob() {
    $("#txtLivre").show();
    $("#txtEmprego").hide();
    getJob(0);
}

function getJob(id) {
    console.log(id)
    $.post("http://notebook/getEmpJobs", JSON.stringify({ empUserId: id }), (data) => {
        const nameList2 = data.empDiarios.sort((a, b) => (a.nome > b.nome) ? 1 : -1);
        $("#empregosLivres").html("");
        let item = ''
        console.log(nameList2.length);
        if (nameList2.length == 0) {
            console.log('entrou aqui' )
            getNewJob()
        }

        for (let x = 0; x <= nameList2.length; x++) {
            if (nameList2[x] !== undefined) {
                const v = nameList2[x];
                console.log(JSON.stringify(v))
                item = `                
                <tr>
                   <td>${v.nome}</td>
                   <td>${v.dataInicio}</td>
                   <td><button type="button" class="btn btn-primary m-2" onclick="aceptJob('${v.id}','${idEmp}','${v.nome}')">Aceitar</button></td>
                </tr>
                `
                $("#empregosLivres").append(item);
                $("#ativo").show()

            } else {
                $("#empregado").hide()
            }
        }
    });
}

// function aceptJob(id, empUserId, name) {
//     $.post("http://notebook/postAceitaEmprego", JSON.stringify({ empUserId: empUserId, id: id, name: name }), (data) => {
//         getJob(empUserId);
//         return;
//     });
// }


function changeStatus(status) {
    let ativo = 'N'
    $("#ativo").hide()
    $("#empregado").hide()
    if (status == 'Ativo') { $("#ativo").show(); ativo = 'S'}
    if (status == 'Trabalhando') { $("#empregado").show(); ativo = 'N' }
    atualizaEmpUser(ativo)
}


function aceptJob(id, empUserId, name) {
    console.log("id " + id + " empUserId " + empUserId, " name " + name)
    $.post("http://notebook/postAceitaEmprego", JSON.stringify({ empUserId: empUserId, id: id, name: name }), (data) => {
        getAceptJob()
        return;
    });
}

function decliveJob() {
        $.post("http://notebook/postRemoveEmprego", JSON.stringify({ id: empregoAtivo }), (data) => {
            return;
        });
}

function atualizaEmpUser(ativo) {
    $.post("http://notebook/postEmpUser", JSON.stringify({ ativo: ativo, id: idEmp }), (data) => {
       openJob()
    });
}