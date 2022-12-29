function changeVolume(event) {
    let element = event.currentTarget

    let volume_element = document.querySelector('.volumeText')

    volume_element.innerHTML = `
        <p class = 'volumeText'>VOL <strong>${element.value}%</strong></p>
    `    

    let options = {
        method: 'POST',
        body: JSON.stringify({volume: element.value})
    }
    fetch('http://radio/changevolume', options)
    .catch(err => {
        
    })
}

function changeFreq(event) {
    let element = event.currentTarget

    if (element.value <= -1) {
        return
    }

    let options = {
        method: 'POST',
        body: JSON.stringify({freq: element.value})
    }

    fetch('http://radio/activeFrequency', options)
    .catch(err => {

    })
}

function turn_off_radio(event) {
    let element = event.currentTarget
    let status = element.dataset.on
    let freq = document.querySelector('#freq')

    if (status == '1') {
        element.dataset.on = '0'
        element.style.opacity = '50%'

        let options = {
            method: 'POST',
            body: JSON.stringify({freq: freq.value})
        }

        fetch('http://radio/inativeFrequency', options)
        .catch(err => {
        
        })
    } else {
        element.dataset.on = '1'
        element.style.opacity = '100%'

        let options = {
            method: 'POST',
            body: JSON.stringify({freq: freq.value})
        }

        fetch('http://radio/activeFrequency', options)
        .catch(err => {
        
        })
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
        fetch('http://radio/closeRadio', {method: 'POST'})
        .catch(err => {
        
        })
    }
};