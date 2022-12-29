Vue.createApp({
    data: function (){
        return {
            opened: false,
            id: null,
            status: 0,
            notifys: []
        }
    },
    methods: {
        post: function (name, body) {
            if(navigator.onLine) {
                fetch(`http://${window.GetParentResourceName()}/${name}`,{
                    method: "POST",
                    body: JSON.stringify(body || {})
                });
                return;
            }
        },
        copyValue: function (index) {
            this.$refs.id.select();
            document.execCommand("copy");
            this.notify(`ID ${this.id} COPIADO COM SUCESSO!`);
        },
        notify: function (message) {
            this.notifys.push({
                message: message
            });
            const time = setTimeout(() => {
                this.notifys.shift();
                clearInterval(time);
            }, 5000);
        },
        redirect: function () {
            window.invokeNative('openUrl', 'https://discord.gg/cidadethunder')
        },
        close: function () {
            if (this.status === 0) return;
            this.opened = false;
            this.post('close');
        }
    },
    mounted: function () {
        window.addEventListener('message', ({ data }) => {
            if (data.action === 'open') this.opened = true, this.id = data.id, this.status = data.status;
            if (data.action === 'close' && data.status > 0) this.status = data.status, this.close();
        });

        window.addEventListener('keydown', (e) =>{
            if (this.status === 0 && e.keyCode === 27) return this.notify('SUA WL AINDA NÃO FOI LIBERADA!');
            if (e.keyCode === 27) return this.close();
        });
    }
}).mount("#app");