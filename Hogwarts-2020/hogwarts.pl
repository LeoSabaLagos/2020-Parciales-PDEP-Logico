% Las Casas de Hogwarts
% En Hogwarts, el colegio de magia y hechicería, 
% hay 4 casas en las cuales los nuevos alumnos se distribuyen ni bien ingresan. 
% Cada año estas casas compiten entre ellas para consagrarse la ganadora de la copa.


/*
Parte 1 - Sombrero Seleccionador
Para determinar en qué casa queda una persona cuando ingresa a Hogwarts, 
el Sombrero Seleccionador tiene en cuenta 
    el carácter de la persona, 
    lo que prefiere 
    y en algunos casos su status de sangre.

Tenemos que registrar en nuestra base de conocimientos qué características 
tienen los distintos magos que ingresaron a Hogwarts, 
el status de sangre que tiene cada mago y en qué casa odiaría quedar. 
*/

% Actualmente sabemos que:

% Base de conocimientos
casa(ravenclaw).
casa(slytherin).
casa(hufflepuff).
casa(gryffindor).

% sangre(Nombre,Pureza).
% caracteristica(Nombre,Caracteristica).
% odiariaIr(Nombre,Casa).

:- discontiguous sangre/2.
:- discontiguous caracteristica/2.
:- discontiguous odiariaIr/2.

sangre(neville, pura).
sangre(luna, pura).

caracteristica(neville,responsabilidad).
caracteristica(neville,coraje).
caracteristica(neville,amistad).

caracteristica(luna, amistad).
caracteristica(luna, inteligencia).
caracteristica(luna, responsabilidad).

% Harry es sangre mestiza
% se caracteriza por ser corajudo, amistoso, orgulloso e inteligente. 
% Odiaría que el sombrero lo mande a Slytherin.
sangre(harry,mestiza).
caracteristica(harry,coraje).
caracteristica(harry,amistad).
caracteristica(harry,orgullo).
caracteristica(harry,inteligencia).
odiariaIr(harry,slytherin).

% Draco es sangre pura, 
% se caracteriza por ser inteligente y orgulloso, pero no es corajudo ni amistoso. 
% Odiaría que el sombrero lo mande a Hufflepuff.
sangre(draco,pura).
caracteristica(draco,inteligencia).
caracteristica(draco,orgullo).
odiariaIr(draco,hufflepuff).

% Hermione es sangre impura, 
% y se caracteriza por ser inteligente, orgullosa y responsable. 
% No hay ninguna casa a la que odiaría ir.

sangre(hermione,impura).
caracteristica(hermione,inteligencia).
caracteristica(hermione,orgullo).
caracteristica(hermione,responsabilidad).
% No hay ninguna casa a la que odiaría ir. Por ende no le define predicado odiariaIr

% Características principales que el sombrero tiene en
% cuenta para elegir la casa mas apropiada:

% Para Gryffindor, lo más importante es tener coraje.
caracteristicasRequeridas(gryffindor,NombreMago):-
    caracteristica(NombreMago,coraje).

% Para Slytherin, lo más importante es el orgullo y la inteligencia.
caracteristicasRequeridas(slytherin,NombreMago):-
    caracteristica(NombreMago,orgullo),
    caracteristica(NombreMago,inteligencia).

% Para Ravenclaw, lo más importante es la inteligencia y la responsabilidad.
caracteristicasRequeridas(ravenclaw,NombreMago):-
    caracteristica(NombreMago,inteligencia),
    caracteristica(NombreMago,responsabilidad).

% Para Hufflepuff, lo más importante es ser amistoso.
caracteristicasRequeridas(hufflepuff,NombreMago):-
    caracteristica(NombreMago,amistad).

% Punto 1
/*
Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y 
cualquier casa excepto en el caso de Slytherin, que no permite entrar a magos de sangre impura.
*/

mago(NombreMago):-
    sangre(NombreMago,_).

permiteEntrar(Casa,NombreMago):-
    mago(NombreMago),
    casa(Casa),
    Casa \= slytherin.

permiteEntrar(slytherin,NombreMago):-
    sangre(NombreMago,Sangre),
    Sangre \= impura.


% Punto 2
/*
Saber si un mago tiene el carácter apropiado para una casa, 
lo cual se cumple para cualquier mago si sus características 
incluyen todo lo que se busca para los integrantes de esa casa, 
independientemente de si la casa le permite la entrada.
*/

caracterApropiado(Casa,NombreMago):-
    casa(Casa),
    caracteristicasRequeridas(Casa,NombreMago).
    
