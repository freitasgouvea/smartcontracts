pragma solidity 0.5.11;

contract locacaoComercial {

    /* Variaveis:
    Partes: Locadora e Locatária (ok)
    Objeto: locação do imóvel objeto de matrícula 1234.
    Destinação da área locada: a área locada se destina exclusivamente à instalação, manutenção, operação e gestão de instituição de ensino e atividades administrativas correlatas.
    Prazo de vigência do Contrato: 180 (cento e oitenta) meses.
    Renovação. A LOCADORA garante à LOCATÁRIA o direito de renovar o Prazo Inicial de vigência por mais 60 (sessenta) meses adicionais. Para tanto, sem prejuízo do direito de propor a ação renovatória, a LOCATÁRIA deverá notificar a LOCADORA acerca da intenção em renovar este Contrato até 9 (nove) meses antes do término do Prazo Inicial. Neste caso, a LOCADORA obriga-se a firmar, em até 30 (trinta) dias contatos da notificação acima mencionada, termo aditivo que formalize a prorrogação do Prazo Inicial.
    Calendário Letivo. A LOCATÁRIA não poderá ser compelida a deixar a Área Locada, por qualquer motivo que seja, durante o período letivo. Igualmente, caso o término do prazo deste Contrato, por qualquer que seja o motivo, dê-se durante o período letivo, a LOCATÁRIA poderá requerer que o Contrato seja automaticamente prorrogado até o final do próximo período de férias escolares.
    Valor do Aluguel. O aluguel mensal é de R$ 70.000,00 (setenta mil reais)
    Correção Anual. O Aluguel Mensal deverá ser corrigido anualmente de acordo com o índice IGP-M.
    Data de Vencimento. Os Aluguéis Mensais devidos deverão ser pagos até o dia 10 (dez) do mês subsequente ao vencido.
    Atraso e Penalidades por Atraso. Se vencido e não pago até o dia determinado neste Contrato, o Aluguel Mensal será acrescido de: (a) juros de mora à razão de 1% (um por cento) ao mês; (b) correção monetária de acordo com a variação do IPCA, até a data do efetivo pagamento; e (c) multa moratória fixada em 2% (dois por cento) sobre o valor total da obrigação em atraso. Caso o atraso seja superior a 30 (trinta) dias, a partir do 31º (trigésimo primeiro) dia, passará a ser aplicada a multa moratória de 10% (dez por cento) sobre o valor em atraso.
    Multa. As Partes estabelecem o pagamento de uma multa de 3 (três) Aluguéis Mensais (R$ 210.000,00).
    */

    string nomeLocadora;
    address payable addressLocadora;
    string nomeLocataria;
    address payable addressLocataria;
    string matriculaImovel;
    uint256 prazoInicialContrato;
    uint256 peridodoDeRenovacao;
    uint256 prazoParaRenovar;
    uint256 valorAluguel;
    uint256 indiceDeCorrecaoAnual;
    uint256 vencimentoPrimeiraParcela;
    uint256 jurosDeMora;
    uint256 multaPorAtrasoNoPagamento;
    uint256 multaContratual = 3*valorAluguel;
    
    //estas dois campos devem podem validados por um terceiro ou um oraculo, por exemplo, o advogado:
    
    bool periodoLetivo;
    bool objetoEducacao;

    /*
    OBRIGAÇÕES DA LOCATÁRIA:
    (i)	Efetuar o pagamento do Aluguel Mensal dentro da data de vencimento;
    (ii)	Utilizar a Área Locada e os Espaços Compartilhados exclusivamente para os fins estabelecidos como destinação;
    (iii)	Devolver a Área Locada e os Espaços Compartilhados ao término da vigência deste Contrato;
    (iv)	Entregar à LOCADORA quaisquer citações, multas ou notificações relacionadas à Área Locada emitidas pelas autoridades públicas, antes de decorrido 1/3 (um terço) do prazo disponível para respectiva defesa;
    (v)	Pagar, diretamente aos agentes arrecadadores, o IPTU, as despesas relacionadas a serviços públicos, e as tarifas de consumo (energia, água, gás e esgoto) os encargos de locação.
    (vi)	Contratar seguro da Área Locada, cobrindo danos decorrentes de incêndio, desabamento, enchente, queda de aeronave ou colisão de veículo, dentre outros, devendo entregar à LOCADORA cópia da apólice, na qual constará a LOCATÁRIA como beneficiária. Em caso de sinistro, a LOCATÁRIA repassará à LOCADORA os valores recebidos da companhia seguradora para que a LOCADORA realize as obras de reconstrução do Imóvel.
    //Acredito que estas obrigacoes nao sao transferiveis ao smart contract, pois necessitariam de uma analise subjetiva e externa, como o uso de um oraculo, por exemplo. Eventualmente, se o descumprimento dessas obrigacoes incorrerem em sancoes, podem-se ser criadas funcoers para a aplicacao das sancoe. Mas sugiro deixar isso para um segundo momento.
    
    Funçoes sugeridas:
    
    1 - Constructor com os parametros a serem declarados para as variaveis acima.
    2 - Pagamento do alugeul (antes do vencimento ou com atraso, usando um if para antes do vencimento e o else para depois do vencimento, com o require o valor da obrigaçao e transfer para o locatario)
    3 - Correcao anual do valor do aluguel (com o ajuste do valor de acordo com o indice)
    4 - Notificacao para renovacao
    5 - Renovação. A LOCADORA garante à LOCATÁRIA o direito de renovar o Prazo Inicial de vigência por mais 60 (sessenta) meses adicionais. Para tanto, sem prejuízo do direito de propor a ação renovatória, a LOCATÁRIA deverá notificar a LOCADORA acerca da intenção em renovar este Contrato até 9 (nove) meses antes do término do Prazo Inicial. Neste caso, a LOCADORA obriga-se a firmar, em até 30 (trinta) dias contatos da notificação acima mencionada, termo aditivo que formalize a prorrogação do Prazo Inicial.
    6 - Notificaçao de descumprimento de obrigacao para a recisao.
    7 - Rescisão Justificada. O presente Contrato poderá ser rescindido antecipadamente, sem qualquer penalidade, em caso de descumprimento de qualquer obrigação ora assumida pelas Partes que não seja sanada no prazo de 90 (noventa) dias, contado a partir do recebimento de notificação enviada pela Parte inocente à Parte infratora.
    8 - Rescisão Injustificada pela LOCATÁRIA. Caso a LOCATÁRIA venha a resilir este Contrato antecipadamente e de forma imotivada, total ou parcialmente, não terá direito a qualquer ressarcimento monetário e arcará com o pagamento de multa equivalente a 3 (três) Aluguéis Mensais por ano faltante para o cumprimento do Prazo Inicial da locação.
    
    Estes dois em asterisco eu acredito que nao sao necessarias pois nao sao muito ajustavais ao smart contract:
    * - Cessão: a cessão de espaço pelo Locatária só pode ser feita mediante prévia autorização por escrito do Locadora.
    * - Direito de Preferência para Locação de Áreas Adicionais. Sempre que a LOCADORA desejar efetuar a locação de qualquer área desocupada do Imóvel e não incluída no conceito de Área Locada, a LOCADORA deverá conceder o direito de preferência à locação de tal área à LOCATÁRIA, por meio de notificação contendo todas as condições negociais, para que a LOCATÁRIA possa, em igualdade de condições, exercer o direito de preferência de, a seu critério, locar tal área adicional.
    
    */
    
    [...]
    
}
