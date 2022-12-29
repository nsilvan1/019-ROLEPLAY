Vue.createApp({
    data() {
        return {
            showing: false,
            categories: [
                { name: "Rosto", id: "face" },
                { name: "Cabelo", id: "hair" },
                { name: "Barba", id: "beard" },
                { name: "Make", id: "make" }
            ],
            charData: [
                { optionName: "Cor dos Olhos", optionId: "eyesColor", category: 'face', min: 0, max: 32, step: 1 },
                { optionName: "Altura Sombrancelhas", optionId: "eyebrowsHeight", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Tamanho Sombrancelhas", optionId: "eyebrowsWidth", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Tamanho Nariz", optionId: "noseWidth", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Altura Nariz", optionId: "noseHeight", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Cor de Pele", optionId: "skinColor", category: 'face', min: 0, max: 44, step: 1 },
                { optionName: "Largura Nariz", optionId: "noseLength", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Ponte Nasal", optionId: "noseBridge", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Ponta do Nariz", optionId: "noseTip", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Altura Bochechas", optionId: "cheekboneHeight", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Largura Bochechas", optionId: "cheekboneWidth", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Tamanho Bochechas", optionId: "cheeksWidth", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Lábios", optionId: "lips", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Largura Mandíbula", optionId: "jawWidth", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Altura Mandíbula", optionId: "jawHeight", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Largura Queixo", optionId: "chinLength", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Posição Queixo", optionId: "chinPosition", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Tamanho Queixo", optionId: "chinWidth", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Forma do Queixo", optionId: "chinShape", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Largura Pescoço", optionId: "neckWidth", category: 'face', min: -1.0, max: 0.99, step: 0.01 },
                { optionName: "Cabelo", optionId: "hairModel", category: 'hair', min: 0, max: 1, step: 1 },
                { optionName: "Cor Primária Cabelo", optionId: "firstHairColor", category: 'hair', min: 0, max: 63, step: 1 },
                { optionName: "Cor Secundária Cabelo", optionId: "secondHairColor", category: 'hair', min: 0, max: 63, step: 1 },
                { optionName: "Sobrancelha", optionId: "eyebrowsModel", category: 'hair', min: 0, max: 1, step: 1 },
                { optionName: "Cor das Sobrancelhas", optionId: "eyebrowsColor", category: 'hair', min: 0, max: 63, step: 1 },
                { optionName: "Barba", optionId: "beardModel", category: 'beard', min: 0, max: 1, step: 1 },
                { optionName: "Cor da Barba", optionId: "beardColor", category: 'beard', min: 0, max: 63, step: 1 },
                { optionName: "Blush", optionId: "blushModel", category: 'make', min: -1, max: 1, step: 1 },
                { optionName: "Cor do Blush", optionId: "blushColor", category: 'make', min: 0, max: 63, step: 1 },
                { optionName: "Pelo Corporal", optionId: "chestModel", category: 'beard', min: -1, max: 1, step: 1 },
                { optionName: "Cor do Pelo Corporal", optionId: "chestColor", category: 'beard', min: 0, max: 63, step: 1 },
                { optionName: "Batom", optionId: "lipstickModel", category: 'make', min: -1, max: 1, step: 1 },
                { optionName: "Cor do Batom", optionId: "lipstickColor", category: 'make', min: 0, max: 63, step: 1 },
                { optionName: "Manchas", optionId: "blemishesModel", category: 'make', min: -1, max: 1, step: 1 },
                { optionName: "Envelhecimento", optionId: "ageingModel", category: 'make', min: -1, max: 1, step: 1 },
                { optionName: "Aspecto", optionId: "complexionModel", category: 'make', min: -1, max: 1, step: 1 },
                { optionName: "Pele", optionId: "sundamageModel", category: 'make', min: -1, max: 1, step: 1 },
                { optionName: "Sardas", optionId: "frecklesModel", category: 'make', min: -1, max: 1, step: 1 },
                { optionName: "Maquiagem", optionId: "makeupModel", category: 'make', min: -1, max: 1, step: 1 },
            ],

            data: {
                selectedSex: 'masculine',
                charName: '',
                charLastname: '',
                charAge: 18,
                selectedParents: {
                    father: 0,
                    mother: 0
                },

                parentsList: {  
                    father: [
                        { 'name': 'Benjamin', id: 0 },
                        { 'name': 'Daniel', id: 1 },
                        { 'name': 'Joshua', id: 2 },
                        { 'name': 'Noah', id: 3 },
                        { 'name': 'Andrew', id: 4 },
                        { 'name': 'Juan', id: 5 },
                        { 'name': 'Alex', id: 6 },
                        { 'name': 'Isaac', id: 7 },
                        { 'name': 'Evan', id: 8 },
                        { 'name': 'Ethan', id: 9 },
                        { 'name': 'Vincent', id: 10 },
                        { 'name': 'Angel', id: 11 },
                        { 'name': 'Diego', id: 12 },
                        { 'name': 'Adrian', id: 13 },
                        { 'name': 'Gabriel', id: 14 },
                        { 'name': 'Michael', id: 15 },
                        { 'name': 'Santiago', id: 16 },
                        { 'name': 'Kevin', id: 17 },
                        { 'name': 'Louis', id: 18 },
                        { 'name': 'Samuel', id: 19 },
                        { 'name': 'Anthony', id: 20 },
                        { 'name': 'John', id: 42 },
                        { 'name': 'Niko', id: 43 },
                        { 'name': 'Claude', id: 44 },
                    ],
                    mother: [
                        { 'name': 'Hannah', id: 21 },
                        { 'name': 'Audrey', id: 22 },
                        { 'name': 'Jasmine', id: 23 },
                        { 'name': 'Giselle', id: 24 },
                        { 'name': 'Amelia', id: 25 },
                        { 'name': 'Isabella', id: 26 },
                        { 'name': 'Zoe', id: 27 },
                        { 'name': 'Ava', id: 28 },
                        { 'name': 'Camila', id: 29 },
                        { 'name': 'Violet', id: 30 },
                        { 'name': 'Sophia', id: 31 },
                        { 'name': 'Evelyn', id: 32 },
                        { 'name': 'Nicole', id: 33 },
                        { 'name': 'Ashley', id: 34 },
                        { 'name': 'Grace', id: 35 },
                        { 'name': 'Brianna', id: 36 },
                        { 'name': 'Natalie', id: 37 },
                        { 'name': 'Olivia', id: 38 },
                        { 'name': 'Elizabeth', id: 39 },
                        { 'name': 'Charlotte', id: 40 },
                        { 'name': 'Emma', id: 41 },
                        { 'name': 'Misty', id: 45 },
                    ]
                }
            },
            parentValue: '0.5',
            selectedCategory: 'face'
        }
    },

    computed: {
        charCategories() {
            const filter = this.charData.filter(el => el.category === this.selectedCategory)
            return filter;
        }
    },

    methods: {
        GET_MESSAGES({ data }) {
            const [action, ...args] = data;
            this[action]([...args]);
        },

        manageVisibility([status]) {
            if (status) {
                (async () => {
                    const res = await this.post("getGenderData");
                    var value = 0;
                    for (let index = 0; index < this.charData.length; index++) {
                        const item = this.charData[index];
                        if (res[value].optionId === item.optionId) {
                            this.charData[index] = res[value];
                            value++;
                        }
                    }
                    // this.charData = [...res,...this.charData];
                })()
            }
            this.showing = status;
        },

        async downParent(parent) {
            if (this.data.selectedParents[parent] <= 0) return;
            this.data.selectedParents[parent]--;
            await this.post('UpdateSkinOptions', {
                fathersID: this.data.parentsList['father'][this.data.selectedParents.father].id,
                mothersID: this.data.parentsList['mother'][this.data.selectedParents.mother].id
            })
        },

        async upParent(parent) {
            if (this.data.selectedParents[parent] == this.data.parentsList[parent].length - 1) return;
            this.data.selectedParents[parent]++;
            await this.post('UpdateSkinOptions', {
                fathersID: this.data.parentsList['father'][this.data.selectedParents.father].id,
                mothersID: this.data.parentsList['mother'][this.data.selectedParents.mother].id
            })

        },

        upAge() {
            if (this.data.charAge < 90) {
                this.data.charAge++;
            }
        },

        downAge() {
            if (this.data.charAge > 18) {
                this.data.charAge--;
            }
        },

        async changeCharParents(value) {
            this.post('UpdateSkinOptions', { shapeMix: value })
        },

        async changeGenreTo(genre) {
            await this.post("ChangeGender", { gender: genre === 'masculine' ? 0 : 1 });
            this.data.selectedSex = genre;
        },

        inputChange(e, optionId) {
            const value = Number.isInteger(e.target.value) ? parseInt(e.target.value) : parseFloat(e.target.value);
            if (optionId == "rotation") return this.post("cChangeHeading", { camRotation: value });
            this.charData[this.charData.findIndex(item => item.optionId === optionId)].value = value;
            switch (this.selectedCategory) {
                case "face":
                    if (optionId === 'skinColor') this.post("UpdateSkinOptions", { skinColor: value });
                    this.post("UpdateFaceOptions", { [`${optionId}`]: value })
                    break;
                case "face":
                    if (optionId === 'skinColor2') this.post("UpdateSkinOptions", { skinColor2: value });
                    this.post("UpdateFaceOptions", { [`${optionId}`]: value })
                    break;
                case "hair":
                    this.post("UpdateHeadOptions", { [`${optionId}`]: value })
                    break;
                case "beard":
                    this.post("UpdateBeardOptions", { [`${optionId}`]: value })
                    break;
                case "make":
                    this.post("UpdateMakeOptions", { [`${optionId}`]: value })
                    break;
                default:
                    break;
            }
        },

        async saveChar() {
            if (this.data.charName.trim() !== "" && this.data.charLastname.trim() !== "") {
                await this.post("cDoneSave", { name: this.data.charName.split(' ')[0], lastName: this.data.charLastname.split(' ')[0], age: this.data.charAge });
            }
        },

        post(endpoint, data) {
            return fetch(`http://nxgroup-character/${endpoint}`, {
                method: "POST",
                body: JSON.stringify(data || {}),
            }).then((res) => res.json());
        }
    },

    mounted() {
        window.addEventListener('message', this.GET_MESSAGES);
        window.addEventListener('keydown', async (event) => {
            if (event.keyCode === 27) {
                await this.post("onClose");
                this.showing = false;
            }
        });
    },

    destroyed() {
        window.removeEventListener(this.GET_MESSAGES);
    }
}).mount("#app");