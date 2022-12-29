
$(function () {
    openGrupo();
    cancelAddUserOrg();
});

var userIdLider
var Grupos = 0 
const openGrupo = () => {
    $("#groups").html("");
    let FacDinamic = `  <div class="d-flex align-items-center justify-content-between mb-2">
                                <h6 class="mb-0">Integrantes</h6>
                                <button type="button" class="btn btn-success rounded-pill m-2"  onclick='modalDinamicUserOrg()' >Adicionar</button>
                            </div>`
    $.post("http://notebook/requestGroup", '', (data) => {
        const grupo = data.group;
        if (grupo.length > 0) {
            $("#groups").show()
            $("#newGroup").hide()
            const v = grupo[0];
            FacDinamic += `<h6>Grupo ${v.nome}  -  radio: ${v.radio} </h6>
                              <button type="button" class="btn btn-square btn-primary m-2" onclick="removeGrupo(${v.id})"><i class="fas fa-user-slash"></i></button>`
            Grupos = v.id
            $.post("http://notebook/requestGroupUsers", JSON.stringify({ idGroup: v.id }), (data) => {
                const userGrupo = data.group;
                for (let i = 0; i < userGrupo.length; i++) {
                    FacDinamic += `<div class="d-flex align-items-center border-bottom py-3">
                                        <div class="w-100 ms-3">
                                            <div class="d-flex w-100 justify-content-between">
                                                <h6 class="mb-0">${userGrupo[i].name}</h6>
                                                
                                            </div>
                                            <div class="d-flex w-100 justify-content-between">
                                                <h6 class="mb-0">${userGrupo[i].phone}</h6>
                                                <button type="button" class="btn btn-square btn-primary m-2" onclick="removeUser(${userGrupo[i].user_id})"><i class="fas fa-user-slash"></i></button>
                                            </div>
                                        </div>
                                    </div>`
                  
                }
                FacDinamic += '</div>'
                $("#groups").append(FacDinamic);
            });
        } else {
            $("#groups").hide()
            $("#newGroup").show()
        }
    });
}

function removeUser(user_id){
    $.post("http://notebook/delGroupUser", JSON.stringify({ user_id: user_id, id_grupo: Grupos }), (data) => {
        openGrupo();
    })
    cancelAddUserOrg()
}


function criaGroup() {
    console.log('criou o Grupo')
}

function cleanAddUsaer() {
    $("#passaporte").val("")
    $("#pesqUSer").html("");
}

function modalDinamicUserOrg() {
    cleanAddUsaer()
    $("#addIntegrante").show()
}

function cancelAddUserOrg() {
    cleanAddUsaer()
    $("#addIntegrante").hide()
    $("#nameGroup").val("")
    $("#radioGroup").val("")

}


function pesquisaUsuario() {
    let passporte = $("#passaporte").val()
    let pass
    let option = ''
    $('#pesqUSer').empty();

    $.post("http://notebook/requestPassportSemGroup", JSON.stringify({ user_id: passporte }), (data) => {
        let passport = data.passport;
        for (let i = 0; i < passport.length; i++) {
            pass = passport[i]
            option += `<div class="d-flex align-items-center border-bottom py-3">
                        <img class="rounded-circle flex-shrink-0" src="img/user.jpg" alt="" style="width: 40px; height: 40px;">
                        <div class="w-100 ms-3">
                            <div class="d-flex w-100 justify-content-between">
                                <h6 class="mb-0">${pass.name}</h6>                                
                            </div>
                            <div class="d-flex w-100 justify-content-between">                             
                              <small>${pass.phone}</small>
                              <button type="button" class="btn btn-square btn-primary m-2" onclick="adicionar(${pass.user_id})"><i class="fas fa-user-plus"></i></button>
                            </div>
                        </div>
                     </div>`;
        }
        $('#pesqUSer').append(option);
    })
}

function adicionar(user_id) {
    $.post("http://notebook/postGroupUser", JSON.stringify({ user_id: user_id, id_grupo: Grupos }), (data) => {
        openGrupo();
    })
    cancelAddUserOrg()
}


function removeGrupo(id){
    $.post("http://notebook/delGroup", JSON.stringify({ id_grupo: id }), (data) => {
        openGrupo();
    })
    cancelAddUserOrg()
}

function createGroup(){
    nameGroup = $("#nameGroup").val()
    radioGroup = $("#radioGroup").val()
    $.post("http://notebook/postGroup", JSON.stringify({ name: nameGroup, radio:radioGroup }), (data) => {
        openGrupo();
    })
    cancelAddUserOrg()
}