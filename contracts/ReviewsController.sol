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
        reviewId_isInState(state.UNEXISTENT, reviewId)
    returns(uint8) 
    {
        reviewIdHas_services[reviewId] = serviceIdArray;
        reviewIdHas_requesterAddress[reviewId] = msg.sender;

        emit ServiceRequested(
            reviewId, 
            requestTimestamp, 
            serviceIdArray, 
            msg.sender
        );

        return uint8(reviewIdIn_state[reviewId] = state.AWATING_DEAL);
    }

    modifier reviewId_isInState(state shouldBe, uint32 reviewId) 
    {
        require(reviewIdIn_state[reviewId] == shouldBe);
        _;
    }
    enum state{
        UNEXISTENT,
        AWATING_DEAL,
        STARTED,
        AWAITING_APPROVAL,
        COMPLETE
    }
    mapping(uint32 => uint32[]) reviewIdHas_services;
    mapping(uint32 => address)  reviewIdHas_requesterAddress;




    function offerServices(uint32 reviewId, uint64 offerTimestamp, uint16 providersPrice) 
    external 
        msgSender_mustBeRequester(false, reviewId)
        reviewId_isInState(state.AWATING_DEAL, reviewId)
    returns(uint8) 
    {
        reviewIdHas_offerCount[reviewId]++;

        uint16 providersPricePlusFee = priceCalculator.evaluate(
            offerTimestamp,
            providersPrice
        );
        
        address requesterAddress = reviewIdHas_requesterAddress[reviewId];

        reviewIdKnows_offererAddressHas_OfferFromAddress
            [reviewId][msg.sender] = OfferFromAddress(
                requesterAddress,
                offerTimestamp,
                providersPricePlusFee
            );

        reviewIdKnows_offerTimestampWhen_OfferAtTimestamp
            [reviewId][offerTimestamp] = OfferAtTimestamp(
                requesterAddress,
                msg.sender,
                providersPricePlusFee
            );

        emit ServicesOffered(
            reviewId, 
            offerTimestamp, 
            providersPricePlusFee, 
            msg.sender
        );
        
        return uint8(state.AWATING_DEAL);
    }

    modifier msgSender_mustBeRequester(bool shouldBe, uint32 reviewId) 
    {
        bool msgSender_isRequester = msg.sender == reviewIdHas_requesterAddress[reviewId];
        require(
            msgSender_isRequester && shouldBe   ||
            ! msgSender_isRequester && ! shouldBe
        );
        _;
    }
    mapping(uint32 => uint8) reviewIdHas_offerCount;
    mapping(uint32 => mapping(address => OfferFromAddress)) reviewIdKnows_offererAddressHas_OfferFromAddress;
    mapping(uint32 => mapping(uint64 => OfferAtTimestamp))  reviewIdKnows_offerTimestampWhen_OfferAtTimestamp;
    struct OfferFromAddress 
    {
        address requesterAddress;
        uint64 atOfferTimestamp;
        uint16 forPriceOf;
    }
    struct OfferAtTimestamp 
    {
        address requesterAddress;
        address byOffererAddress;
        uint16 forPriceOf;
    }




    function acceptOffer(uint32 reviewId, uint64 acceptanceTimestamp, address offererAddress)
    external
        offerCount_isAtLeast1(reviewId)
        msgSender_mustBeRequester(true, reviewId)
        reviewId_isInState(state.AWATING_DEAL, reviewId)
    returns(uint8)
    {

        OfferFromAddress memory _offerFromAddress;
        reviewIdHas_chosenOfferFrom1Address
            [reviewId] = (
                _offerFromAddress = reviewIdKnows_offererAddressHas_OfferFromAddress[reviewId][offererAddress]
            );

        reviewIdHas_chosenOfferAt1Timestamp
            [reviewId] = reviewIdKnows_offerTimestampWhen_OfferAtTimestamp[reviewId][_offerFromAddress.atOfferTimestamp];
        
        emit OfferAccepted(
            reviewId, 
            acceptanceTimestamp, 
            msg.sender, 
            offererAddress
        );

        return uint8(reviewIdIn_state[reviewId] = state.STARTED);
    }

    modifier offerCount_isAtLeast1(uint32 reviewId) 
    {
        require(reviewIdHas_offerCount[reviewId] >= 1);
        _;
    }
    mapping(uint32 => OfferFromAddress) reviewIdHas_chosenOfferFrom1Address;
    mapping(uint32 => OfferAtTimestamp) reviewIdHas_chosenOfferAt1Timestamp;




    function claimCompletion(uint32 reviewId, uint64 claimTimestamp)
    external 
        msgSender_mustBeChosenOfferer(reviewId)
        reviewId_isInState(state.STARTED, reviewId)
    returns(uint8) 
    {
        reviewIdWasClaimedCompleteAt_timestampWhen[reviewId] = claimTimestamp;
        
        emit CompletionClaimed(
            reviewId, 
            claimTimestamp, 
            reviewIdHas_requesterAddress[reviewId], 
            msg.sender
        );

        return uint8(reviewIdIn_state[reviewId] = state.AWAITING_APPROVAL);
    }

    modifier msgSender_mustBeChosenOfferer(uint32 reviewId) 
    {
        require(msg.sender == reviewIdHas_chosenOfferAt1Timestamp[reviewId].byOffererAddress);
        _;
    }
    mapping(uint32 => uint64) reviewIdWasClaimedCompleteAt_timestampWhen;




    function approveCompletion(uint32 reviewId, uint64 approvalTimestamp, uint8 rank)
    external 
        msgSender_mustBeRequester(true, reviewId) 
        reviewId_isInState(state.AWAITING_APPROVAL, reviewId)
    returns(uint rewardAmount) 
    {
        uint price = reviewIdSoldAt_price[reviewId];
        uint64 offerTimestamp = reviewIdHas_chosenOfferFrom1Address[reviewId].atOfferTimestamp;
        
        rewardAmount = rewardCalculator.calculateRewardAmount(rank, price);
        
        address offererAddress = reviewIdHas_chosenOfferAt1Timestamp[reviewId].byOffererAddress;

        pedro_ERC20Token.transfer(
            offererAddress,
            rewardAmount
        );

        emit CompletionApproved(
            reviewId, 
            approvalTimestamp, 
            msg.sender, 
            offererAddress
        );

        return uint8(reviewIdIn_state[reviewId] = state.COMPLETE);
    }

    mapping(uint32 => uint32) reviewIdSoldAt_price;




    function rejectCompletion(uint32 reviewId, uint64 rejectionTimestamp)
    external 
        msgSender_mustBeRequester(true, reviewId)
        reviewId_isInState(state.AWAITING_APPROVAL, reviewId)
    returns(uint8) 
    {
        emit CompletionRejected(
            reviewId, 
            rejectionTimestamp, 
            reviewIdHas_requesterAddress[reviewId], 
            msg.sender
        );
        
        return uint8(reviewIdIn_state[reviewId] = state.AWAITING_APPROVAL);
    }
}