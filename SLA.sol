pragma solidity 0.5.1.;

contract SLA {
    address payable provider;
    address payable contractor;
    uint public dateOfStart;
    uint dateOfFirstBill;
    uint dateOfNextBill;
    uint public deadline;
    uint public totalValue;
    uint numberOfBills;
    uint interestRate;
    uint fineForDelay;
    uint public daysOfDelay;
    uint public valuePayed;
    //uint public progress;
    //uint projectKpi;
    
    bill [] public listOfbills;
    
    struct bill {
        uint valueOfBill;
        uint dueDate;
        uint daysOfLate;
        uint payDay;
        uint total;
        bool billPayed;
    }
    
    constructor ( 
        address payable _providerWallet,
        address payable _contractorWallet,
        uint _dateOfStart,
        uint _deadline,
        uint _totalValue,
        uint _fineForDelay,
        uint _numberOfBills,
        uint _dateOfFirstBill
        ) public 
    {
        provider = _providerWallet;
        contractor = _contractorWallet;
        dateOfStart = _dateOfStart;
        deadline = _deadline;
        totalValue = _totalValue;
        fineForDelay = _fineForDelay*daysOfDelay;
        numberOfBills = _numberOfBills;
        dateOfFirstBill = _dateOfFirstBill;
        
    }
    
    function generateBills() public {
        require (msg.sender == provider);
        listOfbills.length = numberOfBills;
        //listOfbills.push(bill(totalValue/numberOfBills, dateOfFirstBill, 0, 0, 0, false ));
        for (uint i=0; i <= listOfbills.length; i++) {
            //bill memory newBill = bill[i];
            if (numberOfBills >= listOfbills.length)
            listOfbills.push(bill(totalValue/numberOfBills, dateOfFirstBill+i*2629743, 0, 0, 0, false ));
        }
    }
    
    //function payBill(int _billNumber) public payable {
        //require (msg.sender == contractor);
        //require (msg.value == totalValue/numberOfBills+interestRate);
        //bill memory billPayedNow = bill[_billNumber];
        //listOfbills.push(bill(totalValue/numberOfBills, , now-bill.dueDate, now, false ));
        //provider.transfer(address(this).balance);
    //}
}
