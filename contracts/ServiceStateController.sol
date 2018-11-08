// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./IServiceStateController.sol";

contract ServiceStateController is IServiceStateController {
    /**
    * 
    */
    function request(bytes4 _callTimestamp, bytes28 _serviceName) 
    external returns (bytes32) {
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


    function offer(bytes32 serviceRequestIdentifier, uint256 _price)
    external returns (bool){

    }

    function accept(bytes32 serviceRequestIdentifier, address _delegatedTo)
    external returns (bool){

    }

    event ServiceAccepted(
        bytes32    indexed serviceRequestIdentifier,
        address indexed offeredBy,
        address indexed acceptedBy,
        string  serviceName
    );

    function claimCompletion(bytes32 serviceRequestIdentifier)
    external returns (bool){

    }

    event CompletionClaimed(
        bytes32    indexed serviceRequestIdentifier,
        address indexed claimedCompleteBy,
        string  serviceName
    );

    function approveCompletion(bytes32 serviceRequestIdentifier)
    external returns (bool){

    }

    event CompletionApproved(
        bytes32    indexed serviceRequestIdentifier,
        address indexed approvedAsCompleteBy,
        string  serviceName
    );

    function rejectCompletion(bytes32 serviceRequestIdentifier)
    external returns (bool){

    }

    event CompletionRejected(
        bytes32    indexed serviceRequestIdentifier,
        address indexed rejectedAsCompleteBy,
        string  serviceName
    );
}