// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./IServiceStateController.sol";

contract ServiceStateController is IServiceStateController {
    /**
    * 
    */
    function request(bytes4 _callTimestamp, bytes28 _serviceName) 
    external returns (bytes32){
        bytes32 serviceRequestIdentifier = tightlyPack_nonAssembly(_callTimestamp, _serviceName);
        ServiceRequest memory newServiceRequest = ServiceRequest(
            serviceRequestIdentifier, _callTimestamp, msg.sender, _serviceName
        );
        ServiceRequest_from_Id[serviceRequestIdentifier] = newServiceRequest;
        emit ServiceRequested(serviceRequestIdentifier, msg.sender, _serviceName);
        return serviceRequestIdentifier;
    }

    function tightlyPack_nonAssembly(bytes4 _callTimestamp, bytes28 _serviceName) 
    internal returns (bytes32) {
        return bytes32(_callTimestamp << 28*8 ^ _serviceName);
    }

    mapping(bytes32 => ServiceRequest) ServiceRequest_from_Id;

    struct ServiceRequest{
        bytes32 serviceRequestId;
        bytes4  callTimestamp;
        address requestedBy;
        bytes28 serviceName;
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