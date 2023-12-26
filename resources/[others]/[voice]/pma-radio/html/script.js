function changeVolume(event) {
    let element = event.currentTarget

    let volume_element = document.querySelector('.volumeText')

    volume_element.innerHTML = `
        <p class = 'volumeText'>VOL <strong>${element.value}%</strong></p>
    `    

    let options = {
        method: 'POST',
        data: JSON.stringify({volume: element.value})
    }

    fetch('http://pma-radio/changevolume', options)
}

function changeFreq(event) {
    let element = event.currentTarget

    if (element.value <= -1) {
        return
    }

    let options = {
        method: 'POST',
        data: JSON.stringify({freq: element.value})
    }

    fetch('http://pma-radio/poweredOn', options)
}

function turn_off_radio(event) {
    let element = event.currentTarget
    let status = element.dataset.on
    let freq = document.querySelector('#freq')

    if (status == '1') {
        element.dataset.on = '0'
        element.style.opacity = '50%'

        fetch('http://pma-radio/poweredOff', {method: 'POST'})

    } else {
        element.dataset.on = '1'
        element.style.opacity = '100%'

        let options = {
            method: 'POST',
            data: JSON.stringify({freq: freq.value})
        }

        fetch('http://pma-radio/poweredOn', options)
    }
    
}

window.addEventListener('message', ({data}) => {
    let radio_container = document.querySelector('.radio-image')
    
    if (data.show) {
        radio_container.style.bottom = '0vh'
    } else {
        radio_container.style.bottom = '-100vh'
    }

    
})

document.onkeyup = function(data){
    if (data.which == 27){
        fetch('http://pma-radio/close', {method: 'POST'})
    }
};