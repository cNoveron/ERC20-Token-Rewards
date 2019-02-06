var Pedro_ERC20Token = artifacts.require("Pedro_ERC20Token")
var RewardCalculator = artifacts.require("RewardCalculator")
var PriceCalculator = artifacts.require("PriceCalculator")
var ReviewsController = artifacts.require("ReviewsController")
var Web3 = require('web3')
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"))


contract('ReviewsController', function(accounts) {
    const deployer = accounts[0]
    const requester = accounts[1]
    const offerer = accounts[2]

    const printConstant = (c) => console.log(c.toString())
    const printTxReceipt = (tx) => console.log("printTxReceipt",tx)
    const printTxReceipt_logs_topics = (tx) => tx.receipt.logs.forEach(
        (log) => console.log(
            "printTxReceipt_logs_topics\n", log.topics, "\n"
        )
    )
    const printTxLogs_args = (tx) => tx.logs.forEach(
        (log) => console.log(
            "printTxLogs_args\n", log.args, "\n"
        )
    )
    
    function printMethodTx(tx, sendOptions, funcname, param1, param2, param3) {
        console.log(
            funcname, "(" + param1, ",", param2, ",", param3, ",", JSON.stringify(sendOptions) + ") >>>\n"
        )
        printTxReceipt_logs_topics(tx)        
        printTxLogs_args(tx)
        console.log("\n")
    }

    function printState(reviewId) {
        return ReviewsController.at(
            ReviewsController.address
        ).getStateOfReviewId(
            reviewId
        ).then(
            printConstant
        )
    }

    var requestTimestamp;

    function requestServicesOn_reviewId(reviewId, sendOptions) {
        return ReviewsController.at(
            ReviewsController.address
        ).requestServices(
            reviewId,
            requestTimestamp = (new Date()).getTime(),
            [1, 2, 3],
            sendOptions
        ).then((tx) =>
            printMethodTx(tx, sendOptions, "requestServices", reviewId, requestTimestamp, "")
        )
    }

    var offerTimestamp;

    function offerServicesOn_reviewId(reviewId, sendOptions) {
        return ReviewsController.at(
            ReviewsController.address
        ).offerServices(
            reviewId,
            offerTimestamp = (new Date()).getTime(),
            100,
            sendOptions
        ).then((tx) =>
            printMethodTx(tx, sendOptions, "offerServices", reviewId, offerTimestamp, 100)
        )
    }

    function acceptOfferOn_reviewId(reviewId, sendOptions) {
        return ReviewsController.at(
            ReviewsController.address
        ).acceptOffer(
            reviewId,
            offerTimestamp = (new Date()).getTime(),
            offerer,
            sendOptions
        ).then((tx) =>
            printMethodTx(tx, sendOptions, "offerServices", reviewId, offerTimestamp, 100)
        )
    }
    
    function deployEverything() {
        return Pedro_ERC20Token.deployed(
            { from: deployer }
        ).then(function () {
            return RewardCalculator.deployed(
                { from: deployer }
            )
        }).then(function () {
            return PriceCalculator.deployed(
                10,
                { from: deployer }
            )
        }).then(function () {
            return ReviewsController.deployed(
                Pedro_ERC20Token.address,
                RewardCalculator.address,
                PriceCalculator.address,
                { from: deployer }
            )
        })
    }

    it("Should pass.", function() {
        return deployEverything(
        ).then(function () {
            return requestServicesOn_reviewId(0,{ from: requester })
        }).then(function () {
            return offerServicesOn_reviewId(0,{ from: offerer })
        })
    })

    it("Should fail.", function () {
        return deployEverything(
        ).then(function () {
            return requestServicesOn_reviewId(0, { from: requester })
        }).then(function () {
            return offerServicesOn_reviewId(0, { from: requester })
        }).catch(() => {
            throw new Error("Offering services to one's self is not allowed.")
        })
    })

    it("Should also fail.", function () {
        return deployEverything(
        ).then(function () {
            return requestServicesOn_reviewId(0, { from: requester })
        }).then(function () {
            return offerServicesOn_reviewId(0, { from: offerer })
        }).then(function () {
            return acceptOfferOn_reviewId(0, { from: offerer })
        }).catch(() => {
            throw new Error("Accepting offers on behalf of a requester is not allowed.")
        })
    })

})
