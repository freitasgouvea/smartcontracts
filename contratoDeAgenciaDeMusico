pragma solidity 0.5.1;

contract AgenciaArtistica {
    
    //fases do contrato de agencia
    
    enum State { 
        Proposta,
        Agenciado, 
        Finalizado 
        }
    State public state;
    
    // artista e agente: partes do contrato de agencia
    
    address payable public artista;
    address payable public agente;
    
    // comissaoAgente: porcentagem do agente sobre o valor do evento (ex: 20% = 20)
    // remuneracaoArtista: porcentagem do artista sobre o valor so evento (ex: 80% = 100) 
    // fixoAgente: honorarios anuais para o agente (em weis)


    uint public porcentagemArtista;
    uint public porcentagemAgente;
    uint public fixoAgente;


    // tempo: periodo pre-estabelecido de duracao do contrato agencia (em segundos)
    // prazo: periodo de vigencia do contrato de agencia apos a contratacao (data da assinatura + duracao)
    // multa: valor da multa em caso de rescisao do contrato de agencia
    
    uint public duracaoDoContrato;
    uint public fimDoContrato;
    uint public multaDeRescisao;
    
    // cache: pagamento por um show
    // comissaoAgente: valor do cache que vai para o agente
    // remuneracaoArtista: valor do cache que vai para o artista
    // Podem ser contratados um número ilimitado de shows
    
    uint public cache;
    uint public remuneracaoArtista;
    
    // Apresentacoes e Prestacao de contas
    
    uint showCount = 0;
    
    mapping(uint => Apresentacao) public shows;
    
    struct Apresentacao {
        string _evento;
        uint _dataDoEvento;
        uint _cache;
        address _contratante;
    }
    
    // Criacao do Contrato de Agencia
    
    constructor(
        address payable _artista,
        uint _valorDaMulta,
        uint _porcetagemDoAgente,
        uint _porcentagemDoArtista,
        uint _honorariosFixosPorMes
        ) public payable
        {
        agente = msg.sender;
        artista = _artista;
        multaDeRescisao = _valorDaMulta;
        porcentagemAgente = _porcetagemDoAgente;
        porcentagemArtista = _porcentagemDoArtista;
        fixoAgente = _honorariosFixosPorMes;
    }
    
    //modificadores
    
    modifier condition(bool _condition) {
        require(_condition);
        _;
    }


    modifier onlyArtista() {
        require(msg.sender == artista,
            "Somente o artista pode fazer isso."
        );
        _;
    }


    modifier onlyAgente() {
        require(msg.sender == agente,
            "Somente o agente pode fazer isso."
        );
        _;
    }
    
    modifier inState(State _state) {
        require(state == _state,
            "Não foi possivel completar a sua transacao."
        );
        _;
    }
    
    // Contratar Agente
    // Somente o Artista
    // Requer o valor do fixo * numero de meses 
    
    event Agencia();
    
    function iniciarAgencia(
        uint _valorDoCache,
        uint _mesesDeduracaoDoContrato
        )
        onlyArtista
        inState(State.Proposta)
        condition(msg.value == fixoAgente*_mesesDeduracaoDoContrato)
        public
        payable
        {
        cache = _valorDoCache;
        duracaoDoContrato = _mesesDeduracaoDoContrato*2629743;
        fimDoContrato = now + duracaoDoContrato;
        emit Agencia();
        state = State.Agenciado;
        agente.transfer(address(this).balance);
    }
    
    // Contratar uma nova apresentacao
    // Receber cache de um Show
    // Qualquer pessoa pode pagar
    // Requer o valor do cache
    
    function contratarArtista(
        string memory _evento, 
        uint  _dataDoEvento,
        uint  _valor
        )
        public
        inState(State.Agenciado)
        condition(msg.value == cache)
        payable
        {
        showCount += 1;
        shows[showCount] = Apresentacao (
            _evento, 
            _dataDoEvento, 
            _valor, 
            msg.sender
            );
        remuneracaoArtista = remuneracaoArtista + (msg.value*porcentagemArtista)/100;
        agente.transfer(address(this).balance);
    }
    
    // Pagar Remuneracao ao Artista
    // Somente o agente
    // O valor da comissao ja esta descontado porque a carteira que recebe o cache é do agente
    // Requer o valor da remuneração atualizado
    
    function pagarArtista()
        public
        onlyAgente
        condition(msg.value == remuneracaoArtista)
        payable
        {
        remuneracaoArtista = remuneracaoArtista - msg.value;
        artista.transfer(address(this).balance);
    }
    
    //Rescisao do contrato de agencia durante o periodo de vigencia minima (com multa)
    
    event Rescisao();
    
    function recindirContratoComAgente()
        public
        onlyArtista
        inState(State.Agenciado)
        condition(msg.value == multaDeRescisao)
        condition(now<=fimDoContrato)
        payable
        {
        emit Rescisao();
        state = State.Finalizado;
        agente.transfer(address(this).balance);
    }
    
    function rescindirContratoComArtista()
        public
        onlyAgente
        inState(State.Agenciado)
        condition(msg.value == multaDeRescisao)
        condition(now<=fimDoContrato)
        payable
        {
        emit Rescisao();
        state = State.Finalizado;
        artista.transfer(address(this).balance);
    }
    
    //Rescisao do contrato de agencia depois do periodo de vigencia minima (sem multa)
    
    event Terminar();
    
        function terminarContrato()
        public
        onlyAgente
        onlyArtista
        inState(State.Agenciado)
        condition(now>=fimDoContrato)
        {
        emit Terminar();
        state = State.Finalizado;
    }
    
    // nao consegui estabelecer pagamentos a mais de uma carteira simultanea
    
}
