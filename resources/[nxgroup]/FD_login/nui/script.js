let selectedSpawn;

(function ($) {
    $.fn.cascadeSlider = function (opt) {
        var $this = this,
            itemClass = opt.itemClass || 'cascade-slider_item',
            arrowClass = opt.arrowClass || 'cascade-slider_arrow',
            $item = $this.find('.' + itemClass),
            $arrow = $this.find('.' + arrowClass),
            itemCount = $item.length;

        var defaultIndex = 0;

        changeIndex(defaultIndex);

        $arrow.on('click', function () {
            var action = $(this).data('action'),
                nowIndex = $item.index($this.find('.now'));

            if (action == 'next') {
                if (nowIndex == itemCount - 1) {
                    changeIndex(0);
                } else {
                    changeIndex(nowIndex + 1);
                }
            } else if (action == 'prev') {
                if (nowIndex == 0) {
                    changeIndex(itemCount - 1);
                } else {
                    changeIndex(nowIndex - 1);
                }
            }

            $('.cascade-slider_dot').removeClass('cur');
        });

        for (var i = 0; i < itemCount; i++) {
            $('.cascade-slider_item').each(function (i) {
                $(this).attr('data-slide-number', [i]);
            });
        }

        $('.cascade-slider_dot').bind('click', function () {
            $('.cascade-slider_dot').removeClass('cur');
            $(this).addClass('cur');

            var index = $(this).index();
            console.log($(this).index())
            $('.cascade-slider_item').removeClass('now prev next');
            var slide = $('.cascade-slider_slides').find('[data-slide-number=' + index + ']');
            slide.prev().addClass('prev');
            slide.addClass('now');
            slide.next().addClass('next');

            if (slide.next().length == 0) {
                $('.cascade-slider_item:first-child').addClass('next');
            }

            if (slide.prev().length == 0) {
                $('.cascade-slider_item:last-child').addClass('prev');
            }
        });

        function changeIndex(nowIndex) {
            $this.find('.now').removeClass('now');
            $this.find('.next').removeClass('next');
            $this.find('.prev').removeClass('prev');
            if (nowIndex == itemCount - 1) {
                $item.eq(0).addClass('next');
            }
            if (nowIndex == 0) {
                $item.eq(itemCount - 1).addClass('prev');
            }

            selectedSpawn = spawns[nowIndex];

            $item.each(function (index) {
                if (index == nowIndex) {
                    $item.eq(index).addClass('now');
                }
                if (index == nowIndex + 1) {
                    $item.eq(index).addClass('next');
                }
                if (index == nowIndex - 1) {
                    $item.eq(index).addClass('prev');
                }
            });
        }
    };
})(jQuery);

spawns = [
    'garagem01',
    'aeroporto',
    'hospital01',
    'metro',
    'garagem02',
    'garagem03',
    'hospitaln',
    'localiza'
]

function milhar(n) {
    var n = '' + n,
        t = n.length - 1,
        novo = '';

    for (var i = t, a = 1; i >= 0; i--, a++) {
        var ponto = a % 3 == 0 && i > 0 ? '.' : '';
        novo = ponto + n.charAt(i) + novo;
    }
    return novo;
}

$(document).ready(() => {
    window.addEventListener('message', function(event) {
        var item = event.data;
        $(".bank").html(milhar(item.bank));
        $(".time").html(converter(item.tempoOnline));
        $(".wallet").html(milhar(item.palyer));
        $(".link").html(item.site);
        $(".qrcode").attr("src", item.qrcode);
        $(".cupomCode").html(item.cupom);
        $(".namep").html(item.namep);

        if (item.showmenu) {
            $("#app").fadeIn(1000);
        }

        if (item.hidemenu) {
            $("#app").fadeOut(200);
        }
    });

    $(".withdraw_item_login").click(() => {
        $.post("http://FD_login/ButtonClick", JSON.stringify(selectedSpawn));
    });

    $('#cascade-slider').cascadeSlider({
        itemClass: 'item_login',
        arrowClass: 'cascade-slider_arrow'
    });
})

const converter = (minutos) => {
    const horas = Math.floor(minutos/ 60);          
    const min = minutos % 60;
    const textoHoras = (`00${horas}`).slice(-2);
    
    return `${textoHoras }`;
};