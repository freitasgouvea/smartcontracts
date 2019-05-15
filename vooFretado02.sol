pragma solidity 0.5.1;

contract VooFretado {
    
    address payable airComapny;
    uint value;
    uint agencyFee;
    uint airCompanyFee;
    uint public ticketValue;
    uint public numberOfFlight;
    uint public dateOfFlight;
    uint public numberOfTickets;
    uint public passengerCount = 0;
    uint public agencyCount = 0;
    
    mapping(uint => passenger) public passengers;
    mapping(uint => agency) public agencies;

    enum State { Created, Open , End }
    State public state;
    
    // Registrers
    
    struct passenger {
        address payable passengerWallet;
        address payable agencyWallet;
        string passengerName;
        bool reembolsoPago;
    }
    
    struct agency {
        address payable agencyWallet;
        string agencyName;
        uint passagensVendidas;
        bool comissaoPaga;
    }
    
    // Constructor
    
    constructor( 
        address payable _agencyWallet,
        uint _numberOfFlight,
        uint _dateOfFlight,
        uint _ticketValue,
        uint _airCompanyFee,
        uint _agencyFee,
        uint _numberOfTickets
        ) public payable
        {
        airComapny = msg.sender;
        numberOfFlight = _numberOfFlight;
        dateOfFlight = _dateOfFlight;
        ticketValue = _ticketValue;
        airCompanyFee = _airCompanyFee;
        agencyFee = _agencyFee;
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
    
    // Registrer Agency
    
    function registrerAgency(
        address payable agencyWallet, 
        string memory agencyName,
        uint passagensVendidas,
        bool comissaoPaga
        ) 
        onlyAirCompany
        inState(State.Open)
        public 
        {
        agencyCount += 1;
        agencies[agencyCount] = agency (agencyWallet, agencyName,passagensVendidas = 0 ,comissaoPaga = false);
    }
    
    // Ticket Sell
    
    function buyTicket(
        address payable passengerWallet,
        string memory passengerName, 
        uint agencyId,
        bool reembolsoPago
        ) 
        inState(State.Open)
        public payable 
        {
        require(passengerCount < numberOfTickets, "Voo encerrado.");
        require(msg.value == ticketValue, "Valor incorreto.");
        require(now <= dateOfFlight, "Voo enecerrado");
        passengerCount + 1;
        passengers[passengerCount] = passenger(passengerWallet, passengerName, reembolsoPago=false );
        agencies[agencyId] = agency(passagensVendidas + 1);
    }
    
    // Events in contract
    
    //event FlightCancelled();
    
    //function cancellFlight()
        //inState(State.Open)
        //onlyAirCompany
        //public
        //payable
        //{
        //emit FlightCancelled();
        //state = State.End;
        //passenger.passengerWallet.transfer(address(this).balance/passengerCount);
        //for (uint i=0; i < passengers.lenght; i++) {
            //passenger memory passengerCashBack = passeng [i];
            //if (!passengerCashBack.);
        //}
    //}
    
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
        airComapny.transfer(address(this).balance*airCompanyFee/100);
        for (uint i=0; i < agencies.lenght; i++) {
            agency memory agencyPayFee = agency [i];
            if (!agencyPayFee.comissaoPaga) {
                agency.agencyWallet.transfer(address(this).balance*(agencyFee/100));
                agency.comissaoPaga = true;
            }
        }
    }
}
