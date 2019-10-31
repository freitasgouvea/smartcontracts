pragma solidity 0.5.11.;

contract Boletos {

    address banco;
    mapping(bytes32 => Boleto) public listaDeBoletos;
    
    struct Boleto {
        address payable owner;
        string ownerID;
        address payable payer;
        string payerID;
        uint256 valorDoBoleto;
        uint256 vencimento;
        uint256 multaPorAtraso;
        uint256 jurosDeMora;
        uint256 dataDoPagamento;
        uint256 valorPago;
        bool ativo;
        bool pagamento;
    }

    event BoletoCriado(bytes32 indexed hashBoleto, address indexed owner, uint256 valorDoBoleto, uint256 vencimento);
    event BoletoPago(bytes32 indexed hashBoleto, address indexed owner, address indexed payer, uint256 valorPago, uint256 dataDoPagaemnto);
    
    constructor (
        address _banco
        ) public
    {
      banco = _banco;
    }
    
    function criarBoleto(
        string memory _ownerID,
        uint256 _valorDoBoleto,
        uint256 _vencimento,
        uint256 _multaPorAtraso,
        uint256 _jurosDeMoraPorDia
        )
        public
        returns (bytes32)
    {
        bytes32 hashBoleto = keccak256(abi.encodePacked(_ownerID, now));
        Boleto memory bn = Boleto(msg.sender, _ownerID, 0x0000000000000000000000000000000000000000, 'cpf/cnpj', _valorDoBoleto, _vencimento, _multaPorAtraso, _jurosDeMoraPorDia, 0, 0, true, false);
        listaDeBoletos[hashBoleto] = bn;
        emit BoletoCriado (hashBoleto, bn.owner, bn.valorDoBoleto, bn.vencimento);
        return hashBoleto;
    }
    
    function cancelarBoleto (bytes32 hashBoleto) public returns(bool) {
        Boleto storage bc = listaDeBoletos[hashBoleto];
        require(msg.sender == listaDeBoletos[hashBoleto].owner || msg.sender == banco);
        require(listaDeBoletos[hashBoleto].pagamento == false);
        bc.ativo = false;
        return (true);
    }
    
    function VerBoleto (bytes32 hashBoleto) public view returns(address, uint256, uint256,uint256) {
        if (now<listaDeBoletos[hashBoleto].vencimento) {
            uint256 valorAtualizado;  
            valorAtualizado= listaDeBoletos[hashBoleto].valorDoBoleto;
            return (listaDeBoletos[hashBoleto].owner, listaDeBoletos[hashBoleto].valorDoBoleto, listaDeBoletos[hashBoleto].vencimento, valorAtualizado);
        }
        else {
            uint256 valorAtualizado; 
            valorAtualizado= listaDeBoletos[hashBoleto].valorDoBoleto+((now-listaDeBoletos[hashBoleto].vencimento)/86400)*listaDeBoletos[hashBoleto].jurosDeMora+listaDeBoletos[hashBoleto].multaPorAtraso;
            return (listaDeBoletos[hashBoleto].owner, listaDeBoletos[hashBoleto].valorDoBoleto, listaDeBoletos[hashBoleto].vencimento, valorAtualizado);
        }
    }
    
        
    function pagarBoleto (bytes32 hashBoleto) public payable returns(bool) {
        if (now<listaDeBoletos[hashBoleto].vencimento) {
            uint256 valorAtualizado;  
            valorAtualizado= listaDeBoletos[hashBoleto].valorDoBoleto;
            require (msg.value == valorAtualizado);
            listaDeBoletos[hashBoleto].owner.transfer(msg.value);
            listaDeBoletos[hashBoleto].dataDoPagamento = now;
            listaDeBoletos[hashBoleto].valorPago = msg.value;
            listaDeBoletos[hashBoleto].pagamento = true;
            emit BoletoPago (hashBoleto, listaDeBoletos[hashBoleto].owner, listaDeBoletos[hashBoleto].payer, listaDeBoletos[hashBoleto].valorPago, listaDeBoletos[hashBoleto].dataDoPagamento);
        }
        else {
            uint256 valorAtualizado; 
            valorAtualizado= listaDeBoletos[hashBoleto].valorDoBoleto+((now-listaDeBoletos[hashBoleto].vencimento)/86400)*listaDeBoletos[hashBoleto].jurosDeMora+listaDeBoletos[hashBoleto].multaPorAtraso;
            require (msg.value == valorAtualizado);
            listaDeBoletos[hashBoleto].owner.transfer(msg.value);
            listaDeBoletos[hashBoleto].dataDoPagamento = now;
            listaDeBoletos[hashBoleto].valorPago = msg.value;
            listaDeBoletos[hashBoleto].pagamento = true;
            emit BoletoPago (hashBoleto, listaDeBoletos[hashBoleto].owner, listaDeBoletos[hashBoleto].payer, listaDeBoletos[hashBoleto].valorPago, listaDeBoletos[hashBoleto].dataDoPagamento);
        }
    }
    
}
