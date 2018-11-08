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
    function request(uint _callTimestamp, string _serviceName) 
    external returns (bytes32);

    event ServiceRequested(
        bytes32 indexed requestEthSHA3,
        address indexed requestedBy,
        string  serviceName
    );

    /**
    * @dev Only a service provider should use this to offer his services in favor
    * of a previously identified serviceRequest.
    * @param _requestEthSHA3 bytes32 The number that identifies the serviceRequest.
    * @param _price bytes32 The price asked by the service provider.
    */
    function offer(bytes32 _requestEthSHA3, bytes32 _price)
    external pure returns (bool);

    event OfferMade(
        bytes32 indexed requestEthSHA3,
        address indexed offeredBy,
        string  serviceName
    );

    function accept(bytes32 _requestEthSHA3)
    external returns (bool);

    event ServiceAccepted(
        bytes32 indexed requestEthSHA3,
        address indexed offeredBy,
        address indexed acceptedBy,
        string  serviceName
    );

    function claimCompletion(bytes32 _requestEthSHA3)
    external returns (bool);

    event CompletionClaimed(
        bytes32 indexed requestEthSHA3,
        address indexed claimedCompleteBy,
        string  serviceName
    );

    function approveCompletion(bytes32 requestEthSHA3)
    external returns (bool);

    event CompletionApproved(
        bytes32 indexed requestEthSHA3,
        address indexed approvedAsCompleteBy,
        string  serviceName
    );

    function rejectCompletion(bytes32 requestEthSHA3)
    external returns (bool);

    event CompletionRejected(
        bytes32 indexed requestEthSHA3,
        address indexed rejectedAsCompleteBy,
        string  serviceName
    );
}