pragma solidity ^0.4.23;

interface IServiceStateController {    

    function request(string _serviceName) 
    external pure returns (uint);

    event ServiceRequested(
        uint    indexed serviceInstanceID,
        address indexed requestedBy,
        string  serviceName
    );

    function offer(uint serviceInstanceID)
    external pure returns (bool);

    event OfferMade(
        uint    indexed serviceInstanceID,
        address indexed offeredBy,
        string  serviceName
    );

    function accept(uint serviceInstanceID)
    external pure returns (uint);

    event ServiceAccepted(
        uint    indexed serviceInstanceID,
        address indexed offeredBy,
        address indexed acceptedBy,
        string  serviceName
    );

    function claimCompletion(uint serviceInstanceID)
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