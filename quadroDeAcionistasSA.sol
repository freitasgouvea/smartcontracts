pragma solidity 0.5.1.;

contract alienacaoSocietaria {
    address payable advogado;
    string nomeDaSociedade;
    uint256 capitalSocial;
    uint256 valorDaAcao;
    uint256 numeroDeAcoes;

    acionista [] listaDeAcionistas;
    alienacao [] listaDeAlienacoes;
    
    struct acionista {
        string nomeAcionista;
        uint256 cpfAcionista;
        address payable acionistaWallet;
        uint256 numeroDeAcoes;
    }
    
    struct alienacao {
        address payable vendedorWallet;
        address payable compradorWallet;
        uint256 quantidadeDeAcoes;
        uint256 prazoParaAOperacao;
        uint256 valorDaOperacao;
        uint256 dataDaOperacao;
    }
    
    constructor (string memory _nomeDaSociedade, uint256 _capitalSocial, uint256 _numeroDeAcoes, uint256 _valorDaAcao) public {
        advogado =  msg.sender;
        nomeDaSociedade = _nomeDaSociedade;
        capitalSocial = _capitalSocial;
        numeroDeAcoes = _numeroDeAcoes;
        valorDaAcao = _valorDaAcao;
    }
    
    function registrarAcionista(string memory _nome, uint256 _cpf, address payable _wallet, uint256 _numeroDeAcoes) public {
        require (msg.sender == advogado);
        listaDeAcionistas.push(acionista(_nome, _cpf, _wallet, _numeroDeAcoes));
    }
    
    function autorizarAlienacao(uint256 _idVendedor, uint256 _idComprador, uint256 _acoesAlienadas, uint256 _prazoParaAOperacao) public {
        require (msg.sender == listaDeAcionistas[_idVendedor].acionistaWallet);
        require (_acoesAlienadas <= listaDeAcionistas[_idVendedor].numeroDeAcoes);
        listaDeAlienacoes.push(alienacao(listaDeAcionistas[_idComprador].acionistaWallet, listaDeAcionistas[_idVendedor].acionistaWallet, _acoesAlienadas, _acoesAlienadas*valorDaAcao, _prazoParaAOperacao, 0 ));
    }
    
    function pagarAlienacao(uint256 _idAlienacao, uint256 _idVendedor, uint256 _idComprador) public payable {
        require (msg.sender == listaDeAlienacoes[_idAlienacao].compradorWallet);
        require (now <= listaDeAlienacoes[_idAlienacao].prazoParaAOperacao);
        require (msg.value == listaDeAlienacoes[_idAlienacao].valorDaOperacao);
        listaDeAcionistas[_idVendedor].numeroDeAcoes -= listaDeAlienacoes[_idAlienacao].quantidadeDeAcoes;
        listaDeAcionistas[_idComprador].numeroDeAcoes += listaDeAlienacoes[_idAlienacao].quantidadeDeAcoes;
        listaDeAlienacoes[_idAlienacao].vendedorWallet.transfer(msg.value);
        listaDeAlienacoes[_idAlienacao].dataDaOperacao = now;
    }
}
