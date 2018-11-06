// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./IServiceStateController.sol";

contract ServiceStateController is IServiceStateController {
    /**
    * 
    */
    function request(uint _callTimestamp, string _serviceName) 
    external returns (bytes32){
        bytes32 requestEthSHA3 = keccak256(_callTimestamp, msg.sender, _serviceName);
        ServiceRequest memory newServiceRequest = ServiceRequest(
            requestEthSHA3,_callTimestamp, msg.sender, _serviceName
        );
        ServiceRequest_from_Id[requestEthSHA3] = newServiceRequest;
        emit ServiceRequested(requestEthSHA3, msg.sender, _serviceName);
        return requestEthSHA3;
    }

    mapping(bytes32 => ServiceRequest) ServiceRequest_from_Id;

    struct ServiceRequest{
        bytes32 serviceRequestId;
        uint    callTimestamp;
        address requestedBy;
        string  serviceName;
    }

    function offer(bytes32 serviceInstanceID)
    external pure returns (bool){

    }
    function accept(bytes32 serviceInstanceID)
    external pure returns (bytes32){

    }

    event ServiceAccepted(
        bytes32    indexed serviceInstanceID,
        address indexed offeredBy,
        address indexed acceptedBy,
        string  serviceName
    );

    function claimCompletion(bytes32 serviceInstanceID)
    external pure returns (bytes32){

    }

    event CompletionClaimed(
        bytes32    indexed serviceInstanceID,
        address indexed claimedCompleteBy,
        string  serviceName
    );

    function approveCompletion(bytes32 serviceInstanceID)
    external pure returns (bytes32){

    }

    event CompletionApproved(
        bytes32    indexed serviceInstanceID,
        address indexed approvedAsCompleteBy,
        string  serviceName
    );

    function rejectCompletion(bytes32 serviceInstanceID)
    external pure returns (bytes32){

    }

    event CompletionRejected(
        bytes32    indexed serviceInstanceID,
        address indexed rejectedAsCompleteBy,
        string  serviceName
    );
}