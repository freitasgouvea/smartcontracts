pragma solidity 0.5.1.;

contract ServiceSmartContractWithArbitration {
    address payable provider;
    address arbitrator;
    uint256 value;
    uint256 valueToTransfer;
    uint256 disponibleValue;
    
    service [] listOfSells;
    dispute [] listOfDisputes;
    
    struct service {
        address contractor;
        uint256 dueDate;
        uint256 valueOfBill;
        uint256 dateOfPayment;
        bool servicePayed;
        bool serviceDelivered;
        bool serviceAccepted;
        bool serviceDisputed;
    }
    
    struct dispute {
        uint256 serviceID;
        address contractor;
        uint256 valueOfADispute;
        bool disputeProcessed;
        bool resultOfDispute;
    }
    
    constructor (address payable _providerWallet, address _arbitratorWallet ) public {
        provider = _providerWallet;
        arbitrator = _arbitratorWallet;
    }
    
    function registrerService(address _contractor, uint256 _dueDate, uint256 _valueOfBill) public {
        require (msg.sender == provider);
        listOfSells.push(service(_contractor, _dueDate, _valueOfBill, 0, false, false, false, false));
    }
    
    function payService(uint256 serviceId) public payable {
        require (listOfSells[serviceId].valueOfBill == msg.value);
        require (listOfSells[serviceId].servicePayed == false);
        listOfSells[serviceId].dateOfPayment = now;
        listOfSells[serviceId].servicePayed = true;
        value += msg.value;
    }
    
    function deliveryAService(uint256 serviceId) public payable {
        require (msg.sender == provider);
        require (true == listOfSells[serviceId].servicePayed);
        listOfSells[serviceId].serviceDelivered = true;
    }
    
    function acceptADelivery(uint256 serviceId) public payable {
        require (msg.sender == listOfSells[serviceId].contractor);
        listOfSells[serviceId].serviceAccepted = true;
        disponibleValue += listOfSells[serviceId].valueOfBill;
    }
    
    function contestAService(uint256 serviceId) public {
        require (msg.sender == listOfSells[serviceId].contractor);
        require (true == listOfSells[serviceId].serviceDelivered);
        listOfDisputes.push(dispute(serviceId, listOfSells[serviceId].contractor, listOfSells[serviceId].valueOfBill, false, false));
        listOfSells[serviceId].serviceDisputed = true;
    }
    
    function solveADispute(uint256 disputeID, bool result) public {
        require (msg.sender == arbitrator);
        //////
    }
    
    function showBill(uint256 serviceId) public view returns (address, uint256, uint256, uint256, bool, bool, bool) {
        return (listOfSells[serviceId].contractor, listOfSells[serviceId].dueDate, listOfSells[serviceId].valueOfBill, listOfSells[serviceId].dateOfPayment, listOfSells[serviceId].servicePayed, listOfSells[serviceId].serviceDelivered, listOfSells[serviceId].serviceAccepted );
    }
    
    ///function showDispute (uint256 serviceId)
    
    function showBalance() public view returns(uint256, uint256){
        require (msg.sender == provider);
        return (value,disponibleValue);
    }
    
    function drawSells(uint256 _value) public payable {
        require (msg.sender == provider);
        require (_value <= disponibleValue);
        valueToTransfer = _value;
        provider.transfer(valueToTransfer);
        value -= _value;
        disponibleValue -=_value;
    }
}