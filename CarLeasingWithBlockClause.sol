pragma solidity 0.5.1.;

contract BuyACar {
    address payable seller;
    address payable buyer;
    address car;
    uint256 public totalValue;
    uint256 public totalValuePayed;
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
        numberOfBillsOpen = numberOfBills-numberOfBillsPayed;
        dateOfNextBill = _dateOfFirstBill;
        notificatedForLate = false;
        carBlocked = false;
        vehicleOff = true;
    }
    
    
    function payACar () public payable {
        require (dateOfNextBill<= now);
        require (msg.value == billValue);
        require (msg.sender == buyer);
        dateOfNextBill = dateOfNextBill + 2629743;
        totalValuePayed += billValue;
        numberOfBillsPayed ++;
        listOfBills.push(bill(dateOfNextBill, billValue, now, msg.value, true));
        seller.transfer(address(this).balance);
        emit Payment();
    }
    
    function payACarWithLate () public payable {
        require (dateOfNextBill>= now);
        require (msg.value == billValue+interestRate);
        require (msg.sender == buyer);
        dateOfLastBill = now;
        dateOfNextBill = dateOfNextBill + 2629743;
        totalValuePayed += billValue;
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
    
    function notificationForLate() public {
        require (msg.sender == seller);
        require (now >= dateOfNextBill+604800);
        dateOfLastNotification = now;
        notificatedForLate = true;
        emit Notification();
    }
    
    function blockVehicle() public {
        require (msg.sender == seller);
        require (now >= dateOfLastNotification+604800);
        require (vehicleOff == true);
        carBlocked = true;
        emit vehicleBlocked();
    }
    
    function unblockVehicle() public {
        require (msg.sender == seller);
        require (now >= dateOfNextBill);
        require (carBlocked == true);
        dateOfLastNotification = 0;
        notificatedForLate = false;
        carBlocked = false;
        emit vehicleUnblocked();
    }
    
}
    
