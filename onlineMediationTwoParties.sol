pragma solidity 0.5.1;

contract MediacaoOnline {
    
    address payable party01;
    address payable party02;
    address payable mediator;
    string disputeObject;
    uint256 disputeValue;
    uint256 mediationFee;
    uint256 value;
    uint256 dateOfCall;
    uint256 dateOfInvite;
    uint256 deadlineOfInvite;
    uint256 dateOfStart;
    uint256 deadlineOfMediation;
    uint256 dateOfAgreement;
    uint256 dataOfFinishes;
    //string stage;
    //string result;
    //string mediationTerm;
    //string hashOfMediationTerm;
    
    // Stages of mediation
    
    enum State { Created, Premediation, Mediation, End }
    State public state;

    // Events in Mediation
    
    event Creation();
    event Invite();
    event InviteFail();
    event MediationStarts();
    event MediationFinishesWithDeal();
    event MediationFinishesWithoutDeal();
    
    // Registrer of the parties
    
    struct PartiesReg {
        string _name;
        string _email;
        uint _phone;
        uint _id;
        address _wallet;
    }
    
    uint partyCount = 0;
    mapping(uint => PartiesReg) public parties;
    
    //constructor
    
    constructor(
        uint256 _mediationFee
        ) public payable
        {
        mediator = msg.sender;
        mediationFee = _mediationFee;
        emit Creation();
        state = State.Created;
    }
    
    // mediation info
    
    function mediationBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    function showMediationFee() public view returns (uint) {
        return mediationFee;
    }
    
    function showDisputeValue() public view returns (uint) {
        return disputeValue;
    }
    
    //modifiers
    
    modifier condition(bool _condition) {
        require(_condition);
        _;
    }

    modifier onlyMediator() {
        require(msg.sender == mediator, "Only mediator can do this.");
        _;
    }

    modifier onlyParty01() {
        require(msg.sender == party01, "Only other party can do this");
        _;
    }
    
    modifier onlyParty02() {
        require(msg.sender == party02, "Only other party can do this");
        _;
    }
    
    modifier inState(State _state) {
        require(state == _state, "Invalid state.");
        _;
    }
    
    //Call for Mediation
    
    function callForMediation(
        uint256 _disputeValue,
        string memory _disputeObject, 
        string memory _name, 
        string memory _email, 
        uint _phone, 
        uint _id, 
        address _wallet
        )
        inState(State.Created)
        condition(msg.value == (_disputeValue+(mediationFee/2)))
        public
        payable
        {
        party01 = msg.sender;
        disputeValue = _disputeValue;
        disputeObject = _disputeObject;
        partyCount += 1;
        parties[partyCount] = PartiesReg ( _name, _email, _phone, _id, _wallet);
        dateOfCall = now;
        deadlineOfInvite = now + 604800;
        emit Invite();
        state = State.Premediation;
    }
    
    // Other Party Rejects Mediation
    
    function rejectMediation(
        string memory _name, 
        string memory _email, 
        uint _phone, 
        uint _id, 
        address _wallet
        )
        inState(State.Premediation)
        public
        payable
        {
        party02 = msg.sender;
        dataOfFinishes = now;
        partyCount += 1;
        parties[partyCount] = PartiesReg ( _name, _email, _phone, _id, _wallet);
        emit InviteFail();
        state = State.End;
        party01.transfer(address(this).balance);
    }
    
    // Other Not Ansewer Mediation
    
    function unansweredInvite()
        inState(State.Premediation)
        onlyMediator
        condition(now > deadlineOfInvite)
        public
        payable
        {
        dataOfFinishes = now;
        emit InviteFail();
        state = State.End;
        party01.transfer(address(this).balance);
    }
    
    // Other Party Accept Mediadtion
    
    function acceptMediation(
        string memory _name, 
        string memory _email, 
        uint _phone, 
        uint _id, 
        address _wallet
        )
        inState(State.Premediation)
        condition(msg.value == (disputeValue+(mediationFee/2)))
        public
        payable
        {
        party02 = msg.sender;
        dateOfStart = now;
        deadlineOfMediation = now + 604800;
        partyCount += 1;
        parties[partyCount] = PartiesReg ( _name, _email, _phone, _id, _wallet);
        emit MediationStarts();
        state = State.Mediation;
        mediator.transfer(mediationFee);
    }
    
    // Put mediationTerm sign phase and hashOfMediationTerm
    
    //function testStr(string str) constant returns (bool){
        //bytes memory b = bytes(str);
        //if(b.length > 13) return false;
        //for(uint i; i < b.length; i++){
            //test if is tring only contains 1234567890abcdefghijklmnopqrstuvwxyz and . char
        //}
        //return true;
    //}
    
    // Mediation finishes with agreement
    
    function agreementForParty01()
        inState(State.Mediation)
        onlyMediator
        public
        payable
        {
        dateOfAgreement = now;
        dataOfFinishes = now;
        emit MediationFinishesWithDeal();
        state = State.End;
        party01.transfer(address(this).balance);
    }
    
    function agreementForParty02()
        inState(State.Mediation)
        onlyMediator
        public
        payable
        {
        dateOfAgreement = now;
        dataOfFinishes = now;
        emit MediationFinishesWithDeal();
        state = State.End;
        party02.transfer(address(this).balance);
    }
    
    // Mediation finishes without agreement
    
    function finishWithoutDeal()
        inState(State.Mediation)
        onlyMediator
        condition(now > deadlineOfMediation)
        public
        payable
        {
        dataOfFinishes = now;
        emit MediationFinishesWithoutDeal();
        state = State.End;
        party01.transfer(address(this).balance/2);
        party02.transfer(address(this).balance/2);
    }
    
} 
