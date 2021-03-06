/**
 iZ³ | Izzzio blockchain - https://izzz.io
 Candy - https://github.com/Izzzio/Candy
 Not a part of BitCoen project!
 @author: Andrey Nedobylsky (admin@twister-vl.ru)
 */


const Signable = require('./signable');
const CryptoJS = require("crypto-js");
let type = 'CandyData';

/**
 * Candy data block
 * Candy - part of Izzzio blockchain. https://github.com/Izzzio/Candy
 * @type {Signable}
 */
class CandyData extends Signable {
    /**
     *
     * @param {String} data
     */
    constructor(data) {
        super();
        this.type = type;
        this.candyData = data;
        this.generateData();
    }

    /**
     * Создаёт строку данных для подписи
     */
    generateData() {
        this.data = this.type + CryptoJS.SHA256(this.candyData);
    }


}

module.exports = CandyData;