pragma solidity 0.5.1;

contract VoyageCharterPartyWithArbitrator {
    
    address payable armador;
    address payable arbitro;
    uint public dataDePartidaPrevista;
    uint public dataDeChegadaPrevista;
    uint public dataDePartida;
    uint public dataDeChegada;
    uint public diasDeAtraso;
    uint public valorDoFrete;
    uint public valorTotalDosFretes;
    uint public totalDeContainers;
    uint public numeroDeContainers;
    uint public multaDiariaPorAtraso;
    uint public multaPorCancelamentoDoNavio;
    uint public multaPorCancelamentoDoContainer;
    uint public honorariosDeArbitragem;
    uint public valorTotalDasArbitragens;
    uint public TotalDosHonorariosDeArbitragem;
    bool arbitragemEncerrada;
    
    container [] public listaDeContainers;
    
    enum State {Fechado , Aberto, Armado, Desembarcado, Finalizado}
    State public state;
    
    struct container {
        address payable walletAfretador;
        uint valorDaMercadoria;
        uint valorDoFreteDoContainer;
        bool containerAtivo;
        uint valorDoReembolso;
        bool arbitragem;
        uint resultadoDaDisputa;
        bool arbitragemPaga;
    }
    
    constructor(
        address payable _walletArbitro,
        uint _dataDePartidaPrevista,
        uint _dataDeChegadaPrevista,
        uint _totalDeContainers,
        uint _valorDoFrete0a100SobreAMercadoria,
        uint _multaDiariaPorAtraso0a100doValorDoFrete,
        uint _multaPorCancelamentoDoNavio0a100doValorDoFrete,
        uint _multaPorCancelamentoDoContainer0a100doValorDoFrete,
        uint _honorariosDeArbitragem
        ) public payable
    {
        armador = msg.sender;
        arbitro = _walletArbitro;
        dataDePartidaPrevista = _dataDePartidaPrevista;
        dataDeChegadaPrevista = _dataDeChegadaPrevista;
        totalDeContainers = _totalDeContainers;
        valorDoFrete = _valorDoFrete0a100SobreAMercadoria;
        multaDiariaPorAtraso = _multaDiariaPorAtraso0a100doValorDoFrete;
        multaPorCancelamentoDoNavio = _multaPorCancelamentoDoNavio0a100doValorDoFrete;
        multaPorCancelamentoDoContainer = _multaPorCancelamentoDoContainer0a100doValorDoFrete;
        arbitragemEncerrada = false;
        honorariosDeArbitragem = _honorariosDeArbitragem;
        state = State.Aberto;
    }
    
    // modificador de estado
    
    modifier inState(State _state) {
        require(state == _state, "Invalid state.");
        _;
    }
    
    // Reserva e cancelamento
    
    function calculoDoValorDoFrete(uint _valorDaMercadoria) public view returns (uint) {
        return (valorDoFrete/100)*_valorDaMercadoria;
    }
    
    function alugarContainer(address payable _walletProprietario,uint _valorDaMercadoria) inState(State.Aberto) public payable {
        require(numeroDeContainers < totalDeContainers, "Embarcacao Completa.");
        require(msg.value == valorDoFrete*_valorDaMercadoria/100, "Valor incorreto.");
        require(now < dataDePartida, "Embarcacao Fechada.");
        numeroDeContainers += 1;
        valorTotalDosFretes += msg.value;
        listaDeContainers.push(container(_walletProprietario, _valorDaMercadoria, valorDoFrete*_valorDaMercadoria/100, true, 0, false, 0, false));
    }
    
    //function cancelarViagem() inState(State.Aberto) public payable {
        //require(msg.sender == armador, "Somente o despachante pode fazer isso.");
        //require(msg.value == multaPorCancelamentoDoNavio*valorTotalDosFretes/100);
        //listaDeContainers.containerAtivo = false;
        //container.walletProprietario.transfer(address(this).balance/numeroDeContainers);
    //}
    
    //function cancelarReserva(uint identidadeDoContainer) inState(State.Aberto) public payable {
        //container memory containerCancelado = container[identidadeDoContainer];
        //require (msg.sender == containerCancelado.walletProprietario, "Somente o afretador pode fazer isso.");
        //containerCancelado.containerAtivo = false;
        //containerCancelado.valorDoReembolso = multaPorCancelamentoDoContainer*containerCancelado.valorDoFrete/100;
        //containerCancelado.walletAfretador.transfer(containerCancelado.valorDoReembolso);
        //numeroDeContainers -= 1;
        //valorTotalDosFretes -= container.valorDoFrete;
    //}
    
    // Viagem
    
    function armarNavio() inState(State.Aberto) public {
        require(msg.sender == armador, "Somente o armador pode fazer isso.");
        dataDePartida = now;
        state = State.Armado;
    }
        
    function desembarcarNavio () inState(State.Armado) public {
        require(msg.sender == armador, "Somente o armador pode fazer isso.");
        dataDeChegada = now;
        state = State.Desembarcado;
    }
    
    //Arbitragem - deve ser usada antes do rateio
    
    //function arbitragemDoContainer( uint identidadeDoContainer, uint valorDaMercadoriaRecebido) inState(State.Desembarcado) public {
        //require (msg.sender == arbitro);
        //require (container.arbitragemDoContainer = false);
        //require (container.containerAtivo = true);
        //container memory resultadoDaDisputa = container[identidadeDoContainer];
        //resultadoDaDisputa = container.valorDaMercadoria - valorDaMercadoriaRecebido;
        //valorTotalDasArbitragens += resultadoDaDisputa;
        //TotalDosHonorariosDeArbitragem += honorariosDeArbitragem;
    //}
    
    //function calcularValorTotalDaArbitragem() public view returns (uint) {
        //return valorTotalDasArbitragens+TotalDosHonorariosDeArbitragem;
    //}
    
    //function pagarArbitragemDosContainers () inState(State.Desembarcado) public payable {
        //require (msg.sender == armador, "Somente o armador pode fazer isso.");
        //require (msg.value == valorTotalDasArbitragens+TotalDosHonorariosDeArbitragem);
        //for (uint i=0; i<container.length; i++) {
        //    container memory containerArbitrado = container[i];
        //    if (containerArbitrado.arbitragem = true) {
        //        containerArbitrado.walletAfretador.transfer(containerArbitrado.resultadoDaDisputa);
        //        containerArbitrado.arbitragemPaga = true;
        //    }
    //    }
    //    arbitragemEncerrada = true;
    //}
    
    // Pagar Viagem Sem Multa
    
    function pagarViagemSemMulta() inState(State.Desembarcado) public payable {
        require(msg.sender == armador, "Somente o armador pode fazer isso.");
        require(dataDeChegada <= dataDeChegadaPrevista, "Desembarque fora do Periodo.");
        //require(arbitragemEncerrada == true, "A arbitragem deve ser encerrada primeiro.");
        armador.transfer(address(this).balance);
    }
    
    // Pagar Viagem Com Multa
    
    function calculoDaMultaPorAtraso() public returns (uint256) {
        diasDeAtraso = dataDeChegadaPrevista-dataDeChegada/86400;
        return valorTotalDosFretes*multaDiariaPorAtraso*diasDeAtraso;
    }
    
    //function navioDesembarcadoForaDoPeriodo () public payable {
        //require(msg.sender == armador, "Somente o despachante pode fazer isso.");
        //require(dataDeChegada > dataDeChegadaPrevista, "Desembarque fora do Periodo.");
        //require(arbitragemEncerrada == true, "A arbitregem deve ser paga primeiro.");
        //require(msg.value == valorTotalDosFretes*multaDiariaPorAtraso*diasDeAtraso);
        //diasDeAtraso = dataDeChegadaPrevista-dataDeChegada-dataDeChegada/86400;
        //calculoDaMultaPorAtraso = multaDiariaPorAtraso/numeroDeContainers;
        //for (uint i=0; i<container.length; i++) {
            //container memory containerAtrasado = container[i];
            //if (containerAtrasado.arbitragem = false) {
            //    containerAtrasado.walletAfretador.transfer(containerAtrasado.resultadoDaDisputa);
            //    containerAtrasado.arbitragemPaga = true;  
            //}
        //}
        //armador.transfer(address(this).balance);
    //}
}
