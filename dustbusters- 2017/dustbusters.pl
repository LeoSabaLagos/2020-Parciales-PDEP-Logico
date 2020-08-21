%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Who you gonna call?   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

tarea(ordenarCuarto).
tarea(limpiarTecho).
tarea(cortarPasto).
tarea(limpiarBanio).
tarea(encerarPisos).

% Punto 1
% Agregar a la base de conocimientos la siguiente información:

% Estos son de prueba
% tiene(leo,escoba).
% tiene(leo,pala).

% Egon tiene una aspiradora de 200 de potencia.
tiene(egon,aspiradora(200)).
% Egon y Peter tienen un trapeador, Ray y Winston no.
tiene(egon,varitaDeNeutrones).
tiene(peter,trapeador).
% Ray y Winston no tienen trapeador, y por universo cerrado lo tomamos como falso
% Sólo Winston tiene una varita de neutrones.
tiene(wiston,varitaDeNeutrones).
% Nadie tiene una bordeadora.
% por universo cerrado lo tomamos como falso

% Punto 2
% Definir un predicado que determine si un integrante satisface 
% la necesidad de una herramienta requerida. 
% Esto será cierto si tiene dicha herramienta, teniendo en cuenta que si 
% la herramienta requerida es una aspiradora, el integrante debe tener una con potencia 
% igual o superior a la requerida.

% Nota: No se pretende que sea inversible respecto a la herramienta requerida.

satisfaceNecesidad(Persona,Herramienta):-
    tiene(Persona,Herramienta).

satisfaceNecesidad(Persona,aspiradora(PotenciaRequerida)):-
    tiene(Persona,aspiradora(Potencia)),
    between(0, Potencia, PotenciaRequerida).

% Punto 3
/*
Queremos saber si una persona puede realizar una tarea, 
que dependerá de las herramientas que tenga. 
Sabemos que:
    Quien tenga una varita de neutrones puede hacer cualquier tarea, 
    independientemente de qué herramientas requiera dicha tarea.
    
    Alternativamente alguien puede hacer una tarea si puede satisfacer
    la necesidad de todas las herramientas requeridas para dicha tarea.
*/

persona(Persona):-
    tiene(Persona,_).

puedeRealizarTarea(Persona,Tarea):-
    persona(Persona),
    tarea(Tarea),
    puedeRealizar(Persona,Tarea).

puedeRealizar(Persona,_):-
    tiene(Persona,varitaDeNeutrones).

puedeRealizar(Persona,Tarea):-
    persona(Persona),
    tieneTodasLasHerramientas(Persona,Tarea).

tieneTodasLasHerramientas(Persona,Tarea):-
    herramientasRequeridas(Tarea,HerramientasNecesarias),
    forall(member(Herramienta, HerramientasNecesarias),satisfaceNecesidad(Persona,Herramienta)).

% Punto 4
/*
Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un pedido 
(que son las tareas que pide). 

Para ellos disponemos de la siguiente información en la base de conocimientos:
    tareaPedida/3: relaciona al cliente, con la tarea pedida y 
                   la cantidad de metros cuadrados sobre los cuales hay que realizar esa tarea.
    precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al cliente.

Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada tarea, 
multiplicando el precio por los metros cuadrados de la tarea.

*/

%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(dana,ordenarCuarto,20).
tareaPedida(walter,cortarPasto,50).
tareaPedida(jose,limpiarTecho,70).
tareaPedida(louis,limpiarBanio,15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

cliente(Cliente):-
    tareaPedida(Cliente,_,_).

costo(Cliente,Costo):-
    cliente(Cliente),
    calcularCostoTotal(Cliente,Costo).

calcularCostoTotal(Cliente,Costo):-
    findall(Precio,precioPorTarea(Cliente,Precio),Precios),
    sumlist(Precios, Costo).
    
precioPorTarea(Cliente,Precio):-
    tareaPedida(Cliente,Tarea,MetrosCuadrados),
    precio(Tarea,PrecioPorMetroCuadrado),
    Precio is MetrosCuadrados * PrecioPorMetroCuadrado.

% Punto 5
/*
Finalmente necesitamos saber quiénes aceptarían el pedido de un cliente. 

Un integrante acepta el pedido cuando puede realizar todas las tareas del pedido 
y además está dispuesto a aceptarlo.
*/

aceptaPedido(Integrante,Cliente):-
    persona(Integrante),
    cliente(Cliente),
    puedeRealizarPedido(Integrante,Cliente),
    dispuestoAlPedido(Integrante,Cliente).

puedeRealizarPedido(Integrante,Cliente):-
    forall(tareaPedida(Cliente,Tarea,_),puedeRealizarTarea(Integrante,Tarea)).

% Peter está dispuesto a aceptar cualquier pedido.
dispuestoAlPedido(peter,_).

% Winston sólo acepta pedidos que paguen más de $500
dispuestoAlPedido(wiston,Cliente):-
    costo(Cliente,Costo),
    Costo > 500.

% Ray sólo acepta pedidos que no incluyan limpiar techos
dispuestoAlPedido(ray,Cliente):-
    forall(tareaPedida(Cliente,Tarea,_),Tarea \= limpiarTecho).

% Egon está dispuesto a aceptar pedidos que no tengan tareas complejas 
dispuestoAlPedido(egon,Cliente):-
    forall(tareaPedida(Cliente,Tarea,_),noEsTareaCompleja(Tarea)).

noEsTareaCompleja(Tarea):-
    tarea(Tarea),
    not(esTareaCompleja(Tarea)).

% Decimos que una tarea es compleja si requiere más de dos herramientas. 
esTareaCompleja(Tarea):-
    herramientasRequeridas(Tarea,Herramientas),
    length(Herramientas, Cantidad),
    Cantidad > 2.
    
% Además la limpieza de techos siempre es compleja.
esTareaCompleja(limpiarTecho).