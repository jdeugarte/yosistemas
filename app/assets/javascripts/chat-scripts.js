var timer;
var isMinimized=false;
function send()
{
var para_u=document.getElementById('chat_name').innerHTML;
var mensaje_u=document.getElementById("mensaje_sincrono").value;
if(mensaje_u)
{
var usuario_id_u=document.getElementById('id_usuario_envio').value;
$.post( "/mensajes/enviar", { para: para_u, mensaje: mensaje_u } );
document.getElementById("mensaje_sincrono").value="";
document.getElementById('chat_conversacion').innerHTML+="<div class='row'><div class='col-lg-12'><div class='pull-right pager' style='margin-bottom: 5px; margin-top: 0px;'><ul><li><a style='color:white; background-color:#428BCA;' title='"+mensaje_u+"'>"+mensaje_u+"</a></li></ul></div></div></div>";
document.getElementById('chat_conversacion').scrollTop = 99999999;
}
}
function showChat(nombre_usuario,usuario_id)
{
if (isMinimized)
	blinkMinimizedChat();
else
{
isMinimized = false;
//dropBlinking();
document.getElementById('min_chat_container').innerHTML = "no";
document.getElementById('minimizeChat').style.display = 'none';
var aux = 'User' + nombre_usuario;
document.getElementById('chat_conversacion').innerHTML="";
document.getElementById('chat_name').innerHTML=nombre_usuario;
document.getElementById('chat_minimized_name').innerHTML=nombre_usuario;
document.getElementById("id_usuario_envio").value=usuario_id;
$("#chat_window").addClass("in");
$("#chat_window").show();
$.get('/usuarios/obtener_charla/'+usuario_id, function(response){
response=response.replace(/\&quot;/g, '"');
var conversacion=JSON.parse(response)
for(var i=0;i<conversacion.length;i++)
{
if(conversacion[i].para_usuario_id!=usuario_id)
{
document.getElementById('chat_conversacion').innerHTML+="<div class='row'><div class='col-lg-12'><div class='pull-left pager' style='margin-bottom: 5px; margin-top: 0px;'><ul style='padding-left:0px;'><li><a style='color:black;' title='"+conversacion[i].created_at+"'>"+conversacion[i].mensaje+"</a></li></ul></div></div></div>";
}
else
{
document.getElementById('chat_conversacion').innerHTML+="<div class='row'><div class='col-lg-12'><div class='pull-right pager' style='margin-bottom: 5px; margin-top: 0px;'><ul><li><a style='color:white; background-color:#428BCA;' title='"+conversacion[i].created_at+"'>"+conversacion[i].mensaje+"</a></li></ul></div></div></div>";
}
}
document.getElementById('chat_conversacion').scrollTop = 99999999;
});
}
	
}
function closeChat()
{
$("#chat_window").removeClass("in");
$("#chat_window").hide();
isMinimized = false;
dropBlinking();
}
function showChatAux()
{
var usuario =document.getElementById('chat_name').innerHTML;
var usuario_id=document.getElementById('id_usuario_envio').value;
isMinimized = false;
dropBlinking();
showChat(usuario,usuario_id);
}
function hideChat()
{
isMinimized = true;
dropBlinking();
var usuario =document.getElementById('chat_name').innerHTML;
$("#chat_window").hide();
//document.getElementById('min_chat_container').innerHTML+='<div id="min_chat_container"> <div id="User' + usuario + '"> <a href="#" onclick="showChatAux()" >'+ usuario +'</a> </div> </div>';
document.getElementById('minimizeChat').style.display = 'inline';
document.getElementById('min_chat_container').innerHTML = "minimized";
//blinkMinimizedChat();
}
function closeMinimizeChat()
{
document.getElementById('minimizeChat').style.display = 'none';
}
function blinkMinimizedChat()
{
	var myElem = document.getElementById("nuevo");
	if (myElem == null) 	
	document.getElementById("chat_minimized_name").innerHTML += "<span id='nuevo'>&nbsp;<img src='/assets/nuevo.gif'></span>";
}

function dropBlinking()
{
	$("#nuevo").remove
}