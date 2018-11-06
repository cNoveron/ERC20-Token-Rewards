// solium-disable linebreak-style
pragma solidity ^0.4.23;

interface IServiceStateController {
    /**
    * @dev Only a service client should use this to request a service in his favor.
    * Then an event shall be emited broadcasting the request to be listened by 
    * the service providers who are currently offering the service.
    * @param _serviceName string The name that identifies the service.
    */
    function request(string _serviceName) 
    external returns (bytes32);

    event ServiceRequested(
        bytes32    indexed serviceRequestId,
        address indexed requestedBy,
        string  serviceName
    );

    /**
    * @dev Only a service provider should use this to offer his services iN favor
    * of a previously identified serviceRequest.
    * @param _serviceRequestId bytes32 The number that identifies the serviceRequest.
    * @param _price bytes32 The price asked by the service provider.
    */
    function offer(bytes32 _serviceRequestId, bytes32 _price)
    external pure returns (bool);

    event OfferMade(
        bytes32    indexed serviceRequestId,
        address indexed offeredBy,
        string  serviceName
    );

    function accept(bytes32 _serviceRequestId)
    external pure returns (bytes32);

    event ServiceAccepted(
        bytes32    indexed serviceRequestId,
        address indexed offeredBy,
        address indexed acceptedBy,
        string  serviceName
    );

    function claimCompletion(bytes32 _serviceRequestId)
    external pure returns (bytes32);

    event CompletionClaimed(
        bytes32    indexed serviceRequestId,
        address indexed claimedCompleteBy,
        string  serviceName
    );

    function approveCompletion(bytes32 serviceRequestId)
    external pure returns (bytes32);

    event CompletionApproved(
        bytes32    indexed serviceRequestId,
        address indexed approvedAsCompleteBy,
        string  serviceName
    );

    function rejectCompletion(bytes32 serviceRequestId)
    external pure returns (bytes32);

    event CompletionRejected(
        bytes32    indexed serviceRequestId,
        address indexed rejectedAsCompleteBy,
        string  serviceName
    );
}