/*
$(document).ready( function () {
    $('#transito-salvatori-01').DataTable({
        "language": {
          "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json"
        },
        "processing": true,
        "ajax": {
          "url": "http://10.1.1.12:8000/produtos/transitando",
          "dataSrc": "",
          "method": "GET",
          "crossDomain": true,
          "headers": {'x-meu-fornecedor':'SALVATORI'},
          "dataType": "json"
        },
        columns: [
            { data: 'mes_analisado' },
            { data: 'nfe_numero' },
            { data: 'nfe_data' },
            { data: 'emissor_nome' },
            { data: 'prod_volumes' },
            { data: 'valor_bruto' }
        ]
    });
    
 $('#recebido-salvatori-02').DataTable({
        "language": {
          "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json"
        },
        "processing": true,
        "ajax": {
          "url": "http://10.1.1.12:8000/produtos/recebidos",
          "dataSrc": "",
          "method": "GET",
          "crossDomain": true,
          "headers": {'x-meu-fornecedor':'SALVATORI'},
          "dataType": "json"
        },
        columns: [
            { data: 'mes_analisado' },
            { data: 'nfe_numero' },
            { data: 'nfe_data' },
            { data: 'emissor_nome' },
            { data: 'prod_volumes' },
            { data: 'valor_bruto' }
        ]
    });
    
    
} );
*/