// solium-disable linebreak-style
pragma solidity ^0.4.23;

interface IServiceStateController {
    /**
    * @dev Only a service client should use this to request a service in his favor.
    * Then an event shall be emited broadcasting the request to be listened by 
    * the service providers who are currently offering the service.
    * @param reviewId           uint32      The identifier of the review due to be submitted.
    * @param requestTimestamp   uint64      The UNIX time when the request function was called.
    * @param serviceIdArray     uint32[]    The identifiers of the requested services.
    */
    function requestServices(uint32 reviewId, uint64 requestTimestamp, uint32[] serviceIdArray)
    external returns(bool);

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
    * @param offerTimestamp uint64      The UNIX time when the offerServices method was called.
    * @param price          uint16      The provider's price in USD.
    */
    function offerServices(uint32 reviewId, uint64 offerTimestamp, uint16 price) 
    external 
    returns(uint8);


    /// @dev 403 Forbidden - A 1st call for requestServices, 
    /// then A 2nd call for offerServices
    /// from *THE_SAME address as that of the call for requestServices.
    ///
    /// This is implemented through this modifier in ReviewsController.sol 
    /// reviewId_isInState(state.AWATING_DEAL, reviewId)
    ///
    ///
    /// This batch of tests will be a fist call with the following parameters:
    /// [ R-0000 ] requestServices(0, 0, [1,2,3],   { from: 0xa })  @return 1
    ///
    /// Followed by each of the following calls as second call, in each individual test:
    /// [ O-0000 ] offerServices(  0, 0, 100,       { from: 0xa })  <--  SHALL NOT PASS
    /// [ O-0010 ] offerServices(  0, 0, 2222,      { from: 0xa })  <--  SHALL NOT PASS
    /// [ O-0100 ] offerServices(  0, 1, 100,       { from: 0xa })  <--  SHALL NOT PASS
    /// [ O-0110 ] offerServices(  0, 1, 2222,      { from: 0xa })  <--  SHALL NOT PASS
    /// [ O-1000 ] offerServices(  1, 0, 100,       { from: 0xa })  <--  SHALL NOT PASS
    /// [ O-1010 ] offerServices(  1, 0, 2222,      { from: 0xa })  <--  SHALL NOT PASS
    /// [ O-1100 ] offerServices(  1, 1, 100,       { from: 0xa })  <--  SHALL NOT PASS
    /// [ O-1110 ] offerServices(  1, 1, 2222,      { from: 0xa })  <--  SHALL NOT PASS
    ///
    /// Golden rule:
    /// [ R-0000 ] requestServices(0, 0, [1,2,3],   { from: 0xa })  @return 1
    /// [ O-XXX0 ] requestServices(*ANY, *ANY, *ANY,{ from: 0xa })  <--  SHALL NOT PASS


    /// @dev 403 Forbidden - A 1st call for requestServices, 
    /// then a 2nd call for offerServices
    /// for *THE_SAME given reviewId,
    /// at *THE_SAME timestamp as that reviewId,
    /// from a *DIFFERENT address than that of the first call.
    ///
    /// Theoretically, since request and offer timestamps can be retrieved and compared by both
    /// web server and blockchain server. The following call sequences to ReviewsController.sol  
    /// should not be made from the blockchain server. Nonetheless, security measures MUST be 
    /// implemented within the contract for users who choose to operate their own wallets.
    ///
    ///
    /// This batch of tests will be a fist call with the following parameters:
    /// [ R-0000 ] requestServices(0, 0, [1,2,3],   { from: 0xa })  @return 1
    ///
    /// Followed by each of the following calls as second call, in each individual test:
    /// [ O-0001 ] offerServices(  0, 0, 100,       { from: 0xb })  <--  SHALL NOT PASS
    /// [ O-0011 ] offerServices(  0, 0, 2222,      { from: 0xb })  <--  SHALL NOT PASS
    ///
    /// Golden rule:
    /// [ R-0000 ] requestServices(0, 0, [1,2,3],   { from: 0xa })  @return 1
    /// [ O-00X1 ] requestServices(1, 0, *ANY,      { from: *ANY }) <--  SHALL NOT PASS


