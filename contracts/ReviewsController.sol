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
    external 
        reviewId_mustHaveBeenInitialized(true, reviewId)
        msgSender_mustBeRequester(false, reviewId)
    returns(bool) 
    {
        reviewIdHas_offerCount[reviewId]++;

        uint16 providersPricePlusFee = priceCalculator.evaluate(
            reviewId,
            offerTimestamp,
            providersPrice
        );

        reviewIdKnows_offererAddressHas_OfferFromAddress
            [reviewId][msg.sender] = OfferFromAddress(
                reviewIdHas_requesterAddress[reviewId],
                    offerTimestamp, 
                providersPricePlusFee
            );

        reviewIdKnows_offerTimestampWhen_OfferAtTimestamp
            [reviewId][offerTimestamp] = OfferAtTimestamp(
                reviewIdHas_requesterAddress[reviewId],
                msg.sender,
                providersPricePlusFee
            );

        emit ServicesOffered(
            reviewId, 
            offerTimestamp, 
                    providersPricePlusFee,
                    msg.sender
        );

        return true;
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
        reviewId_mustHaveBeenInitialized(true, reviewId)
        reviewId_mustHaveBeenAccepted(false, reviewId)
    returns(bool) 
    {
        OfferFromAddress memory _offerFromAddress;        
        reviewIdHas_chosenOfferFrom1Address
            [reviewId] = (
                _offerFromAddress = reviewIdKnows_offererAddressHas_OfferFromAddress[reviewId][offererAddress]
            );

        reviewIdHas_chosenOfferAt1Timestamp
            [reviewId] = reviewIdKnows_offerTimestampWhen_OfferAtTimestamp[reviewId][_offerFromAddress.atOfferTimestamp];
        
        reviewIdHasBeen_accepted[reviewId] = true;
        
        emit OfferAccepted(
            reviewId, 
            acceptanceTimestamp, 
            msg.sender, 
            offererAddress
        );

                return true;
            }

    modifier offerCount_isAtLeast1(uint32 reviewId) 
    {
        require(reviewIdHas_offerCount[reviewId] >= 1);
        _;
        }
    modifier reviewId_mustHaveBeenAccepted(bool shouldBe, uint32 reviewId) {
        require(reviewIdHasBeen_accepted[reviewId] == shouldBe);
        _;
    }
    mapping(uint32 => bool) reviewIdHasBeen_accepted;
    mapping(uint32 => OfferFromAddress) reviewIdHas_chosenOfferFrom1Address;
    mapping(uint32 => OfferAtTimestamp) reviewIdHas_chosenOfferAt1Timestamp;




    function claimCompletion(uint32 reviewId, uint64 claimTimestamp)
    external 
        msgSender_mustBeChosenOfferer(reviewId)
        reviewId_mustHaveBeenInitialized(true, reviewId)
        reviewId_mustHaveBeenAccepted(true, reviewId)
        reviewId_mustHaveBeenCompleted(false, reviewId) 
    returns(bool) 
    {
        reviewIdWasClaimedCompleteAt_timestampWhen[reviewId] = claimTimestamp;
        
        emit CompletionClaimed(
            reviewId, 
            claimTimestamp, 
            reviewIdHas_requesterAddress[reviewId], 
            msg.sender
        );

        return reviewIdHasBeen_completed[reviewId] = true;
    }

    modifier msgSender_mustBeChosenOfferer(uint32 reviewId) 
    {
        require(msg.sender == reviewIdHas_chosenOfferAt1Timestamp[reviewId].byOffererAddress);
        _;
    }
    modifier reviewId_mustHaveBeenCompleted(bool shouldBe, uint32 reviewId) {
        require(reviewIdHasBeen_completed[reviewId] == shouldBe);
        _;
    }
    mapping (uint32 => bool) reviewIdHasBeen_completed;
    mapping(uint32 => uint64) reviewIdWasClaimedCompleteAt_timestampWhen;




    function approveCompletion(uint32 reviewId, uint64 approvalTimestamp, uint8 rank)
    external 
        msgSender_mustBeRequester(true, reviewId) 
        reviewId_mustHaveBeenInitialized(true, reviewId)
        reviewId_mustHaveBeenAccepted(true, reviewId)
        reviewId_mustHaveBeenCompleted(true, reviewId) 
        reviewId_mustHaveBeenRewarded(false, reviewId)
    returns(uint rewardAmount) 
    {
        uint finalCustomersPrice = finalCustomersPrice_from_reviewId[reviewId];
        
        rewardAmount = rewardCalculator.calculateRewardAmount(rank, finalCustomersPrice);
        
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

        reviewIdHasBeen_rewarded[reviewId] = true;
    }

    modifier reviewId_mustHaveBeenRewarded(bool shouldBe, uint32 reviewId) 
    {
        require(reviewIdHasBeen_rewarded[reviewId] == shouldBe);
        _;
    }
    mapping (uint32 => bool) reviewIdHasBeen_rewarded;
    mapping(uint32 => uint) finalCustomersPrice_from_reviewId;




    function rejectCompletion(uint32 reviewId, uint64 rejectionTimestamp)
    external 
        msgSender_mustBeRequester(true, reviewId)
        reviewId_mustHaveBeenInitialized(true, reviewId)
        reviewId_mustHaveBeenAccepted(true, reviewId)
        reviewId_mustHaveBeenCompleted(true, reviewId) 
        reviewId_mustHaveBeenRewarded(false, reviewId)
    returns(bool) 
    {
        emit CompletionRejected(reviewId, rejectionTimestamp, reviewIdHas_requesterAddress[reviewId], msg.sender);
        
        return reviewIdHasBeen_completed[reviewId] = false;
    }
}