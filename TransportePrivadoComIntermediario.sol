pragma solidity 0.5.1;

contract TransportePrivado {
    
    address payable intermediary;
    address payable driver;
    uint256 driverLicence;
    uint256 carLicence;
    uint256 public intermediaryFee;
    uint256 public driverFee;
    uint256 public numberOfTrips;
    uint256 totalOfEvaluations;
    uint256 public averageEvaluation;
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
    event DriverSuspended();
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
    
    //function callForATrip();
    
    //function driverCancellTrip();
    
    //function passengerCancellTrip();
    
    function payForATrip(string memory _localOfArrive, uint _driverEvaluation0to100) inState(State.Avaiable) public payable {
        //require(msg.value == valor da corrida )
        require (_driverEvaluation0to100 <= 100, "A avaliacao tem que ser de 0 a 100");
        numberOfTrips += 1;
        listOfTrips.push(trip(msg.sender, _localOfArrive, now, _driverEvaluation0to100, true, msg.value));
        totalOfEvaluations += _driverEvaluation0to100;
        averageEvaluation = totalOfEvaluations/numberOfTrips;
        balance += msg.value;
        emit TripCompleted ();
    }
    
    function payDriver() inState(State.Avaiable) public payable {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        intermediary.transfer(balance*intermediaryFee/100);
        driver.transfer(balance*driverFee/100);
        balance = - msg.value;
    }
    
    function suspendDriver() inState(State.Avaiable) public  {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        state = State.Stoped;
        emit DriverSuspended();
    }
    
    function driverCancellContract() inState(State.Avaiable) public {
        require(msg.sender == driver, "Somente o motorista pode fazer isso.");
        state = State.Stoped;
        emit CancellationIncourse();
    }
    
    function reativateContract() inState(State.Stoped) public {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        state = State.Avaiable;
        emit intermediaryReativateContract();
    }
    
    function intermediaryCancellContract() inState(State.Avaiable) public {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        require(averageEvaluation >= 60);
        require(numberOfTrips >= 10);
        require(balance == 0);
        state = State.End;
    }
    
    //Dispute Resoluyion Events
    
    event DisputeReceived();
    event DisputeRejected();
    event DisputeSolved();
    
    function ZcallForADisputeResolution(uint _disputevalue, uint tripId) public {
        trip memory disputedTrip = listOfTrips[tripId];
        uint disputevalue = _disputevalue;
        require(msg.sender == disputedTrip.passenger, "Somente o passageiro pode fazer isso.");
        emit DisputeReceived();
    }
    
    function ZrejectDispute(uint tripId) public {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        emit DisputeRejected();
    }
    
    function ZreimbursePassenger(uint _arbitrationValue, uint tripId, address _reimburseAddress) public payable {
        require(msg.sender == intermediary, "Somente o intermediario pode fazer isso.");
        uint arbitrationValue = _arbitrationValue;
        address reimburseAddress = _reimburseAddress;
        trip memory disputedTrip = listOfTrips[tripId];
        require(_reimburseAddress == disputedTrip.passenger, "Somente o passageiro pode ser ressarcido.");
        //disputedTrip.passenger.transfer(arbitrationValue);
        emit DisputeSolved();
    }
}
