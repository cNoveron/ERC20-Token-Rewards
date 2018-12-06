// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./IServiceStateController.sol";
import "./RewardCalculator.sol";
import "./PEDRO_ERC20Token.sol";

contract ReviewsController is IServiceStateController {
    
    RewardCalculator rewardCalculator;
    address currentRewardCalculator;

    PEDRO_ERC20Token PEDRO_ERC20Token;
    address currentPEDRO_ERC20Token;
    
    constructor(address RewardCalculatorAddress, address PEDRO_ERC20TokenAddress) 
    public {
        currentRewardCalculator = RewardCalculatorAddress;
        rewardCalculator = RewardCalculator(currentRewardCalculator);

        currentPEDRO_ERC20Token = PEDRO_ERC20TokenAddress;
        PEDRO_ERC20Token = PEDRO_ERC20Token(currentPEDRO_ERC20Token);
    }

    function setCurrentRewardCalculatorAddress(address RewardCalculatorAddress) 
    external {
        currentRewardCalculator = RewardCalculatorAddress;
        rewardCalculator = RewardCalculator(currentRewardCalculator);
    }

    function setCurrentPEDRO_ERC20TokenAddress(address PEDRO_ERC20TokenAddress) 
    external {
        currentPEDRO_ERC20Token = PEDRO_ERC20TokenAddress;
        PEDRO_ERC20Token = PEDRO_ERC20Token(currentPEDRO_ERC20Token);
    }

    function requestServices(uint32 reviewId, uint64 requestTimestamp, uint32[] serviceIdArray)  
    external returns (bool) {
        if(is_reviewId_active[reviewId] == false) {
            is_reviewId_active[reviewId] = true;
            get_serviceIdArray_from_reviewId[reviewId] = serviceIdArray;
            emit ServiceRequested(reviewId, requestTimestamp, serviceIdArray, msg.sender);
            return true;
        }
        return false;
    }

    mapping(uint32 => bool) is_reviewId_active;
    mapping(uint32 => uint32[]) get_serviceIdArray_from_reviewId;

    modifier validate_reviewId(uint32 reviewId) {
        require(is_reviewId_active[reviewId] == true);
        _;
    }

    function offerServices(uint32 reviewId, uint64 offerTimestamp, uint16 price) 
    external returns (bool){
        return;
    }

    function acceptOffer(uint32 reviewId, uint64 acceptanceTimestamp, address offererEthAddress)
    external returns (bool){
        return;
    }

    event ServiceAccepted(
        bytes32 indexed serviceRequestId,
        address indexed offeredBy,
        address indexed acceptedBy,
        string  serviceName
    );

    function claimCompletion(uint32 reviewId, uint64 claimTimestamp)
    external returns (bool){

    }

    event CompletionClaimed(
        bytes32 indexed serviceRequestId,
        address indexed claimedCompleteBy,
        string  serviceName
    );

    function approveCompletion(uint32 reviewId, uint64 approvalTimestamp, uint8 rank, uint64 serviceCost)
    external validate_reviewId(reviewId) returns (uint rewardAmount) {
        rewardAmount = rewardCalculator.calculateRewardAmount(rank, serviceCost);
        
    }

    event CompletionApproved(
        bytes32 indexed serviceRequestId,
        address indexed approvedAsCompleteBy,
        string  serviceName
    );

    function rejectCompletion(uint32 reviewId, uint64 callTimestamp)
    external returns (bool){

    }

    event CompletionRejected(
        bytes32 indexed serviceRequestId,
        address indexed rejectedAsCompleteBy,
        string  serviceName
    );
}