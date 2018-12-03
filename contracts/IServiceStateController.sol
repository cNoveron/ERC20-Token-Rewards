// solium-disable linebreak-style
pragma solidity ^0.4.23;

interface IServiceStateController {
    /**
    * @dev Only a service client should use this to request a service in his favor.
    * Then an event shall be emited broadcasting the request to be listened by 
    * the service providers who are currently offering the service.
    * @param reviewId       uint32      The identifier of the review due to be submitted.
    * @param callTimestamp  uint32      The unix time when the request function was called.
    * @param serviceIdArray uint32[]    The identifiers of the requested services.
    */
    function request(uint32 reviewId, uint32 callTimestamp, uint32[] serviceIdArray) 
    external returns (bool);

    event ServiceRequested(
        uint32      indexed reviewId, 
        uint32      indexed callTimestamp, 
        uint32[]    indexed serviceIdArray,      
        address     requestedBy
    );

    /**
    * @dev Only a service provider should use this to offer his services in favor
    * of a previously identified serviceRequest.
    * @param serviceRequestIdentifier bytes32 The number that identifies the serviceRequest.
    * @param price bytes32 The price asked by the service provider.
    */
    function offer(bytes32 serviceRequestIdentifier, uint256 price)
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
    * @param serviceRequestIdentifier bytes32 The number that identifies the serviceRequest.
    * @param delegatedTo bytes32 The price asked by the service provider.
    */
    function accept(bytes32 serviceRequestIdentifier, address delegatedTo)
    external returns (bool);

    event ServiceAccepted(
        bytes32 indexed serviceRequestId,
        address indexed acceptedBy,
        address indexed delegatedTo,
        string  serviceName
    );

    function claimCompletion(bytes32 serviceRequestIdentifier)
    external returns (bool);

    event CompletionClaimed(
        bytes32 indexed serviceRequestId,
        address indexed claimedCompleteBy,
        string  serviceName
    );

    function approveCompletion(int reviewId, int rank, uint64 serviceCost, uint32 callTimestamp)
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