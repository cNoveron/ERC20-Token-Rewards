// solium-disable linebreak-style
pragma solidity ^0.4.23;

import "./IServiceStateController.sol";

contract ServiceStateController is IServiceStateController {
    /**
    * 
    */
    function request(bytes4 _callTimestamp, bytes28 _serviceName) 
    external returns (bytes32) {
        bytes32 serviceRequestId = tightlyPack_nonAssembly(_callTimestamp, _serviceName);
        ServiceRequestData_from_ServiceRequestId[serviceRequestId] = ServiceRequestData(
            _callTimestamp, msg.sender, _serviceName
        );
        emit ServiceRequested(serviceRequestId, msg.sender, _serviceName);
        return serviceRequestId;
    }

    function tightlyPack_nonAssembly(bytes4 _callTimestamp, bytes28 _serviceName) 
    public returns (bytes32) {
        return bytes32(_callTimestamp << 28*8 ^ _serviceName);
    }

    mapping(bytes32 => ServiceRequestData) ServiceRequestData_from_ServiceRequestId;

    struct ServiceRequestData{
        bytes4  callTimestamp;
        address requestedBy;
        bytes28 serviceName;
    }


    function offer(bytes32 serviceRequestId, uint256 _price)
    external returns (bool){

    }

    function accept(bytes32 serviceRequestId, address _delegatedTo)
    external returns (bool){

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