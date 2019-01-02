// solium-disable linebreak-style
pragma solidity ^0.4.23;

    /**
* @title IServiceStateController
* @author Carlos Noverón
* @notice 
* @dev Estos métodos serán llamados desde Nethereum.
    */

interface IServiceStateController {




    /// @notice Any service client should use this to request a service in their favor.
    /// Then an event shall be emited broadcasting the request to be listened by 
    /// the service providers who are currently offering the service.
    /// @param reviewId           uint32      The identifier of the review due to be submitted.
    /// @param requestTimestamp   uint64      The UNIX time when requestServices was called.
    /// @param serviceIdArray     uint32[]    The identifiers of the requested services.

    function requestServices(uint32 reviewId, uint64 requestTimestamp, uint32[] serviceIdArray)
    external returns(uint8);

    /// @dev 403 Forbidden
    ///
    /// requestServices ( 0, ANY, ANY, { from: ANY })  @return 1
    /// requestServices ( 0, ANY, ANY, { from: ANY })  @return Failed: Revert();
    ///
    /// requestServices ( 0, 0,   ANY, { from: ANY })  @return 1
    /// requestServices ( 1, 0,   ANY, { from: ANY })  @return Failed: Revert();

    /// @dev 200 OK
    ///
    /// requestServices ( 0, 0,   ANY, { from: adr0 }) @return 1
    /// requestServices ( 1, 1,   ANY, { from: adr1 }) @return 1
    

    event ServicesRequested(
        uint32      indexed reviewId,
        uint64      indexed requestTimestamp,
        uint32[]    serviceIdArray,
        address     requesterAddress
    );




    /// @notice Only a service provider should use this to offer his services in favor.
    /// @param reviewId       uint32      The identifier of the review due to be submitted.
    /// @param offerTimestamp uint64      The UNIX time when offerServices was called.
    /// @param price          uint16      The provider's price in USD.
    
    function offerServices(uint32 reviewId, uint64 offerTimestamp, uint16 price) 
    external 
    returns(uint8);


    /// @dev 403 Forbidden 
    ///
    /// requestServices (ANY, ANY, ANY,  { from: adr0 }) @return 1
    /// offerServices   (ANY, ANY, ANY,  { from: adr0 }) @return Failed: Revert();
    ///
    /// requestServices (  0, 0,   ANY,  { from: adr0 }) @return 1
    /// offerServices   (  0, 0,   ANY,  { from: adr1 }) @return Failed: Revert();
    ///
    /// requestServices (  0, 0,   ANY,  { from: adr0 }) @return 1
    /// offerServices   (  1, 0,   ANY,  { from: adr0 }) @return Failed: Revert();
    ///
    /// requestServices (  0, 0,   ANY,  { from: adr0 }) @return 1
    /// offerServices   (  1, 1,   ANY,  { from: adr1 }) @return Failed: Revert();
    ///
    /// requestServices (  0, 0,   ANY,  { from: adr0 }) @return 1
    /// offerServices   (  0, 1,   ANY,  { from: adr1 }) @return 1
    /// offerServices   (  0, 1,   ANY,  { from: adr1 }) @return Failed: Revert();
    ///
    /// requestServices (  0, 0,   ANY,  { from: adr0 }) @return 1
    /// offerServices   (  0, 1,   ANY,  { from: adr1 }) @return 1
    /// offerServices   (  0, 2,   ANY,  { from: adr1 }) @return Failed: Revert();


    /// @dev 200 OK - A 1st call for requestServices.
    ///
    /// requestServices (  0, 0,   ANY,  { from: adr0 }) @return 1
    /// offerServices   (  0, 1,   ANY,  { from: adr1 }) @return 1
    ///
    /// requestServices (  0, 0,   ANY,  { from: adr0 }) @return 1
    /// offerServices   (  0, 1,   ANY,  { from: adr1 }) @return 1
    /// offerServices   (  1, 2,   ANY,  { from: adrN }) @return 1


    event ServicesOffered(
        uint32      indexed reviewId, 
        uint64      indexed offerTimestamp,
        uint16      indexed price,
        address     offererAddress
    );




    /// @dev Only the requester's address should call acceptOffer on a reviewId that has had
    /// 1 or more offers for him/her.
    /// @param reviewId               uint32  The identifier of the review due to be submitted.
    /// @param acceptanceTimestamp    uint64  The UNIX time when the acceptOffer method was called.
    /// @param offererAddress         address The provider's Ethereum address.
    
    function acceptOffer(uint32 reviewId, uint64 acceptanceTimestamp, address offererAddress)
    external returns(uint8);

    /// @dev 403 Forbidden -  A 1st call for requestServices.
    ///
    /// requestServices ( ANY, ANY, ANY, { from: adr0 }) @return 1
    /// acceptOffer     ( ANY, ANY, ANY, { from: ANY })  @return Failed: Revert();
    ///
    /// requestServices ( ANY, ANY, ANY, { from: adr0 }) @return 1
    /// acceptOffer     ( ANY, ANY, ANY, { from: ANY })  @return Failed: Revert();

    event OfferAccepted(
        uint32      indexed reviewId,
        uint64      indexed acceptanceTimestamp,
        address     requesterEthAddress,
        address     offererEthAddress
    );

    function claimCompletion(uint32 reviewId, uint64 claimTimestamp)
    external returns(bool);

    event CompletionClaimed(
        uint32      indexed reviewId,
        uint64      indexed claimTimestamp,
        address     requesterEthAddress,
        address     offererEthAddress
    );

    function approveCompletion(uint32 reviewId, uint64 approvalTimestamp, uint8 rating)
    external returns(uint RewardAmount);

    event CompletionApproved(
        uint32      indexed reviewId,
        uint64      indexed approvalTimestamp,
        address     requesterEthAddress,
        address     offererEthAddress
    );

    function rejectCompletion(uint32 reviewId, uint64 rejectionTimestamp)
    external returns(bool);

    event CompletionRejected(
        uint32 indexed reviewId,
        uint64 indexed rejectionTimestamp,
        address     requesterEthAddress,
        address     offererEthAddress
    );
}