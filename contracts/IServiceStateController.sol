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
    external pure returns (uint);

    event ServiceRequested(
        uint    indexed serviceRequestId,
        address indexed requestedBy,
        string  serviceName
    );

    /**
    * @dev Only a service provider should use this to offer his services iN favor
    * of a previously identified serviceRequest.
    * @param _serviceRequestId uint The number that identifies the serviceRequest.
    * @param _price uint The price asked by the service provider.
    */
    function offer(uint _serviceRequestId, uint _price)
    external pure returns (bool);

    event OfferMade(
        uint    indexed serviceRequestId,
        address indexed offeredBy,
        string  serviceName
    );

    function accept(uint _serviceRequestId)
    external pure returns (uint);

    event ServiceAccepted(
        uint    indexed serviceRequestId,
        address indexed offeredBy,
        address indexed acceptedBy,
        string  serviceName
    );

    function claimCompletion(uint _serviceRequestId)
    external pure returns (uint);

    event CompletionClaimed(
        uint    indexed serviceRequestId,
        address indexed claimedCompleteBy,
        string  serviceName
    );

    function approveCompletion(uint serviceRequestId)
    external pure returns (uint);

    event CompletionApproved(
        uint    indexed serviceRequestId,
        address indexed approvedAsCompleteBy,
        string  serviceName
    );

    function rejectCompletion(uint serviceRequestId)
    external pure returns (uint);

    event CompletionRejected(
        uint    indexed serviceRequestId,
        address indexed rejectedAsCompleteBy,
        string  serviceName
    );
}