% Punto 3
/*
Determinar en qué casa podría quedar seleccionado un mago sabiendo 
que tiene que tener el carácter adecuado para la casa, la casa permite su entrada 
y además el mago no odiaría que lo manden a esa casa. 

Además Hermione puede quedar seleccionada en Gryffindor, 
porque al parecer encontró una forma de hackear al sombrero.
*/

poderQuedarSeleccionado(Casa,NombreMago):-
    caracterApropiado(Casa,NombreMago),
    permiteEntrar(Casa,NombreMago),
    not(odiariaIr(NombreMago,Casa)).

poderQuedarSeleccionado(hermione,gryffindor).

% Punto 4
/*
Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos 
si todos ellos se caracterizan por ser amistosos y 
cada uno podría estar en la misma casa que el siguiente. 

No hace falta que sea inversible, se consultará de forma individual.
*/

cadenaDeAmistades(Magos):-
    forall(member(NombreMago, Magos),amistoso(NombreMago)),
    cadenaDeCasas(Magos).

amistoso(NombreMago):-
    caracteristica(NombreMago,amistad).

% Caso recursivo
cadenaDeCasas([NombreMago, OtroMago | DemasMagos]):-
    poderQuedarSeleccionado(Casa,NombreMago),
    poderQuedarSeleccionado(Casa,OtroMago),
    cadenaDeCasas([OtroMago | DemasMagos]).
    
% Caso base    
cadenaDeCasas([_]).

/*
Parte 2 - La copa de las casas
A lo largo del año los alumnos pueden ganar o perder puntos para su casa 
en base a las buenas y malas acciones realizadas, 
y cuando termina el año se anuncia el ganador de la copa. 
*/

%%%%%%%%%%%%%%%%%%% MALAS ACCIONES %%%%%%%%%%%%%%%%%%%
%    Harry anduvo fuera de cama.
accion(harry,fueraDeCama,-50).
%    Hermione fue al tercer piso y a la sección restringida de la biblioteca.
accion(hermione,ir(tercerPiso),-75).
accion(hermione,ir(seccionRestringidaBiblioteca),-10).
%    Harry fue al bosque y al tercer piso.
accion(harry,ir(bosque),-50).
accion(harry,ir(tercerPiso),-75).

%%%%%%%%%%%%%%%%%%% BUENAS ACCIONES %%%%%%%%%%%%%%%%%%%
%    A Ron le dieron 50 puntos por su buena acción de ganar una partida de ajedrez mágico.
accion(ron,ganarAjedrezMagico,50).
%    A Hermione le dieron 50 puntos por usar su intelecto para salvar a sus amigos 
%    de una muerte horrible.
accion(hermione,salvarAmigos,50).
%    A Harry le dieron 60 puntos por ganarle a Voldemort.
accion(harry,ganarleAVoldemort,60).
%    Draco fue a las mazmorras.
accion(draco,ir(mazmorras),0). % No está prohibido ir a las mazmorras


/*
También sabemos en qué casa quedó seleccionado efectivamente cada alumno 
mediante el predicado esDe/2 que relaciona a la persona con su casa, por ejemplo:
*/
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% Punto 1
% Sobre las acciones que impactan al puntaje actualmente tenemos la siguiente información:

/*
Malas acciones: son andar de noche fuera de la cama (que resta 50 puntos) o ir a lugares prohibidos. 
La cantidad de puntos que se resta por ir a un lugar prohibido se indicará para cada lugar. 

También sabemos que los siguientes lugares están prohibidos:
El bosque, que resta 50 puntos.
La sección restringida de la biblioteca, que resta 10 puntos.
El tercer piso, que resta 75 puntos.
Ir a un lugar que no está prohibido no afecta al puntaje.
*/

malaAccion(accion(NombreMago,QueHizo,Puntaje)):-
    mago(NombreMago),
    esMala(QueHizo,Puntaje).

esMala(fueraDeCama,-50).
esMala(ir(tercerPiso),-75).
esMala(ir(seccionRestringidaBiblioteca),-10).
esMala(ir(bosque),-50).

/*
Buenas acciones: son reconocidas por los profesores y prefectos individualmente y 
el puntaje se indicará para cada acción premiada.
*/
buenaAccion(accion(NombreMago,QueHizo,Puntaje)):-
    not(malaAccion(accion(NombreMago,QueHizo,Puntaje))).

% Parte A
% Saber si un mago es buen alumno, que se cumple si hizo alguna acción 
% y ninguna de las cosas que hizo se considera una mala acción 
% (que son aquellas que provocan un puntaje negativo).


% Parte B
% Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción. 
