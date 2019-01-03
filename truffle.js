var HDWalletProvider = require("truffle-hdwallet-provider");
var HDWalletProviderPrivkey = require("truffle-hdwallet-provider-privkey");
var MAINNET_PKs = [
    "48923e6e64021f895532f48e697f30914f451a4d871b1aab6d55eb0591929fe3"
];
var ROPSTEN_PKs = [
    "e7045217bc7f52479c6362dcc4ae18c68ccec62262600c5075d9bd11cbf1e73f", // Token Owner
    "ecb3d044595d8759dcc288b443692d6a55108039df1b5f924a04d6517d3e897b", // Requester
    "307c5cdda9e6c9df5075f931401dc6644dcb41658c60ab5f834eb5eacf9aae55"  // Offerer
];
require('dotenv').config();

module.exports = {
    migrations_directory: "./migrations",
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*",
            from: "0xC7e76e5f1D33BE441E890a7F2aCE9468f40345C7",
            gas: 21000000,
            gasPrice: 6
        },
        mainnet: {
            provider: function() {
                return new HDWalletProviderPrivkey(
                    MAINNET_PKs, 
                    "https://mainnet.infura.io/eQMiMPMRRHoldZ7uH7U9"
                )
            },
            network_id: 1/* ,
            gas: 21000000,
            gasPrice: 6 */
        },
        ropsten: {
            provider: function() {
                return new HDWalletProvider(
                    "help later flight bench attack cinnamon news ship only ask elbow talk",
                    "https://ropsten.infura.io/eQMiMPMRRHoldZ7uH7U9", 0, 3, "m/44'/60'/0'/0/0"
                )
                /* return new HDWalletProviderPrivkey(
                    ROPSTEN_PKs,
                    "https://mainnet.infura.io/eQMiMPMRRHoldZ7uH7U9"
                ) */
            },
            network_id: 3/* ,
            gas: 21000000,
            gasPrice: 6 */
        } 
    },
    solc: {
        optimizer: {
            enabled: true,
            runs: 500
        }
    } 
};
