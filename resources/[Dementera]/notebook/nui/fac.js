var suaOrg = ''
var userIdLider = 0
let FacDinamic = ''
$(function () {
    updateOrgUserOrg()
    cancelAddUserOrg();
});

var userIdLider

const openFacBau = () => {
    $("#baufac").html("");
    let bauFacDinamic = `<div class="h-100 bg-secondary rounded p-4">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <h6 class="mb-0">Baú</h6>
                                <button type="button" class="btn btn-success rounded-pill m-2"  onclick='openFacBau()' >Atualizar</button>
                            </div>`

    $.post("http://notebook/requestChestOrgs", JSON.stringify({ orgs: suaOrg }), (data) => {
        const nameList2 = data.inventario2.sort((a, b) => (a.name > b.name) ? 1 : -1);

        for (let x = 1; x <= nameList2.length; x++) {
            if (nameList2[x - 1] !== undefined) {
                const v = nameList2[x - 1];
                bauFacDinamic += `<div class="d-flex align-items-center border-bottom py-3">
                                <img class="rounded-circle flex-shrink-0" src="http://189.1.172.114/inventario/${v.index}.png" alt="" style="width: 40px; height: 40px;">
                                <div class="w-100 ms-3">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 class="mb-0">${v.name}</h6>
                                        <small>${v.amount}</small>
                                    </div>
                                </div>
                            </div>`
            }
        }
        bauFacDinamic += '</div>'
        $("#baufac").append(bauFacDinamic);
    });
}

const updateOrgUserOrg = () => {
    $("#fac").html("");
    FacDinamic = ''
    $.post("http://notebook/requestOrgsLider", JSON.stringify({}), (data) => {
        let orgs = data.orgs;
        let facText = ''
        liderGroup = 1
        org = orgs[0].Lider
        suaOrg = orgs[0].org
        if (org || org.length > 0) {
            facText += 'Lider da fac '
            FacDinamic += `  <div class="d-flex align-items-center justify-content-between mb-2">
            <h6 class="mb-0">Integrantes</h6>
            <button type="button" class="btn btn-success rounded-pill m-2"  onclick='modalDinamicUserOrg()' >Adicionar</button>
        </div>`
        }
        facText += suaOrg;
        for (let x = 0; x < orgs.length; x++) {
            if (orgs[0] !== undefined) {
                const v = orgs[x];
                console.log(v.name)
                FacDinamic += `<div class="d-flex align-items-center border-bottom py-3">
                                <img class="rounded-circle flex-shrink-0" src="img/user.jpg" alt="" style="width: 40px; height: 40px;">
                                <div class="w-100 ms-3">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 class="mb-0">${v.name}</h6>
                                        <small>${v.phone}</small>
                                    </div>
                                    <div class="d-flex w-100 justify-content-between">
                                        <span>${facText}</span>`
                if (org) {
                    FacDinamic += `<button type="button" class="btn btn-square btn-primary m-2" onclick="removeUser(${v.user_id})"><i class="fas fa-user-slash"></i></button>`
                }
                FacDinamic += `    </div>
                                </div>
                            </div>`

            }
        }

        FacDinamic += '</div>'
        $("#fac").append(FacDinamic);

        openFacBau();
    })
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
}


function pesquisaUsuario() {
    let passporte = $("#passaporte").val()
    let pass
    let option = ''
    $('#pesqUser').empty();
    $.post("http://vrp_control_people/requestPassportSemOrg", JSON.stringify({ user_id: passporte }), (data) => {
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
        $('#pesqUser').append(option);
    })
    // mockap
}

function adicionar(user_id) {
    $.post("http://vrp_control_people/postOrgs", JSON.stringify({ user_id: user_id, org: suaOrg }), (data) => {
        updateOrgUserOrg()
    })
    cleanAddUsaer();
}

function removeUser(userId) {
    $.post("http://vrp_control_people/removeUserOrgs", JSON.stringify({ user_id: userId, org: suaOrg }), (data) => {
        updateOrgUserOrg()
    })
}