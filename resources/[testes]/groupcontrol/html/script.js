var app = new Vue({
    el: '.gerenciador-wrapper',
    data: {
        page: 0,
        invite_id: 0, 
        invite_groupname: '',
        promote_groupname: '',
        show: false,
        group_stats: {},
        promove_member: false,
        demote_member: false,
        selected_user: {},
        background: '',
        invite_id: '',
        invite_groupname: '',
    },
    methods: {
        post(local,data) {
            $.post('https://groupcontrol/'+local,JSON.stringify(data))
        },
        promove(user) {
            this.demote_member = false
            this.promove_member = true
            this.selected_user = { name: user.name, id: user.id, group: user.group, login: user.login, donates: user.donates }
        },
        remove(user) {
            this.promove_member = false
            this.demote_member = true
            this.selected_user = { name: user.name, id: user.id, group: user.group, login: user.login, donates: user.donates }
        },
        promoteMember() {
            $.post('https://groupcontrol/promote',JSON.stringify({ "dados": this.selected_user, "newgroup": this.promote_groupname }), data => {
                this.group_stats.members_list = data
            })
            this.closePopup()
        },
        
        demoteMember() {
            $.post('https://groupcontrol/demote',JSON.stringify({ "id": this.selected_user.id }), data => {
                this.group_stats.members_list = data
            })
            this.closePopup()
        },
        openShop() {
            $('.userlist').css('display', 'none'); $('.lojaextras').css('display', 'block'); $('.gerenciar-aba').removeClass('gerenciar-aba'); $('.loja-aba').addClass('gerenciar-aba')
        },
        closePopup() {
            this.promove_member = false
            this.demote_member = false
        },
        invite() {
            $.post('https://groupcontrol/invite',JSON.stringify({ "id": this.invite_id, "group": this.invite_groupname }))
        },
        comprarlevel() {
            $.post('https://groupcontrol/comprarlevel',JSON.stringify({ "id": this.selected_user, "group": this.invite_groupname }), data => {
                this.group_stats.members_list = data
            })
            this.closePopup()
        },
        close() {
            this.show = false
            this.post('close')
        }
        
    },
    created() {
        window.addEventListener("message", event => {
            let data = event.data;
            if (data.update) {
                this.group_stats = data.group_stats
            } else {
                this.show = data.show;
                this.group_stats = data.group_stats
                this.background = data.group_stats.name
            }
        })
        document.addEventListener('keydown', (event) => {
            if (event.key == "Escape") {
                this.close()
            }
        })
    }
})