%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUEÑOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Un consorcio internacional nos pidió que relevemos su negocio, 
que consiste en hacer el seguimiento de los sueños que tiene cada una de las personas 
y los personajes que están destinados a cumplir esos sueños. 
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 1 (2 puntos) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte A 
% Generar la base de conocimientos inicial

% Gabriel cree en Campanita, el Mago de Oz y Cavenaghi
cree(gabriel,campanita).
cree(gabriel,magoDeOz).
cree(gabriel,cavenaghi).

% Juan cree en el Conejo de Pascua
cree(juan,conejoDePascua).

% Macarena cree en los Reyes Magos, el Mago Capria y Campanita
cree(macarena,reyesMagos).
cree(macarena,magoCapria).
cree(macarena,campanita).

% Diego no cree en nadie
% NO declaro nada para tomar como falso todo lo que desconocemos de Diego (Por universo cerrado)

% Gabriel quiere ganar la lotería apostando al 5 y al 9, 
suenia(gabriel,ganarLoteria([5,9])).
% Gabriel quiere ser un futbolista de Arsenal
suenia(gabriel,serFutbolista(arsenal)).

% Juan quiere ser un cantante que venda 100.000 “discos”
suenia(juan,serCantante(100000)).

% Macarena no quiere ganar la lotería, 
% sí ser cantante estilo “Eruca Sativa” y vender 10.000 discos
suenia(macarena,serCantante(10000)).

% Parte b
% Indicar qué conceptos entraron en juego para cada punto.
/* Para generar nuestra base de conocimientos lo que hicimos fue declarar hechos,
osea tomar por verdadero todo lo que nos informan produciendo su existencialidad
y lo que desconocemos o es falso no lo declaramos para que nuestro universo cerrado
lo tome como falso  */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 2 (4 puntos) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Queremos saber si una persona es ambiciosa, esto ocurre cuando 
% la suma de dificultades de los sueños es mayor a 20

/*
Puede agregar los predicados que sean necesarios. 
El predicado debe ser inversible para todos sus argumentos. 

Gabriel es ambicioso, porque quiere ganar a la lotería con 2 números (20 puntos de dificultad)
y quiere ser futbolista de Arsenal (3 puntos) = 23 que es mayor a 20. 

En cambio Juan y Macarena tienen 4 puntos de dificultad (cantantes con menos de 500.000 discos)
*/

persona(Persona):-
    suenia(Persona,_).

ambiciosa(Persona):-
    persona(Persona),
    dificultadesSuenios(Persona,TotalDificultades),
    TotalDificultades > 20.

/*dificultadesSuenios(Persona,TotalDificultades):-
    findall(Dificultad,calcularDificultad(suenia(Persona,Suenio),Dificultad),Dificultades),
    --------------------------------------------------------|  Tira Singlenton Variable
    sumlist(Dificultades, TotalDificultades).


calcularDificultad(suenia(Persona,Suenio),Dificultad):-
    suenia(Persona,Suenio), % <------------- ESTÁ AL PEDO 
    dificultad(Suenio,Dificultad).*/

dificultadesSuenios(Persona,TotalDificultades):-
    findall(Dificultad,calcularDificultad(Persona,Dificultad),Dificultades),
    sumlist(Dificultades, TotalDificultades).
    
calcularDificultad(Persona,Dificultad):-
    suenia(Persona,Suenio),
    dificultad(Suenio,Dificultad).

% La dificultad de cada sueño se calcula como:

% 6 para ser un cantante que vende más de 500.000 
dificultad(serCantante(CantDiscos),6):-
    between(0,CantDiscos,500000).
% ó 4 en caso contrario
dificultad(serCantante(CantDiscos),4):-
    between(0,500000,CantDiscos).

% ganar la lotería implica una dificultad de 10 * la cantidad de los números apostados
dificultad(ganarLoteria(Numeros),Dificultad):-
    length(Numeros, CantidadNumeros),
    Dificultad is 10 * CantidadNumeros.

% lograr ser un futbolista tiene una dificultad de 3 en equipo chico o 16 en caso contrario. 
% Arsenal y Aldosivi son equipos chicos.
dificultad(serFutbolista(Equipo),3):-
    equipo(Equipo),
    equipoChico(Equipo).

dificultad(serFutbolista(Equipo),16):-
    equipo(Equipo),
    not(equipoChico(Equipo)).

equipo(Equipo):-
    suenia(_,serFutbolista(Equipo)).

