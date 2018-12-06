// solium-disable linebreak-style
pragma solidity ^0.4.23;

interface IServiceStateController {
    /**
    * @dev Only a service client should use this to request a service in his favor.
    * Then an event shall be emited broadcasting the request to be listened by 
    * the service providers who are currently offering the service.
    * @param reviewId           uint32      The identifier of the review due to be submitted.
    * @param requestTimestamp   uint32      The unix time when the request function was called.
    * @param serviceIdArray     uint32[]    The identifiers of the requested services.
    */
    function requestServices(uint32 reviewId, uint64 requestTimestamp, uint32[] serviceIdArray)
    external returns (bool);

    event ServiceRequested(
        uint32      indexed reviewId,
        uint64      indexed callTimestamp,
        uint32[]    indexed serviceIdArray,
        address     requesterEthAddress
    );

    /**
    * @dev Only a service provider should use this to offer his services in favor
    * of a previously identified serviceRequest.
    * @param reviewId       uint32      The identifier of the review due to be submitted.
    * @param offerTimestamp uint64      The unix time when the request function was called.
    * @param price          uint16      The provider's price in USD.
    */
    function offerServices(uint32 reviewId, uint64 offerTimestamp, uint16 price) 
    external returns (bool);

    event ServiceOffered(
        uint32      indexed reviewId, 
        uint64      indexed offerTimestamp,
        uint16      indexed price,
        address     offererEthAddress
    );

    /**
    * @dev Only the service client who owns the serviceRequest should call this 
    * to accept and delegate services in his favor to a service provider
    * who had previously called an offer to the serviceRequest.
    * @param reviewId               uint32      The identifier of the review due to be submitted.
    * @param acceptanceTimestamp    uint32      The provider's price in USD.
    * @param offererEthAddress      address     The provider's price in USD.
    */
    function acceptOffer(uint32 reviewId, uint64 acceptanceTimestamp, address offererEthAddress)
    external returns (bool);

    event ServiceAccepted(
        uint32      indexed reviewId,
        uint64      indexed acceptanceTimestamp,
        address     requesterEthAddress,
        address     offererEthAddress 
    );

    function claimCompletion(uint32 reviewId, uint64 claimTimestamp)
    external returns (bool);

    event CompletionClaimed(
        uint32      indexed reviewId,
        uint64      indexed claimTimestamp,
        address     requesterEthAddress,
        address     offererEthAddress
    );

    function approveCompletion(uint32 reviewId, uint64 approvalTimestamp, uint8 rating)
    external returns (uint RewardAmount);

    event CompletionApproved(
        uint32      indexed reviewId,
        uint64      indexed approvalTimestamp,
        address     requesterEthAddress,
        address     offererEthAddress
    );

    function rejectCompletion(uint32 reviewId, uint64 rejectionTimestamp)
    external returns (bool);

    event CompletionRejected(
        uint32 indexed reviewId,
        uint64 indexed rejectionTimestamp
    );
}