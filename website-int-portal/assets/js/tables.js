
function grabTransito(fornecedor) {
            window.trans = $('#transitandoTbl').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json",
                    "decimal": ","
                },
                "processing": true,
                //"responsive": true,
                "scrollY": 300,
                //"scrollX": true,
                "scrollCollapse": false,
                "paging": true,
                "ajax": {
                    "url": "http://192.168.1.204:8000/produtos/transitando",
                    "dataSrc": "",
                    "method": "GET",
                    "crossDomain": true,
                    "headers": {'x-meu-fornecedor': fornecedor},
                    "dataType": "json"
                },
                columns: [
                    { data: 'mes_analisado' },
                    { data: 'nfe_numero' },
                    { data: 'nfe_data' },
                    { data: 'emissor_nome' },
                    { data: 'prod_volumes' },
                    { data: 'valor_bruto' },
                    { data: 'valor_nota' }
                ]
            });
            trans.column('0')
                 .order( 'desc' ).draw();
          
}

function grabRecb(fornecedor) {
             window.recb = $('#recebidoTbl').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json",
                    "decimal": ","
                },
                "processing": true,
                //"responsive": true,
                "scrollY": 300,
                //"scrollX": true,
                "scrollCollapse": false,
                "paging": true,
                "ajax": {
                    "url": "http://192.168.1.204:8000/produtos/recebidos",
                    "dataSrc": "",
                    "method": "GET",
                    "crossDomain": true,
                    "headers": {'x-meu-fornecedor':fornecedor},
                    "dataType": "json"
                },
                columns: [
                    { data: 'mes_analisado' },
                    { data: 'nfe_numero' },
                    { data: 'nfe_data' },
                    { data: 'emissor_nome' },
                    { data: 'prod_volumes' },
                    { data: 'valor_bruto' },
                    { data: 'valor_nota' }
                ]
            });
            recb.column('0')
                .order( 'desc' ).draw();            
}


$(document).ready( function(){
    
    // Setting up page for L'oreal Data
    $('#loreal').click(function(){
        $('#fornecedor-h1').html("L\'oreal");
        if ( ! $.fn.DataTable.isDataTable(window.trans) ) {
            grabTransito("oreal");
        }
        else {
            $('#transitandoTbl').dataTable().fnDestroy();
            grabTransito("oreal");    
        }    
            
        if ( ! $.fn.DataTable.isDataTable(window.recb) ) {     
            grabRecb("oreal");
        }
        else {
            $('#recebidoTbl').dataTable().fnDestroy();
            grabRecb("oreal");            
        }
    });
  
    // Setting up page for Salvatori Data
    $('#salvatori').click(function(){
        $('#fornecedor-h1').html("Salvatori");
        if ( ! $.fn.DataTable.isDataTable('#transitandoTbl') ) {
            grabTransito("salvatori");
        }
        else {
            $('#transitandoTbl').dataTable().fnDestroy();
            grabTransito("salvatori");
        }
        
        if ( ! $.fn.DataTable.isDataTable('#recebidoTbl') ) {
            grabRecb("salvatori");
        }
        else {
            $('#recebidoTbl').dataTable().fnDestroy();
            grabRecb("salvatori");
        }        
    });
    
    // Setting up page for Alfaparf Data
    $('#alfaparf').click(function(){
        $('#fornecedor-h1').html("Alfaparf");
        if ( ! $.fn.DataTable.isDataTable('#transitandoTbl') ) {
            grabTransito("delly");
        }
        else {
            $('#transitandoTbl').dataTable().fnDestroy();
            grabTransito("delly");
        }
        
        if ( ! $.fn.DataTable.isDataTable('#recebidoTbl') ) {
            grabRecb("delly");
        }
        else {
            $('#recebidoTbl').dataTable().fnDestroy();
            grabRecb("delly");
        }
    });
    
}); 


/*
setInterval( function () {
    window.recb.ajax.reload();
    window.trans.ajax.reload();
}, 60000 );
*/

/*    
    // Setting up page for Salvatori Data
    $('#salvatori').click(function(){
        $('#fornecedor-h1').html("Salvatori");       
        if ( ! $.fn.DataTable.isDataTable('#transitandoTbl') ) {
            console.log("Not a Datatable");
        }
        else {
            $('#transitandoTbl').dataTable().fnDestroy();
            $('#transitandoTbl').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json"
                },
                "processing": true,
                "serverSide": true,
                "ajax": {
                    "url": "http://192.168.0.178:8000/produtos/transitando",
                    "dataSrc": "",
                    "method": "GET",
                    "crossDomain": true,
                    "headers": {'x-meu-fornecedor':'Salvatori'},
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
        }
        
        if ( ! $.fn.DataTable.isDataTable('#recebidoTbl') ) {
            console.log("Not a Datatable");
        }
        else {   
            $('#recebidoTbl').dataTable().fnDestroy();
            $('#recebidoTbl').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json"
                },
                "processing": true,
                "serverSide": true,
                "ajax": {
                    "url": "http://192.168.0.178:8000/produtos/recebidos",
                    "dataSrc": "",
                    "method": "GET",
                    "crossDomain": true,
                    "headers": {'x-meu-fornecedor':'Salvatori'},
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
            
        }               
    });

    // Setting up page for Alfaparf Data
    $('#alfaparf').click(function(){
        $('#fornecedor-h1').html("Alfaparf");       
        if ( ! $.fn.DataTable.isDataTable('#transitandoTbl') ) {
            console.log("Not a Datatable");
        }
        else {
            $('#transitandoTbl').dataTable().fnDestroy();
            $('#transitandoTbl').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json"
                },
                "processing": true,
                "serverSide": true,
                "ajax": {
                    "url": "http://192.168.0.178:8000/produtos/transitando",
                    "dataSrc": "",
                    "method": "GET",
                    "crossDomain": true,
                    "headers": {'x-meu-fornecedor':'delly'},
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
        }
        
        if ( ! $.fn.DataTable.isDataTable('#recebidoTbl') ) {
            console.log("Not a Datatable");
        }
        else {   
            $('#recebidoTbl').dataTable().fnDestroy();
            $('#recebidoTbl').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Portuguese-Brasil.json"
                },
                "processing": true,
                "serverSide": true,
                "ajax": {
                    "url": "http://192.168.0.178:8000/produtos/recebidos",
                    "dataSrc": "",
                    "method": "GET",
                    "crossDomain": true,
                    "headers": {'x-meu-fornecedor':'delly'},
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
        }
        
    });

// End of Ready

*/
   
    
 
