// solium-disable linebreak-style
pragma solidity ^0.4.23;

interface IServiceStateController {
    /**
    * @dev Only a service client should use this to request a service in his favor.
    * Then an event shall be emited broadcasting the request to be listened by 
    * the service providers who are currently offering the service.
    * @param _callTimestamp uint The unix time when the request function was called.
    * @param _serviceName string The name that identifies the service.
    */
    function request(bytes4 _callTimestamp, bytes28 _serviceName) 
    external returns (bytes32);

    event ServiceRequested(
        bytes32 indexed serviceRequestId,
        bytes4  indexed _callTimestamp,
        bytes28 indexed serviceName,        
        address requestedBy
    );

    /**
    * @dev Only a service provider should use this to offer his services in favor
    * of a previously identified serviceRequest.
    * @param _serviceRequestIdentifier bytes32 The number that identifies the serviceRequest.
    * @param _price bytes32 The price asked by the service provider.
    */
    function offer(bytes32 _serviceRequestIdentifier, uint256 _price)
    external returns (bool);

    event OfferMade(
        bytes32 indexed serviceRequestId,
        address indexed offeredBy,
        string  serviceName
    );

    /**
    * @dev Only the service client who owns the serviceRequest should call this 
    * to accept and delegate services in his favor to a service provider
    * who had previously called an offer to the serviceRequest.
    * @param _serviceRequestIdentifier bytes32 The number that identifies the serviceRequest.
    * @param _delegatedTo bytes32 The price asked by the service provider.
    */
    function accept(bytes32 _serviceRequestIdentifier, address _delegatedTo)
    external returns (bool);

    event ServiceAccepted(
        bytes32 indexed serviceRequestId,
        address indexed acceptedBy,
        address indexed delegatedTo,
        string  serviceName
    );

    function claimCompletion(bytes32 _serviceRequestIdentifier)
    external returns (bool);

    event CompletionClaimed(
        bytes32 indexed serviceRequestId,
        address indexed claimedCompleteBy,
        string  serviceName
    );

    function approveCompletion(bytes32 serviceRequestId)
    external returns (bool);

    event CompletionApproved(
        bytes32 indexed serviceRequestId,
        address indexed approvedAsCompleteBy,
        string  serviceName
    );

    function rejectCompletion(bytes32 serviceRequestId)
    external returns (bool);

    event CompletionRejected(
        bytes32 indexed serviceRequestId,
        address indexed rejectedAsCompleteBy,
        string  serviceName
    );
}