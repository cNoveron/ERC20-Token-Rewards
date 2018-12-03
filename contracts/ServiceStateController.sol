// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./IServiceStateController.sol";

contract ServiceStateController is IServiceStateController {
    
    function request(uint32 reviewId, uint32 callTimestamp, uint32[] serviceIdArray) 
    external returns (bool) {
        if(is_reviewId_active[reviewId] == false){
            is_reviewId_active[reviewId] == true;
            get_serviceIdArray_from_reviewId[reviewId] = serviceIdArray;
            emit ServiceRequested(reviewId, callTimestamp, serviceIdArray, msg.sender);
            return true;
        }
        return false;
    }

    mapping(uint32 => bool) is_reviewId_active;
    mapping(uint32 => uint32[]) get_serviceIdArray_from_reviewId;

    function offer(bytes32 serviceRequestId, uint256 _price)
    external returns (bool){
        return;
    }

    function accept(bytes32 serviceRequestId, address _delegatedTo)
    external returns (bool){
        return;
    }

    event ServiceAccepted(
        bytes32    indexed serviceRequestId,
        address indexed offeredBy,
        address indexed acceptedBy,
        string  serviceName
    );

    function claimCompletion(bytes32 serviceRequestId)
    external returns (bool){

    }

    event CompletionClaimed(
        bytes32    indexed serviceRequestId,
        address indexed claimedCompleteBy,
        string  serviceName
    );

    function approveCompletion(bytes32 serviceRequestId)
    external returns (bool){

    }

    event CompletionApproved(
        bytes32    indexed serviceRequestId,
        address indexed approvedAsCompleteBy,
        string  serviceName
    );

    function rejectCompletion(bytes32 serviceRequestId)
    external returns (bool){

    }

    event CompletionRejected(
        bytes32    indexed serviceRequestId,
        address indexed rejectedAsCompleteBy,
        string  serviceName
    );
}