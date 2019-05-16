pragma solidity 0.5.1;

contract TransportePrivado {
    address payable intermediary;
    address payable driver;
    uint256 driverLicence;
    uint256 public intermediaryFee;
    uint256 public driverFee;
    uint256 public numberOfTrips;
    //uint256 public averageEvaluation;
    uint256 public balance;

    mapping (uint256 => trip) public listOfTrips;
    mapping (address => trip) public listOfPassengers;
    
    struct trip {
        address passenger;
        string localOfArrive;
        uint256 dateOfFinish;
        uint256 driverEvaluation;
        bool serviceFinished;
        uint256 serviceValue;
    }
    
    enum State { Unasigned, Avaiable, Closed}
    State public state;
    
    modifier inState(State _state) {
        require(state == _state,
            "Invalid state."
        );
        _;
    }
    
    constructor(uint256 _intermediaryFee,uint256 _driverFee) public {
        intermediary = msg.sender;
        intermediaryFee = _intermediaryFee;
        driverFee = _driverFee;
        state = State.Unasigned;
    }
    
    function assingForDriving(uint256 _driverLicence) public {
        //require (driverLicence) hash da cnh
        driverLicence = _driverLicence;
        driver = msg.sender;
        numberOfTrips = 0;
        //averageEvaluation = 5;
        balance = 0;
        state = State.Unasigned;
        }
    
    event DriverAutorized();
    
    function autorizeDriver() public {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        emit DriverAutorized();
        state = State.Avaiable;
    }
    
    //function callForATrip()
    
    event TripPayed();
    
    function payForATrip(string memory _localOfArrive, uint _driverEvaluation) inState(State.Avaiable) public payable {
        //require(msg.value == valor da corrida )
        numberOfTrips += 1;
        balance += msg.value;
        //averageEvaluation = _driverEvaluation*numberOfTrips/numberOfTrips;
        listOfTrips[numberOfTrips] = trip(msg.sender, _localOfArrive, now, _driverEvaluation, true, msg.value);
    }
    
    event DriverPayed();
    
    function payDriver() inState(State.Avaiable) public payable {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        intermediary.transfer(balance*intermediaryFee/100);
        driver.transfer(balance*driverFee/100);
        balance = - msg.value;
    }
}
