function notify(img, message, color) {
    let container = document.querySelector('.notifies-container')
    
    let element = document.createElement('div')
    element.classList.add('notify')

    let line = document.createElement('div')
    line.classList.add('notifyLine')
    line.style.backgroundColor = color
    line.classList.add('width')

    element.innerHTML = `
        <img src="images/${img}" alt="">
        <div class="Titlo-Notify">${codigo}</div>
        <div class="text-Notify">${message}</div>
    `

    element.appendChild(line)

    
    container.appendChild(element)
    element.classList.add('appear')
    
    deleteElement(element)

}

window.addEventListener("message", (event) => {
    let type = event.data.css.toLowerCase()

    let color = ''
    let img = ''

    if (type == 'sucesso') {
        color = '#6FCF97'
        codigo = 'Sucesso'
        img = 'sucess.svg'
    } else if (type == 'negado') {
        color = '#EB5757'
        codigo = 'Negado'
        img = 'cancel.svg'
    } else if (type == 'importante') {
        color = '#4d6cd5'
        codigo = 'Importante'
        img = 'warning.svg'
    } else if (type == 'aviso') {
        color = '#fac638'
        codigo = 'Aviso'
        img = 'aviso.svg'
    }


    notify(img, event.data.message, color)

})


function deleteElement(element) {
    setTimeout(() => {
        element.classList.remove('appear')
        element.classList.add('disappear')
        setTimeout(() => {
            element.remove()
        }, 590);
    }, 8000);
}