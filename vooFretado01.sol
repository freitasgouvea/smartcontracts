pragma solidity 0.5.1;

contract VooFretado {
    
    address payable airComapny;
    address payable agency;
    uint value;
    uint agencyFee;
    uint public ticketValue;
    uint public numberOfFlight;
    uint public dateOfFlight;
    uint public numberOfTickets;
    uint public passengerCount = 0;
    address payable wallet;
    
    mapping(uint => passenger) public passengers;
    mapping(address => passenger) public buyers;

    enum State { Created, Open , End }
    State public state;
    
    // Registrer of the passengers
    
    struct passenger {
        string _name;
        string _email;
        uint _phone;
        uint _id;
        address payable wallet;
    }
    
    // Constructor
    
    constructor( 
        address payable _agencyWallet,
        uint _numberOfFlight,
        uint _dateOfFlight,
        uint _ticketValue,
        uint _agencyFee,
        uint _numberOfTickets
        ) public payable
        {
        airComapny = msg.sender;
        agency = _agencyWallet;
        numberOfFlight = _numberOfFlight;
        dateOfFlight = _dateOfFlight;
        ticketValue = _ticketValue;
        agencyFee = _agencyFee/100;
        numberOfTickets = _numberOfTickets;
        state = State.Open;
    }

    // modifiers

    modifier onlyAirCompany() {
        require(msg.sender == airComapny, "Only Air Company can do this");
        _;
    }
    
    modifier inState(State _state) {
        require(state == _state, "Invalid state.");
        _;
    }
    
    // Ticket Sell
    
    function buyTicket(
        string memory _name, 
        string memory _email, 
        uint _phone,
        uint _id
        ) 
        inState(State.Open)
        public payable 
        {
        require(passengerCount < numberOfTickets, "Voo encerrado.");
        require(msg.value == ticketValue, "Valor incorreto.");
        require(now <= dateOfFlight, "Voo enecerrado");
        passengerCount += 1;
        passengers[passengerCount] = passenger ( _name, _email, _phone, _id, msg.sender);
    }
    
    // Events in contract
    
    event FlightCancelled();
    
    function cancellFlight()
        inState(State.Open)
        onlyAirCompany
        public
        payable
        {
        emit FlightCancelled();
        state = State.End;
        wallet.transfer(address(this).balance/passengerCount);
    }
    
    // event FlightClosed();
    
    event FlightArrived();
    
    function payFlight()
        inState(State.Open)
        onlyAirCompany
        public
        payable
        {
        emit FlightArrived();
        state = State.End;
        agency.transfer(address(this).balance*agencyFee);
        airComapny.transfer(address(this).balance);
    }
    
}
