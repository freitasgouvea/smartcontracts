pragma solidity 0.5.12.;

contract Boletos {

    address banco;
    Boleto [] public listaDeBoletos;
    
    struct Boleto {
        address payable owner;
        address payable payer;
        uint256 valorDoBoleto;
        uint256 dataDeVencimento;
        uint256 multaPorAtraso;
        uint256 jurosDeMora;
        uint256 dataDoPagamento;
        uint256 valorPago;
        bool ativo;
        bool pagamento;
    }

    event BoletoCriado();
    event Pagamento();

    modifier OnlyBankr() {
    require(msg.sender == banco);
    _; 
    }
    
    modifier OnlyOwner() {
    require(msg.sender == boleto.owner);
    _; 
    }
    
    constructor (
        address _banco
        ) public
    {
      banco = _banco;
    }
    
    function CriarBoleto (
        uint256 _valorDoBoleto,
        uint256 _dataDeVencimento,
        uint256 _multaPorAtraso,
        uint256 _jurosDeMora
    ) {
        novoBoleto memory nb = novoBoleto(msg.sender, 0, _valorDoBoleto, _dataDeVencimento, _multaPorAtraso, _jurosDeMora, 0, 0, true, false);
        boletos[boletoID] = nb;
        emit BoletoCriado (nb.boletoID, nb.msg.sender, nb._valorDoBoleto, nb._dataDeVencimento);
    }
    
    function VerBoleto ( 
        uint256 boletoID
        )
        
        )
    
    function PagarBoleto (
        
        )
    
    function payABill () OnlyBuyer public payable {
        require (now <= dateOfNextBill);
        require (msg.value == billValue);
        dateOfNextBill = dateOfNextBill + 2629743;
        totalValuePayed += billValue;
        numberOfBillsPayed ++;
        listOfBills.push(bill(dateOfNextBill, billValue, now, msg.value, true));
        provider.transfer(msg.value);
        emit Payment();
    }
    
    function payWithLate () OnlyBuyer public payable {
        require (now > dateOfNextBill);
        require (msg.value == billValue+((now-dateOfNextBill)*interestRate/2629743));
        dateOfNextBill = dateOfNextBill + 2629743;
        totalValuePayed += billValue;
        numberOfBillsPayed ++;
        listOfBills.push(bill(dateOfNextBill, billValue, now, msg.value, true));
        provider.transfer(msg.value);
        emit Payment();
    }
    
}
