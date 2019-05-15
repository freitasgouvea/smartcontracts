pragma solidity 0.5.1;

contract TransporteMaritimo {
    
    address payable despachante;
    address payable proprietarioDoNavio;
    uint public dataDePartida;
    string destino;
    uint public dataDeChegada;
    uint public value;
    uint public valorDoAluguelDoContainer;
    uint public comissaoDoDespachante;
    uint public totalDeContainers;
    uint public numeroDeContainers = 0;
        
    struct container {
        address payable walletProprietario;
        string produto;
        uint quantidade;
        uint valorDaMercadoria;
    }
    
    mapping (uint => container) public listaDeContainers;
    
    constructor(
        address payable _walletDonoDoNavio,
        uint _dataDePartida,
        string memory _destino,
        uint _valorDoAluguelDoContainer,
        uint _totalDeContainers,
        uint _comissaoDoDespachante
        ) public payable
        {
        despachante = msg.sender;
        proprietarioDoNavio = _walletDonoDoNavio;
        dataDePartida = _dataDePartida;
        destino = _destino;
        totalDeContainers = _totalDeContainers;
        valorDoAluguelDoContainer = _valorDoAluguelDoContainer;
        comissaoDoDespachante = _comissaoDoDespachante;
    }
    
    function alugarContainer(
        address payable _walletProprietario,
        string memory _produto,
        uint _quantidade,
        uint _valorDaMercadoria
        ) 
        public payable 
        {
        require(numeroDeContainers < totalDeContainers, "Embarcacao Completa.");
        require(msg.value == valorDoAluguelDoContainer, "Valor incorreto.");
        require(now < dataDePartida, "Embarcacao Completa.");
        value += msg.value;
        numeroDeContainers += 1;
        listaDeContainers[numeroDeContainers] = container(_walletProprietario, _produto, _quantidade, _valorDaMercadoria );
    }
    
    //function cancelarContrato(
        //) public payable {
        //require(msg.sender == despachante, "Somente o despachante pode fazer isso.");
        //container.walletProprietario.transfer(address(this).balance/numeroDeContainers);
        //}
    
    function navioChegouAoDestino ()
        public payable {
        require(msg.sender == despachante, "Somente o despachante pode fazer isso.");
        dataDeChegada = now;
        despachante.transfer(value*(comissaoDoDespachante/100));
        proprietarioDoNavio.transfer(address(this).balance);
    }
    
}
