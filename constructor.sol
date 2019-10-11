pragma solidity 0.5.12;

contract Construction {
    
    address payable managerWallet;
    address payable contractorWallet;
    uint256 globalValue;
    uint256 retainerValue;
    uint256 arbitratorFee;
    uint256 totalValua;
    uint256 numberOfInstallments;
    uint256 totalPayedValue;
    uint256 delayRate;
    uint256 bonusRate;
    uint256 globalDeadline;
    uint256 totalSteps;
    uint256 deliveredSteps;
    bytes32 contractHash;
    
    Step [] public steps;
    
    struct Step {
        address payable providerWallet;
        string stepName;
        uint256 stepValue;
        uint256 managerFee;
        uint256 providerFee;
        uint256 stepStartDate;
        bytes32 startHash;
        uint256 stepDeliverDate;
        bytes32 deliverHash;
        uint256 stepDeadlineDay;
        uint256 stepPayedValue;
        bool stepStarted;
        bool stepDelivered;
        bool stepAccepted;
        bool stepArbitred;
    }
    
    constructor (address payable _managerWallet, 
        address payable _contractorWallet,
        uint256 _globalValue,
        uint256 _numberOfInstallments,
        uint256 _delayRate,
        uint256 _bonusRate,
        uint256 _globalDeadline
        ) 
    public {
        managerWallet = _managerWallet;
        contractorWallet = _contractorWallet;
        globalValue = _globalValue;
        numberOfInstallments = _numberOfInstallments;
        delayRate = _delayRate;
        bonusRate = _bonusRate;
        globalDeadline = _globalDeadline;
    }
    
    //function CreateStep
    
    //function EditStep
    
    //function PayInstallment
    
    //function StartStep
    
    //function DeliverStep
        
}





