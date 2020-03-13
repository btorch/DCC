$(document).ready(function(){
  
  $("input[type='text']").hover(function(){
    $(this).prop("title","Favor preencher campo")
  });
    
  $("input[type='email']").hover(function(){
    $(this).prop("title","Favor preencher campo")
  });
    
  $("#grupo-tipologia").hover(function(){
    $(this).prop("title","Favor indicar topologia")
  });
    
  $("input[type='radio']").change(function(){  
    if ($(this).val()=="fisica")
    {
      //alert("Fisica Clicked.");  
      $("#inscr").prop("disabled",true);
      $("#inscr").prop("required",false);
      $("#inscr").css('background-color','#DEDEDE');   
      $("#razao-social").prop("disabled",true);
      $("#razao-social").prop("required",false);
      $("#razao-social").css('background-color','#DEDEDE');   
    }
    else
    {
      //alert("Juridico Clicked.");
      $("#inscr").prop("disabled",false);
      $("#inscr").prop("required",true);
      $("#inscr").css('background-color','white');   
      $("#razao-social").prop("disabled",false);
      $("#razao-social").prop("required",true);
      $("#razao-social").css('background-color','white');   
    }
  });
    
    
$("#tipos").change(function(){  
    if ($(this).val()=="5")
    {
        //alert("Consumidor Final.");  
        $("#cabelereiros").prop("disabled",true);
        $("#cabelereiros").prop("required",false);
        $("#cabelereiros").css('background-color','#DEDEDE');
        $("#valores").prop("disabled",true);
        $("#valores").prop("required",false);
        $("#valores").css('background-color','#DEDEDE');        
    }
    else if ($(this).val()=="2" || $(this).val()=="3")
    {
        //alert("tipo 2 or 3 ");
        $("#cabelereiros").prop("disabled",true);
        $("#cabelereiros").prop("required",false);
        $("#cabelereiros").css('background-color','#DEDEDE');
    }    
    else
    {
        //alert("todos");  
        $("#cabelereiros").prop("disabled",false);
        $("#cabelereiros").prop("required",true);
        $("#cabelereiros").css('background-color','white'); 
        $("#valores").prop("disabled",false);
        $("#valores").prop("required",true);
        $("#valores").css('background-color','white');
    } 
    
  });    
});