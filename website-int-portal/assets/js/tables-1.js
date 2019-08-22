/*
$(document).ready( function() {
 
    console.log("here")   
    var transTable = $('#transito-loreal-01').DataTable({
            "language": {
                "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json"
            },
            "processing": true,
            "ajax": {
                "url": "http://192.168.1.161:8000/produtos/transitando",
                "dataSrc": "",
                "method": "GET",
                "crossDomain": true,
                "headers": {'x-meu-fornecedor':'oreal'},
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
    //transTable.ajax.url('http://192.168.1.161:8000/produtos/transitando').load();
    
    var recbTable = $('#recebido-loreal-02').DataTable({
        "language": {
          "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json"
        },
        "processing": true,
        "ajax": {
          "url": "http://192.168.1.161:8000/produtos/recebidos",
          "dataSrc": "",
          "method": "GET",
          "crossDomain": true,
          "headers": {'x-meu-fornecedor':'oreal'},
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
    //recbTable.ajax.url('http://192.168.1.161:8000/produtos/recebidos').load();
   
   
   
    $('#loreal').click(function(){
        $('#fornecedor-h1').html("L'OREAL");

    });
    
    // When Salvatori dropdown menu is chosen
    $('#salvatori').click(function(){                        
        $('#fornecedor-h1').html("SALVATORI");
        
        //transTable.ajax.url( 'newData.json' ).load();
        transTable.ajax({
            "headers": {'x-meu-fornecedor':'SALVATORI'}
        }).reload();
          
        var transTable = $('#transito-loreal-01').DataTable({
            "language": {
              "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json"
            },
            "processing": true,
            "ajax": {
                "url": "http://192.168.1.161:8000/produtos/transitando",
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
        transTable.ajax.url('http://192.168.1.161:8000/produtos/transitando').load();
        
        var recbTable = $('#recebido-loreal-02').DataTable({
        "language": {
          "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json"
        },
        "processing": true,
        "ajax": {
          "url": "http://192.168.1.161:8000/produtos/recebidos",
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
        recbTable.ajax.url('http://192.168.1.161:8000/produtos/recebidos').load();
        
    });
    
    */
    /*
    $('#transito-salvatori-01').DataTable({
        "language": {
          "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json"
        },
        "processing": true,
        "ajax": {
          "url": "http://192.168.1.161:8000/produtos/transitando",
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
          "url": "http://192.168.1.161:8000/produtos/recebidos",
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
    */
/*
});
*/