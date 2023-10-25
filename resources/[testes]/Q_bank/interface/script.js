const requestBank = async() => {
  try {
    const response = await fetch('http://Q_bank/requestBank', { method: 'POST', body: JSON.stringify({})})
    const data = await response.text();
    const resultado = JSON.parse(data).resultado;
    document.querySelector('.welcome-message p').innerHTML = `
      Seu saldo disponivel <span>$ ${formatNumber(resultado)}</span> dolares
    `
  } catch (err) {
    
  }
}

const requestFines = async() => {
  try {
    let i = 0;
    const response = await fetch('http://Q_bank/requestFines', { method: 'POST', body: JSON.stringify({})})
    const data = await response.json();
    const items = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
    items.map( item => document.querySelector('.other-items').innerHTML += itemContent('fines', item, i)).join('');
  } catch (err) {
    
  }
}

const requestInvoices = async() => {
  try {
    let i = 0;
    const response = await fetch('http://Q_bank/requestInvoices', {method: 'POST', body: JSON.stringify({})})
    const data = await response.json();
    const items = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
    items.map(item => document.querySelector('.other-items').innerHTML += itemContent('invoices', item, i)).join('');
  } catch (err) {
    
  }
}

const requestMyInvoices = async() => {
  try{ 
    let i = 0;
    const response = await fetch('http://Q_bank/requestMyInvoices', {method: 'POST', body: JSON.stringify({})})
    const data = await response.json();
    const items = data.resultado.sort((a, b) => (a.id > b.id ? 1 : -1));
    items.map( item => document.querySelector('.other-items').innerHTML += itemContent('invoices', item, i)).join('');
  } catch(err) {
    
  }
}

const requestMySalarys = async() => {
  try {
    let i = 0;
    const response = await fetch('http://Q_bank/requestMySalarys', {method: 'POST', body: JSON.stringify({})})
    const data = await response.json();
    if (!data.resultado) return 
    document.querySelector('.other-items').innerHTML = ""
    document.querySelector('.other-items').innerHTML += itemContent('salary', data.resultado, i);
  } catch(err) { }
}

const requestHome = () => {
  document.querySelector('#home').style.display = 'flex';
  document.querySelector('#others-options').style.display = 'none';
}

const itemContent = (type, item, i) => {
  if (type === 'invoices') {
    return `
      <div class="item" data-id-key="${item.id}" data-price-key="${item.price}" data-nuser_id-key="${item.nuser_id}">
        <span>${i = i + 1}</span>
        <div class = "item-description">
          <h6>${item.text}</h6>
          <p>Valor: <span>$${formatNumber(item.price)}</span></p>
        </div>
      </div>
    `
  }
  if (type === 'fines') {
    return `
      <div class="item" data-id-key="${item.id}" data-price-key="${item.price}">
        <div class = "item-content">
          <h6>${item.text}</h6>
          <p>Valor: <span>$${formatNumber(item.price)}</span></p>
          <p>Aplicado: <span>${item.nuser_id}</span></p>
        </div>
      </div>
    `

  }
  if (type === 'salary') {
    return `
      <div class="item" data-id-key="${item.id}" data-price-key="${item.price}">
        <div class = "item-content">
          <h6>Salario #${i = i + 1}</h6>
          <p>Valor: <span>$${item.price}</span></p>
        </div>
      </div>
    `
  }
}

const clearSelected = () => {
  document.querySelectorAll('#menu-options ul li').forEach( page => {
    page.querySelector('p').classList.remove('selected');
    page.querySelector('i').classList.remove('selected');
    page.querySelector('h3').classList.remove('selected');
  })
}

const action = (button) => {
  const type = button.getAttribute('class')

  if (type === 'salario') {
    const itemSelected = document.querySelector('.item.active')
    fetch('http://Q_bank/salaryRecipe', {
      method: 'POST',
      body: JSON.stringify({
        id: itemSelected.getAttribute('data-id-key'),
        price: itemSelected.getAttribute('data-price-key')
      })
    })
    itemSelected.remove();
  }
  if(type === 'faturas') {
    const itemSelected = document.querySelector('.item.active')
    fetch('http://Q_bank/invoicesPayment', {
      method: 'POST',
      body: JSON.stringify({
        id: itemSelected.getAttribute('data-id-key'),
        price: itemSelected.getAttribute('data-price-key'),
        nuser_id: itemSelected.getAttribute('data-nuser_id-key')
      })
    })
    itemSelected.remove();

  } 
  if(type === 'multas') {
    const itemSelected = document.querySelector('.item.active')
    fetch('http://Q_bank/finesPayment', {
      method: 'POST',
      body: JSON.stringify({
        id: itemSelected.getAttribute('data-id-key'),
        price: itemSelected.getAttribute('data-price-key'),
      })
    })
    itemSelected.remove();
  }
}

