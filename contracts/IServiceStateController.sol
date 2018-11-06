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
        uint    indexed serviceInstanceID,
        address indexed requestedBy,
        string  serviceName
    );

    /**
    * @dev Only a service provider should use this to offer his services iN favor
    * of a previously identified serviceInstance.
    * @param _serviceInstanceID uint The number that identifies the serviceInstance.
    * @param _price uint The price asked by the service provider.
    */
    function offer(uint _serviceInstanceID, uint _price)
    external pure returns (bool);

    event OfferMade(
        uint    indexed serviceInstanceID,
        address indexed offeredBy,
        string  serviceName
    );

    function accept(uint _serviceInstanceID)
    external pure returns (uint);

    event ServiceAccepted(
        uint    indexed serviceInstanceID,
        address indexed offeredBy,
        address indexed acceptedBy,
        string  serviceName
    );

    function claimCompletion(uint _serviceInstanceID)
    external pure returns (uint);

    event CompletionClaimed(
        uint    indexed serviceInstanceID,
        address indexed claimedCompleteBy,
        string  serviceName
    );

    function approveCompletion(uint serviceInstanceID)
    external pure returns (uint);

    event CompletionApproved(
        uint    indexed serviceInstanceID,
        address indexed approvedAsCompleteBy,
        string  serviceName
    );

    function rejectCompletion(uint serviceInstanceID)
    external pure returns (uint);

    event CompletionRejected(
        uint    indexed serviceInstanceID,
        address indexed rejectedAsCompleteBy,
        string  serviceName
    );
}