equipoChico(arsenal).
equipoChico(aldosivi).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 3 (4 puntos) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Queremos saber si un personaje tiene química con una persona. 

No puede utilizar findall en este punto.
El predicado debe ser inversible para todos sus argumentos.

Campanita tiene química con Gabriel (porque tiene como sueño ser futbolista de Arsenal, 
que es un sueño de dificultad 3 - menor a 5), 

Los Reyes Magos, el Mago Capria y Campanita tienen química con Macarena porque no es ambiciosa*/

personaje(Personaje):-
    cree(_,Personaje).

% un personaje tiene química con una persona si la persona cree en el personaje y ...
quimica(Personaje,Persona):-
    personaje(Personaje),
    persona(Persona),
    cree(Persona,Personaje),
    tienenQuimica(Personaje,Persona).

% para Campanita, la persona debe tener al menos un sueño de dificultad menor a 5.
tienenQuimica(campanita,Persona):-
    calcularDificultad(Persona,Dificultad),
    Dificultad < 5.

% para el resto de personaje , 
% todos los sueños deben ser puros (ser futbolista o cantante de menos de 200.000 discos)
% y la persona no debe ser ambiciosa
tienenQuimica(Personaje,Persona):-
    Personaje \= campanita,
    noEsAmbiciosa(Persona),
    todosSueniosPuros(Persona).

noEsAmbiciosa(Persona):- not(ambiciosa(Persona)).

todosSueniosPuros(Persona):-
    forall(suenia(Persona,Suenio),puro(Suenio)).

puro(serFutbolista(Equipo)):-
    equipo(Equipo).

puro(serCantante(CantidadDiscos)):-
    between(0,200000,CantidadDiscos).
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 4 (2 puntos) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 

Necesitamos definir si un personaje puede alegrar a una persona

Debe evitar repetición de lógica.

El predicado debe ser totalmente inversible.

Debe considerar cualquier nivel de amistad posible (la solución debe ser general).

el Mago Capria alegra a Macarena, ya que tiene química con ella y no está enfermo

Campanita alegra a Macarena; 
aunque está enferma es amiga del Conejo de Pascua, 
que aunque está enfermo es amigo de Cavenaghi que no está enfermo.

*/

% Sabemos que Campanita es amiga de los Reyes Magos y del Conejo de Pascua
amigos(campanita,reyesMagos).
amigos(campanita,conejoPascua).

% el Conejo de Pascua es amigo de Cavenaghi, entre otras amistades
amigos(conejoPascua,cavenaghi).
amigos(cavenaghi,magoCapria).

% sonAmigos es una relacion simetrica (No lo dice el ejercicio lo dice la vida ahre xd)
sonAmigos(A,B):- amigos(A,B).
sonAmigos(A,B):- amigos(B,A).

% dos personajes son amigos cuando tienen amistad
sonAmigos(P1,P2):-
    amigos(P1,P2).

% dos personajes son amigos cuando tienen una amistad de por medio (Amistad Indirecta)
sonAmigos(P1,P2):-
    amigos(P1,Personaje),
    % Transitividad de amistades %
    amigos(Personaje,P2).

% Un personaje de backup es un amigo directo del personaje principal
% Un personaje de backup es un amigo directo o indirecto del personaje principal
personajeBackup(Personaje,Backup):-
    sonAmigos(Personaje,Backup).

% si una persona tiene algún sueño+
% el personaje tiene química con la persona y...
%      el personaje no está enfermo
%      o algún personaje de backup no está enfermo. 

puedeAlegrar(Personaje,Persona):-
    personaje(Personaje),
    persona(Persona),
    suenia(Persona,_),
    quimica(Personaje,Persona),
    noEstaEnfermoElPersonaje(Personaje).

noEstaEnfermoElPersonaje(Personaje):-
    not(enfermo(Personaje)).

noEstaEnfermoElPersonaje(Personaje):-
    % aca entra enfermo Personaje
    personajeBackup(Personaje,Backup),not(enfermo(Backup)).

% Campanita, los Reyes Magos y el Conejo de Pascua están enfermos
enfermo(campanita).
enfermo(reyesMagos).
enfermo(conejoPascua).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Como corregir %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Nota: 
12 puntos = 10
11 puntos = 9
10 puntos = 8 
9 puntos = 7
8 puntos = 6
7 = revisión
6 = 3 
< 6 = 2 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%