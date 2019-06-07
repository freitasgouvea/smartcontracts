pragma solidity 0.5.1.;

contract SLA {
    address payable provider;
    address payable contractor;
    uint public dateOfStart;
    uint256 public totalValue;
    uint256 public totalValuePayed;
    uint256 interestRate;
    uint256 public numberOfBills;
    uint256 public numberOfBillsPayed;
    uint256 public billValue;
    uint256 dateOfLastBill;
    uint256 public dateOfNextBill;
    bool public serviceConcluded;
    
       bill [] public listOfBills;
    
    struct bill {
        uint256 dueDate;
        uint256 valueOfBill;
        uint256 dateOfBill;
        uint256 amountBilled;
        bool payed;
    }
    

    event Payment();
    
    modifier OnlySeller() {
    require(msg.sender == provider);
    _; 
    }
    
    modifier OnlyBuyer() {
    require(msg.sender == contractor);
    _; 
    }
    
    constructor (
        address payable _contractorWallet,
        uint256 _totalValue,
        uint256 _interestRate,
        uint256 _numberOfBills,
        uint256 _dateOfFirstBill
        ) public
    {
        provider = msg.sender;
        contractor = _contractorWallet;
        totalValue = _totalValue;
        interestRate = _interestRate;
        numberOfBills = _numberOfBills;
        billValue = _totalValue/_numberOfBills;
        dateOfNextBill = _dateOfFirstBill;
        serviceConcluded = false;
    }
    
    function payABill () OnlyBuyer public payable {
        require (now <= dateOfNextBill);
        require (msg.value == billValue);
        dateOfNextBill = dateOfNextBill + 2629743;
        totalValuePayed += billValue;
        numberOfBillsPayed ++;
        listOfBills.push(bill(dateOfNextBill, billValue, now, msg.value, true));
        provider.transfer(msg.value);
        emit Payment();
    }
    
    function payWithLate () OnlyBuyer public payable {
        require (now > dateOfNextBill);
        require (msg.value == billValue+((now-dateOfNextBill)*interestRate/2629743));
        dateOfNextBill = dateOfNextBill + 2629743;
        totalValuePayed += billValue;
        numberOfBillsPayed ++;
        listOfBills.push(bill(dateOfNextBill, billValue, now, msg.value, true));
        provider.transfer(msg.value);
        emit Payment();
    }
    
}