const loadPages = (page, name) => {
  clearSelected();
  document.querySelector('.other-items').innerHTML = ""
  page.querySelector('p').classList.add('selected');
  page.querySelector('i').classList.add('selected');
  page.querySelector('h3').classList.add('selected');

  if (name === 'home') {
    requestHome()
  } else if ( name === 'invoices' ) { 
    document.querySelector('.title-message').innerHTML = `
      <h4>Faturas Pendentes</h4>
      <p>Faturas pendentes na sua conta bancaria.</p>
    `
    requestInvoices()
    document.querySelector('#home').style.display = 'none';
    document.querySelector('.other-title button').textContent = 'PAGAR'
    document.querySelector('.other-title button').setAttribute('class', 'faturas')
    document.querySelector('#others-options').style.display = 'block';
  } else if ( name === 'fines') { 
    document.querySelector('.title-message').innerHTML = `
      <h4>Multas</h4>
      <p>Multas pendentes para pagar.</p>
    `
    requestFines()
    document.querySelector('#home').style.display = 'none';
    document.querySelector('.other-title button').textContent = 'PAGAR'
    document.querySelector('.other-title button').setAttribute('class', 'multas')
    document.querySelector('#others-options').style.display = 'block';
  } else if ( name === 'salarys') {
    document.querySelector('.title-message').innerHTML = `
      <h4>Salario</h4>
      <p>Registro de salario pendentes.</p>
    `
    requestMySalarys()
    document.querySelector('#home').style.display = 'none';
    document.querySelector('.other-title button').textContent = 'RECEBER'
    document.querySelector('.other-title button').setAttribute('class', 'salario')
    document.querySelector('#others-options').style.display = 'block';
  } else if ( name === 'myInvoices') {
    document.querySelector('.title-message').innerHTML = `
      <h4>Faturas Pendentes</h4>
      <p>Faturas pendentes na sua conta bancaria.</p>
    `
    requestMyInvoices()
    document.querySelector('#home').style.display = 'none';
    document.querySelector('.other-title button').textContent = 'PAGAR'
    document.querySelector('#others-options').style.display = 'block';
  }
}

const onlyNumbers = (e) => {
  let charCode = e.charCode ? e.charCode : e.keyCode;
  if (charCode != 8 && charCode != 9) {
    let max = 9;
    let num = $(".amount").val();

    if (charCode < 48 || charCode > 57 || num.length >= max) {
      return false;
    }
  }
}

const formatNumber = (n) => {
  var n = n.toString();
	var r = '';
	var x = 0;
	for (let i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}
	return r.split('').reverse().join('');
}

const debounce = (func, immediate) => {
  let timeout;
  return function () {
    let context = this,
      args = arguments;
      let later = function () {
      timeout = null;
      if (!immediate) func.apply(context, args);
    };
    let callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, 250);
    if (callNow) func.apply(context, args);
  };
}

$(document).on("click", ".trans1", debounce(() => {
    let id = Number(document.querySelector('#id').value);
    let value = Number(document.querySelector("#trans").value);

    if (id === '') return;
    if (value === '') return;

    fetch('http://Q_bank/bankTransfer', {
      method: 'POST',
      body: JSON.stringify({ 
        id: id,
        valor: value
      }),
    })
    value = ''
}));

$(document).on("click", ".sacar", debounce(() => {
    let value = Number(document.querySelector("#saque").value);
    if (value !== null && value > 0) {
      fetch('http://Q_bank/bankWithdraw', {
        method: 'POST',
        body: JSON.stringify({ saque: value })
      })
      value = '';
    }
  })
);

$(document).on("click", ".depositar", debounce(() => {
    let value = Number(document.querySelector("#deposito").value);
    if (value !== null && value > 0) {
      fetch('http://Q_bank/bankDeposit', {
        method: 'POST',
        body: JSON.stringify({ deposito: value })
      })
      value = ''
    }
  })
);

$(document).on("click", ".item", function () {
  let $el = $(this);
  let isActive = $el.hasClass("active");
  $(".item").removeClass("active");
  if (!isActive) $el.addClass("active");
});

document.querySelector('#exit').addEventListener('click', () => $.post("http://Q_bank/bankClose"));

window.addEventListener('keyup', ({ key }) => {
  if (key === 'Escape') $.post("http://Q_bank/bankClose")
})

window.addEventListener('message', ({ data }) => {

  if (data.action === 'showMenu') {
    if (data.nui === 'banco') {
      requestBank() + requestHome()
      clearSelected()
      document.querySelectorAll('#menu-options ul li')[0].querySelector('p').classList.add('selected');
      document.querySelectorAll('#menu-options ul li')[0].querySelector('i').classList.add('selected');
      document.querySelectorAll('#menu-options ul li')[0].querySelector('h3').classList.add('selected');
      document.querySelectorAll('#home .option')[0].style.opacity = '';
      document.querySelectorAll('#home .option')[0].style.pointerEvents = '';
      document.body.style.display = 'flex';
    } else {
      requestBank() + requestHome()
      document.querySelectorAll('#home .option')[0].style.opacity = '0.6';
      document.querySelectorAll('#home .option')[0].style.pointerEvents = 'none';
      document.body.style.display = 'flex';
    }
  }

  if (data.action === 'requestBank') requestBank();
  if (data.action === 'requestInicio') requestBank() + requestHome();
  if (data.action === 'requestFines') requestBank() + requestFines();
  if (data.action === 'requestInvoices') requestBank() + requestInvoices();
  if (data.action === 'requestMyInvoices')  requestBank() + requestMyInvoices();
  if (data.action === 'requestMySalarys')  requestBank() + requestMySalarys();
  if (data.action === 'hideMenu') document.body.style.display = 'none';
  if (data.action === 'notify') return;
})