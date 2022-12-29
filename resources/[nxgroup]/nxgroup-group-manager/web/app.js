Vue.createApp({
    data(){
        return {
            visible: false,
            page: 'home',
            data: {},
            findUser: "",
            _playerList: [],
            playerList: [],

            selectedPlayer: '',
            selectedProduct: {},

            playerPassport: '',
            donationValue: ''
        }
    },

    methods: {
        openUI(args) {
            this.visible = true;
            this.data = args[0];
            this._playerList = this.data.organization_members;
            this.playerList = this.data.organization_members;
        },

        closeUI(){
            this.visible = false;
        },

        redirect(route){
            this.page = route;
        },

        findUserByName(){
            if(this.findUser.length > 0){
                this.playerList = this._playerList.filter(el => (el.name.toLowerCase()).startsWith(this.findUser.toLowerCase()));
                return;
            }

            this.playerList = this._playerList;
        },

        async addPlayer(){
            const group = this.$refs.groupSelector.value;
            const res = await this.post("invite-member", {user_id: parseInt(this.playerPassport), group});
            if(res.success){
                this.playerPassport = '';
            }
        },

        async donateMoney(){
           const res = await this.post('donate-money', {value: parseInt(this.donationValue)});
           if(res){
                this.donationValue = '';
           }
        },

        selectPlayer(user_id){
            if(this.selectedPlayer === user_id) return this.selectedPlayer = '';
            this.selectedPlayer = user_id;
        },

        selectProduct(product,id){
            this.selectedProduct = {...product,id: id + 1};
        },

        async buyProduct(){
            const res = await this.post('buy-map',{id: this.selectedProduct.id});
            if(res){
                this.selectedProduct = {};
            }
        },

        async update(){
            const res = await this.post("updateUI");
        },

        changeFilter(filter){
            switch (filter) {
                case 'donations':
                    this.playerList = this._playerList;
                    this.playerList = this.playerList.sort((p1,p2) => p1.donated_money - p2.donated_money).reverse();
                    break;
                
                case 'online':
                    this.playerList = this._playerList;
                    this.playerList = this.playerList.filter(plr => parseInt(plr.status) === 0);
                    break;

                default:
                    break;
            }
        },

        async makeAction(action){
            const res = await this.post(action,{user_id: this.selectedPlayer});
        },

        post(endpoint, data){
            return fetch(`http://nxgroup-group-manager/${endpoint}`,{
                method: "POST",
                body: JSON.stringify(data || {}),
            }).then(( res ) => res.json());
        }
    },

    mounted(){
        window.addEventListener('message', ({data}) => {
            const [action,...args] = data;
            this[action]([...args]);
        })

        window.addEventListener('keydown', async (event) =>{
            if( event.keyCode === 27 ) {
                const res = await this.post("close",{closeServer: true});
                if(res){
                    this.visible = false;
                }
            }
        });
    }
}).mount("#app");
