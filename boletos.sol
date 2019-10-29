pragma solidity 0.5.1.;

contract Boletos {

    banco address;
    boletos [] public listaDeBoletos
    
    struct boleto {
        address payable owner;
        address payable payer;
        uint256 valorDoBoleto;
        uint256 dataDeVencimento;
        uint256 multaPorAtraso;
        uint256 jurosDeMora;
        uint256 dataDoPagamento;
        uint256 valorPago;
        bool pagamento;
    }

    event Pagamento();
    
    modifier OnlyOwner() {
    require(msg.sender == provider);
    _; 
    }
    
    constructor (
        address _banco,
        ) public
    {
      banco = _banco;
    }
    
    function criarBoleto (
        address payable _owner,
        uint256 _valorDoBoleto,
        uint256 _dataDeVencimento,
        uint256 _multaPorAtraso,
        uint256 _jurosDeMora
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
