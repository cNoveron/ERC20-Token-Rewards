// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./IServiceStateController.sol";
import "./RewardCalculator.sol";
import "./Pedro_ERC20Token.sol";
import "./PriceCalculator.sol";

contract ReviewsController is IServiceStateController {
    
    RewardCalculator rewardCalculator;
    address currentRewardCalculator;

    Pedro_ERC20Token pedro_ERC20Token;
    address currentPedro_ERC20Token;
    
    PriceCalculator priceCalculator;
    address currentPriceCalculator;
    
    constructor(
        address RewardCalculatorAddress,
        address Pedro_ERC20TokenAddress,
        address priceCalculatorAddress
    ) 
    public {
        currentRewardCalculator = RewardCalculatorAddress;
        rewardCalculator = RewardCalculator(currentRewardCalculator);

        currentPedro_ERC20Token = Pedro_ERC20TokenAddress;
        pedro_ERC20Token = Pedro_ERC20Token(currentPedro_ERC20Token);

        currentPriceCalculator = priceCalculatorAddress;
        priceCalculator = PriceCalculator(currentPriceCalculator);
    }

    function setCurrentRewardCalculatorAddress(address RewardCalculatorAddress) 
    external {
        currentRewardCalculator = RewardCalculatorAddress;
        rewardCalculator = RewardCalculator(currentRewardCalculator);
    }

    function setCurrentPedro_ERC20TokenAddress(address Pedro_ERC20TokenAddress) 
    external {
        currentPedro_ERC20Token = Pedro_ERC20TokenAddress;
        pedro_ERC20Token = Pedro_ERC20Token(currentPedro_ERC20Token);
    }

    function setCurrentPriceCalculatorAddress(address PriceCalculatorAddress) 
    external {
        currentPriceCalculator = PriceCalculatorAddress;
        priceCalculator = PriceCalculator(currentPriceCalculator);
    }

    function requestServices(uint32 reviewId, uint64 requestTimestamp, uint32[] serviceIdArray)  
    external validate_reviewId(false, reviewId) returns(bool) {
        is_reviewId_active[reviewId] = true;
        get_serviceIdArray_from_reviewId[reviewId] = serviceIdArray;
        emit ServiceRequested(reviewId, requestTimestamp, serviceIdArray, msg.sender);
        return true;
    }

    modifier validate_reviewId(bool shouldBe, uint32 reviewId) {
        require(is_reviewId_active[reviewId] == shouldBe);
        _;
    }

    mapping(uint32 => bool) is_reviewId_active;
    mapping(uint32 => uint32[]) get_serviceIdArray_from_reviewId;

    function offerServices(uint32 reviewId, uint64 offerTimestamp, uint16 providersPrice) 
    external validate_reviewId(true, reviewId) returns(bool) {
        uint16 providersPricePlusFee = priceCalculator.evaluate(
            reviewId, offerTimestamp, providersPrice
        );
        get_offerTimestampCount_from_reviewId[reviewId] = uint8(
            get_timestampsAndPricesForServices_from_reviewId[reviewId].push(
                timestampAndPriceForServices(
                    offerTimestamp, 
                    providersPricePlusFee, 
                    get_serviceIdArray_from_reviewId[reviewId]
            )
            )
        );
        emit ServiceOffered(reviewId, offerTimestamp, providersPricePlusFee, msg.sender);
        return true;
    }

    mapping(uint32 => uint8) get_offerTimestampCount_from_reviewId;
    mapping(uint32 => timestampAndPriceForServices[]) get_timestampsAndPricesForServices_from_reviewId;
    struct timestampAndPriceForServices {
        uint64 offerTimestamp;
        uint16 finalPrice;
        uint32[] serviceIdArray;
    }

    function acceptOffer(uint32 reviewId, uint64 acceptanceTimestamp, address offererEthAddress)
    external validate_reviewId(true, reviewId) returns(bool) {
        uint8 offerTimestampCount = get_offerTimestampCount_from_reviewId[reviewId];
        for(uint8 i=0; i<offerTimestampCount; i++) {
            address offererAddress = get_timestampsAndPricesForServices_from_reviewId[reviewId][i].offererEthAddress;
            if(offererAddress == offererEthAddress) {
                get_selectedTimestampAndPriceForServices_from_reviewId[reviewId] = 
                    get_timestampsAndPricesForServices_from_reviewId[reviewId][i];
                break;
            }
        }
        return true;
    }

    function claimCompletion(uint32 reviewId, uint64 claimTimestamp)
    external validate_reviewId(true, reviewId) returns(bool) {

    }

    function approveCompletion(uint32 reviewId, uint64 approvalTimestamp, uint8 rank)
    external validate_reviewId(true, reviewId) returns(uint rewardAmount) {
        uint finalCustomersPrice = get_finalCustomersPrice_from_reviewId[reviewId];
        rewardAmount = rewardCalculator.calculateRewardAmount(rank, finalCustomersPrice);
    }

    mapping (uint32 => uint) get_finalCustomersPrice_from_reviewId;

    function rejectCompletion(uint32 reviewId, uint64 callTimestamp)
    external validate_reviewId(true, reviewId) returns (bool) {

    }
}