    /// @dev 200 OK - A 1st call for requestServices, 
    /// then a 2nd call for offerServices
    /// for *THE_SAME reviewId as that of the 1st call,
    /// at a *DIFFERENT timestamp than that of the 1st call,
    /// from a *DIFFERENT address than that of the 1st call.
    ///
    ///
    /// This batch of tests will be a fist call with the following parameters:
    /// [ R-0000 ] requestServices(0, 0, [1,2,3],   { from: 0xa })  @return 1
    ///
    /// Followed by each of the following calls as second call, in each individual test:
    /// [ O-0101 ] offerServices(  0, 1, 100,       { from: 0xb })  @return 1
    /// [ O-0111 ] offerServices(  0, 1, 2222,      { from: 0xb })  @return 1
    ///
    /// Golden rule:
    /// [ R-0000 ] requestServices(0, 0, [1,2,3],   { from: 0xa })  @return 1
    /// [ O-01X1 ] offerServices(  0, 1, 2222,      { from: 0xb })  @return 1


    /// @dev 403 Forbidden - A 1st call for requestServices, 
    /// then a 2nd call for offerServices
    /// for an *DIFFERENT reviewId than that of the 1st call,
    /// at a *DIFFERENT timestamp that of the 1st call,
    /// from a *DIFFERENT address that of the 1st call.
    ///
    ///
    /// This batch of tests will be a fist call with the following parameters:
    /// [ R-0000 ] requestServices(0, 0, [1,2,3],   { from: 0xa })  @return 1
    ///
    /// Followed by each of the following calls as second call, in each individual test:
    /// [ O-1001 ] offerServices(  1, 0, 100,       { from: 0xa })  <--  SHALL NOT PASS
    /// [ O-1011 ] offerServices(  1, 0, 2222,      { from: 0xa })  <--  SHALL NOT PASS
    /// [ O-1101 ] offerServices(  1, 1, 100,       { from: 0xa })  <--  SHALL NOT PASS
    /// [ O-1111 ] offerServices(  1, 1, 2222,      { from: 0xa })  <--  SHALL NOT PASS
    ///
    /// Golden rule: 
    /// [ R-0000 ] requestServices(0, 0, [1,2,3],   { from: 0xa })  @return 1
    /// [ O-1XXX ] requestServices(1, *ANY, *ANY,   { from: *ANY }) <--  SHALL NOT PASS


    /// @dev 403 Forbidden - A 1st call for requestServices, 
    /// then a 2nd call for offerServices
    /// for *THE_SAME reviewId,
    /// at a *DIFFERENT timestamp than that unexistent reviewId,
    /// from a *DIFFERENT address than that reviewId.
    ///
    /// then a 3rd call for offerServices
    /// for an *UNEXISTENT reviewId,
    /// at a *DIFFERENT timestamp than that unexistent reviewId,
    /// from a *DIFFERENT address than that reviewId.
    ///
    ///
    /// This batch of tests will be 2 calls with the following parameters:
    /// [ R-0000 ] requestServices(0, 0, [1,2,3],   { from: 0xa })  @return 1
    /// [ R-11XX ] requestServices(1, 1, *ANY,      { from: *ANY }) @return 1
    ///
    /// Followed by:
    /// [ O-0001 ] offerServices(  0, 0, 100,       { from: 0xa })  <--  SHALL NOT PASS

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
    * @param acceptanceTimestamp    uint64      The UNIX time when the acceptOffer method was called.
    * @param offererEthAddress      address     The provider's price in USD.
    */
    function acceptOffer(uint32 reviewId, uint64 acceptanceTimestamp, address offererEthAddress)
    external returns(bool);

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