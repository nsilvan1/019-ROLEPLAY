$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var RadioChannel = '0.0';
  var Emergency = false;
  var Powered = true;

  function escapeHtml (string) {
    return String(string).replace(/[&<>"'`=\/]/g, function (s) {
      return entityMap[s];
    });
  }

  

  function closeGui() {
      if (Powered) {
        if ( RadioChannel < 1.0 || RadioChannel > 799.9 ) {
          if (RadioChannel < 1 && Emergency) {
          } else {  
            RadioChannel = '0.0'
          }      
        }
        $.post('http://pma-radio/close', JSON.stringify({ channel: RadioChannel }));
      } else {
        $.post('http://pma-radio/cleanClose', JSON.stringify({ }));
      }
  }

  function closeSave() {
      if (Powered) {
        RadioChannel = parseFloat($("#RadioChannel").val())
        if (!RadioChannel) {
          RadioChannel = '0.0'
        }
      }
      closeGui()
  }

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    if (item.reset === true) {
      closeGui()
    }
    if (item.set === true) {
      RadioChannel = item.setChannel
    }
    if (item.open === true) {

      Emergency = item.jobType

      if (RadioChannel != '0.0' && Powered) {
        $("#RadioChannel").val(RadioChannel)
      } else {
        if (Powered) {
          $("#RadioChannel").val('')
          $("#RadioChannel").attr("placeholder", "24 - 1000");
        } else {
          $("#RadioChannel").val('')
          $("#RadioChannel").attr("placeholder", "Off");
        }
        
      }
      
      $(".full-screen").fadeIn(100);
       $(".radio-container").fadeIn(100);
      $("#cursor").css("display", "block");
      $("#RadioChannel").focus()
    } 
    if (item.open === false) {
      $(".full-screen").fadeOut(100);
      $(".radio-container").fadeOut(100);
      $("#cursor").css("display", "none");
    }

  });

  $('#Radio-Form').submit(function(e) { 
    e.preventDefault();
    closeSave();
  });

  $("#power").click(function() {
    if (Powered === false) {
      Powered = true;
      $("#RadioChannel").val(RadioChannel)
      $.post('http://pma-radio/click', JSON.stringify({}));
      $.post('http://pma-radio/poweredOn', JSON.stringify({ channel: RadioChannel }));
    } else {
      Powered = false;
      $.post('http://pma-radio/click', JSON.stringify({}));
      $.post('http://pma-radio/poweredOff', JSON.stringify({}));

      $("#RadioChannel").val('')
      $("#RadioChannel").attr("placeholder", "Off");
    }   
  });
  $("#volumeUp").click(function() {
    $.post('http://pma-radio/click', JSON.stringify({}));
    $.post('http://pma-radio/volumeUp', JSON.stringify({}));
  });
  
  $("#volumeDown").click(function() {
    $.post('http://pma-radio/click', JSON.stringify({}));
    $.post('http://pma-radio/volumeDown', JSON.stringify({}));
  });

  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (data.which == 27 ) {
      closeSave()
    }
  };

});
