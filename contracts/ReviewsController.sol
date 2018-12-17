// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./IServiceStateController.sol";
import "./RewardCalculator.sol";
import "./Pedro_ERC20Token.sol";
import "./PriceCalculator.sol";

contract ReviewsController is IServiceStateController {
    
    Pedro_ERC20Token pedro_ERC20Token;
    address currentPedro_ERC20Token;

    RewardCalculator rewardCalculator;
    address currentRewardCalculator;

    PriceCalculator priceCalculator;
    address currentPriceCalculator;
    
    constructor(
        address pedro_ERC20TokenAddress,
        address rewardCalculatorAddress,
        address priceCalculatorAddress
    ) 
    public 
    {
        currentPedro_ERC20Token = pedro_ERC20TokenAddress;
        pedro_ERC20Token = Pedro_ERC20Token(currentPedro_ERC20Token);

        currentRewardCalculator = rewardCalculatorAddress;
        rewardCalculator = RewardCalculator(currentRewardCalculator);

        currentPriceCalculator = priceCalculatorAddress;
        priceCalculator = PriceCalculator(currentPriceCalculator);
    }


    function setCurrentPedro_ERC20TokenAddress(address Pedro_ERC20TokenAddress) 
    external 
    {
        currentPedro_ERC20Token = Pedro_ERC20TokenAddress;
        pedro_ERC20Token = Pedro_ERC20Token(currentPedro_ERC20Token);
    }


    function setCurrentRewardCalculatorAddress(address RewardCalculatorAddress) 
    external 
    {
        currentRewardCalculator = RewardCalculatorAddress;
        rewardCalculator = RewardCalculator(currentRewardCalculator);
    }


    function setCurrentPriceCalculatorAddress(address PriceCalculatorAddress) 
    external 
    {
        currentPriceCalculator = PriceCalculatorAddress;
        priceCalculator = PriceCalculator(currentPriceCalculator);
    }


    function requestServices(uint32 reviewId, uint64 requestTimestamp, uint32[] serviceIdArray)  
    external 
        reviewId_mustHaveBeenInitialized(false, reviewId) 
    returns(bool) 
    {
        reviewIdHasBeen_initialized     [reviewId] = true;
        reviewIdHas_services            [reviewId] = serviceIdArray;
        reviewIdHas_requesterAddress    [reviewId] = msg.sender;

        emit ServiceRequested(
            reviewId, 
            requestTimestamp, 
            serviceIdArray, 
            msg.sender
        );

        return true;
    }

    modifier reviewId_mustHaveBeenInitialized(bool shouldBe, uint32 reviewId) 
    {
        require(reviewIdHasBeen_initialized[reviewId] == shouldBe);
        _;
    }
    mapping(uint32 => bool)     reviewIdHasBeen_initialized;
    mapping(uint32 => uint32[]) reviewIdHas_services;
    mapping(uint32 => address)  reviewIdHas_requesterAddress;




    function offerServices(uint32 reviewId, uint64 offerTimestamp, uint16 providersPrice) 
    external validate_reviewId(true, reviewId) returns(bool) {
        uint16 providersPricePlusFee = priceCalculator.evaluate(
            reviewId, offerTimestamp, providersPrice
        );
        get_offerTimestampCount_from_reviewId[reviewId] = uint8(
            get_TimestampsAndPricesForServices_from_reviewId[reviewId].push(
                TimestampAndPriceForServices(
                    offerTimestamp, 
                    providersPricePlusFee,
                    msg.sender
                )
            )
        );
        emit ServiceOffered(reviewId, offerTimestamp, providersPricePlusFee, msg.sender);
        return true;
    }

    mapping(uint32 => uint8) get_offerTimestampCount_from_reviewId;
    mapping(uint32 => TimestampAndPriceForServices[]) get_TimestampsAndPricesForServices_from_reviewId;
    struct TimestampAndPriceForServices {
        uint64 offerTimestamp;
        uint16 finalPrice;
        address offererEthAddress;
    }

    function acceptOffer(uint32 reviewId, uint64 acceptanceTimestamp, address offererEthAddress)
    external validate_reviewId(true, reviewId) returns(bool) {
        uint8 offerTimestampCount = get_offerTimestampCount_from_reviewId[reviewId];
        for(uint8 i = 0; i < offerTimestampCount; i++) {
            TimestampAndPriceForServices 
            timestampAndPriceForServices = get_TimestampsAndPricesForServices_from_reviewId[reviewId][i];
            if(timestampAndPriceForServices.offererEthAddress == offererEthAddress) {
                get_selectedTimestampAndPriceForServices_from_reviewId[reviewId] = timestampAndPriceForServices;
                emit OfferAccepted(reviewId, acceptanceTimestamp, msg.sender, offererEthAddress);
                return true;
            }
        }
        return false;
    }
    mapping(uint32 => TimestampAndPriceForServices) get_selectedTimestampAndPriceForServices_from_reviewId;

    function claimCompletion(uint32 reviewId, uint64 claimTimestamp)
    external validate_reviewId(true, reviewId) returns(bool) {
        emit CompletionClaimed(reviewId, claimTimestamp, get_requesterEthAddress_from_reviewId[reviewId], msg.sender);
        return is_reviewIdClaimedComplete[reviewId] = true;
    }

    mapping (uint32 => bool) is_reviewIdClaimedComplete;

    function approveCompletion(uint32 reviewId, uint64 approvalTimestamp, uint8 rank)
    external validate_reviewId(true, reviewId) returns(uint rewardAmount) {
        uint finalCustomersPrice = get_finalCustomersPrice_from_reviewId[reviewId];
        rewardAmount = rewardCalculator.calculateRewardAmount(rank, finalCustomersPrice);
    }

    mapping(uint32 => uint) get_finalCustomersPrice_from_reviewId;

    function rejectCompletion(uint32 reviewId, uint64 rejectionTimestamp)
    external validate_reviewId(true, reviewId) returns(bool) {
        emit CompletionRejected(reviewId, rejectionTimestamp, get_requesterEthAddress_from_reviewId[reviewId], msg.sender);
        return is_reviewIdClaimedComplete[reviewId] = false;
    }
}