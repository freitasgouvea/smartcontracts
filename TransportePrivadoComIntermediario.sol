pragma solidity 0.5.1;

contract TransportePrivado {
    
    address payable intermediary;
    address payable driver;
    uint256 driverLicence;
    uint256 carLicence;
    uint256 public intermediaryFee;
    uint256 public driverFee;
    uint256 public numberOfTrips;
    uint256 public averageEvaluation = 100;
    uint256 public balance;

    trip [] public listOfTrips;
    
    struct trip {
        address passenger;
        //uint256 dateOfStart;
        //string localOfDeparture;
        string localOfArrive;
        uint256 dateOfFinish;
        uint256 driverEvaluation;
        bool tripFinished;
        uint256 serviceValue;
    }
    
    enum State { Unasigned, Avaiable, Stoped, End }
    State public state;
    
    event ApplicationInCourse();
    event DriverAutorized();
    event TripCompleted();
    event DriverPayed();
    event CancellationIncourse();
    event intermediaryReativateContract();
    event ContractFinished();
    
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
    
    function applyForDriving(uint256 _driverLicence, uint256 _carLicence) public {
        //require (driverLicence) hash da cnh
        //require (carLicence) hash do doc. carro
        driverLicence = _driverLicence;
        carLicence = _carLicence;
        driver = msg.sender;
        state = State.Unasigned;
        emit ApplicationInCourse();
        }
    
    function autorizeDriver() public {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        numberOfTrips = 0;
        emit DriverAutorized();
        state = State.Avaiable;
    }
    
    //function callForATrip()
    
    //function callForADisputeResolution()
    
    function payForATrip(string memory _localOfArrive, uint _driverEvaluation0to100) inState(State.Avaiable) public payable {
        //require(msg.value == valor da corrida )
        require (_driverEvaluation0to100 <= 100, "A avaliacao tem que ser de 0 a 100");
        numberOfTrips += 1;
        listOfTrips.push(trip(msg.sender, _localOfArrive, now, _driverEvaluation0to100, true, msg.value));
        averageEvaluation = ((((averageEvaluation+_driverEvaluation0to100)*numberOfTrips)/numberOfTrips)/numberOfTrips);
        balance += msg.value;
        emit TripCompleted ();
    }
    
    function payDriver() inState(State.Avaiable) public payable {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        intermediary.transfer(balance*intermediaryFee/100);
        driver.transfer(balance*driverFee/100);
        balance = - msg.value;
    }
    
    function driverCancellContract() inState(State.Avaiable) public payable {
        require(msg.sender == driver, "Somente o motorista pode fazer isso.");
        state = State.Stoped;
        emit CancellationIncourse();
    }
    
    function reativateContract() inState(State.Stoped) public payable {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        state = State.Avaiable;
        emit intermediaryReativateContract();
    }
    
    function intermediaryCancellContract() inState(State.Avaiable) public {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        require(averageEvaluation == 60);
        require(numberOfTrips >= 10);
        require(balance == 0);
        state = State.End;
    }
}
