pragma solidity 0.5.1.;

contract BuyACar {
    address payable seller;
    address payable buyer;
    address car;
    uint256 public totalValue;
    uint256 public totalValuePayed;
    uint256 public totalValueOpen;
    uint256 interestRate;
    uint256 public numberOfBills;
    uint256 public numberOfBillsPayed;
    uint256 public numberOfBillsOpen;
    uint256 public billValue;
    uint256 dateOfLastBill;
    uint256 public dateOfNextBill;
    bool public notificatedForLate;
    uint256 dateOfLastNotification;
    bool vehicleOff;
    bool public carBlocked;

    bill [] public listOfBills;
    
    struct bill {
        uint256 dueDate;
        uint256 valueOfBill;
        uint256 dateOfBill;
        uint256 amountBilled;
        bool payed;
    }
    
    event Payment();
    event Notification();
    event vehicleBlocked();
    event vehicleUnblocked();
    
    modifier OnlySeller() {
    require(msg.sender == seller);
    _; 
    }
    
    modifier OnlyBuyer() {
    require(msg.sender == buyer);
    _; 
    }
    
    constructor (
        address payable _buyerWallet,
        address _carWallet,
        uint256 _totalValue,
        uint256 _interestRate,
        uint256 _numberOfBills,
        uint256 _dateOfFirstBill
        ) public
    {
        buyer = _buyerWallet;
        car = _carWallet;
        totalValue = _totalValue;
        interestRate = _interestRate;
        numberOfBills = _numberOfBills;
        billValue = _totalValue/_numberOfBills;
        dateOfNextBill = _dateOfFirstBill;
        totalValueOpen = totalValue - totalValuePayed;
        numberOfBillsOpen = numberOfBills-numberOfBillsPayed;
        notificatedForLate = false;
        carBlocked = false;
        vehicleOff = true;
    }
    
    
    function payACar () OnlyBuyer public payable {
        require (now <= dateOfNextBill);
        require (msg.value == billValue);
        dateOfNextBill = dateOfNextBill + 2629743;
        totalValuePayed += billValue;
        numberOfBillsPayed ++;
        listOfBills.push(bill(dateOfNextBill, billValue, now, msg.value, true));
        seller.transfer(address(this).balance);
        emit Payment();
    }
    
    function payACarWithLate () OnlyBuyer public payable {
        require (now >= dateOfNextBill);
        require (msg.value == billValue+interestRate);
        dateOfNextBill = dateOfNextBill + 2629743;
        totalValuePayed += billValue;
        numberOfBillsPayed ++;
        listOfBills.push(bill(dateOfNextBill, billValue, now, msg.value, true));
        seller.transfer(address(this).balance);
        emit Payment();
    }
    
    function carOn () public {
        require (msg.sender == car);
        require (carBlocked == false);
        vehicleOff = false;
    }
    
    function carOff () public {
        require (msg.sender == car);
        vehicleOff = true;
    }
    
    function notificationForLate() OnlySeller public {
        require (now >= dateOfNextBill);
        dateOfLastNotification = now;
        notificatedForLate = true;
        emit Notification();
    }
    
    function blockVehicle() OnlySeller public {
        require (now >= dateOfLastNotification+604800);
        require (vehicleOff == true);
        carBlocked = true;
        emit vehicleBlocked();
    }
    
    function unblockVehicle() OnlySeller public {
        require (now >= dateOfNextBill);
        require (carBlocked == true);
        dateOfLastNotification = 0;
        notificatedForLate = false;
        carBlocked = false;
        emit vehicleUnblocked();
    }
    
}
