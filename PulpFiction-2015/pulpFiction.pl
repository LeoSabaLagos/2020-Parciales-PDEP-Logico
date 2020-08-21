%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PULP FICTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Tarantino, un poco cansado después de largas horas de filmación de su clásico noventoso Pulp Fiction, 
decidió escribir un programa Prolog para entender mejor las relaciones entre sus personajes. 

Para ello nos entregó la siguiente base de conocimientos sobre sus personajes, parejas y actividades: */
personaje(pumkin,     ladron([licorerias,estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias,estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).

pareja(marsellus,mia).
pareja(pumkin,honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

% Sabiendo eso, resolver los siguientes predicados, los cuales deben ser completamente inversibles

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* esPeligroso/1. Nos dice si un personaje es peligroso. 
Eso ocurre cuando:
    tiene empleados peligrosos y
    realiza alguna actividad peligrosa: 
        ser matón
        ó robar licorerías. */

existe(NombrePersonaje):-
    personaje(NombrePersonaje,_).

peligroso(NombrePersonaje):-
    existe(NombrePersonaje),
    esPeligroso(NombrePersonaje).

esPeligroso(NombrePersonaje):- algunEmpleadoPeligroso(NombrePersonaje).

esPeligroso(NombrePersonaje):- actividadPeligrosa(NombrePersonaje).

algunEmpleadoPeligroso(NombrePersonaje):-
    trabajaPara(NombrePersonaje,Empleado),
    peligroso(Empleado).

actividadPeligrosa(NombrePersonaje):- esMaton(NombrePersonaje).

actividadPeligrosa(NombrePersonaje):- robaLicorerias(NombrePersonaje).

esMaton(NombrePersonaje):- personaje(NombrePersonaje,mafioso(maton)).

robaLicorerias(NombrePersonaje):- 
    personaje(NombrePersonaje,ladron(Lugares)),
    member(licorerias, Lugares).
    
/* Personajes Peligrosos
    honeyBunny  ---------------> Roba licorerias
    pumkin      ---------------> Roba licorerias
    jules       ---------------| Es maton
    vincent     ---------------| Es maton   
    marsellus   ---------------! Tiene como empleado a jules (es peligroso) */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% duoTemible/2 que relaciona dos personajes cuando son peligrosos y además son pareja o amigos. 

% Considerar que Tarantino también nos dió los siguientes hechos:
amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

duoTemible(P1,P2):-
    existe(P1),existe(P2),
    sonPeligrosos(P1,P2),
    parejaOAmigos(P1,P2).

sonPeligrosos(P1,P2):-
    peligroso(P1),peligroso(P2).

parejaOAmigos(P1,P2):- sonPareja(P1,P2).
parejaOAmigos(P1,P2):- sonAmigos(P1,P2).

sonPareja(A,B):- pareja(A,B).
sonPareja(A,B):- pareja(B,A).

sonAmigos(A,B):- amigo(A,B).
sonAmigos(A,B):- amigo(B,A).

/* Personajes Peligrosos
    honeyBunny  ---------------> Roba licorerias
    pumkin      ---------------> Roba licorerias
    jules       ---------------| Es maton
    vincent     ---------------| Es maton   
    marsellus   ---------------! Tiene como empleado a jules (es peligroso) */

% pareja(marsellus,mia).
% pareja(pumkin,honeyBunny).

/* Duos temibles
vicent jules
pumkin honeyBunny */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
estaEnProblemas/1: 

Ejemplo:

? estaEnProblemas(vincent)
yes. %porque marsellus le pidió que cuide a mia, y porque tiene que ir a buscar a butch

La información de los encargos está codificada en la base de la siguiente forma: */

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

estaEnProblemas(butch). % butch siempre está en problemas 

estaEnProblemas(Personaje):-
    existe(Personaje),
    enProblemas(Personaje).

% el jefe es peligroso y le encarga que cuide a su pareja
enProblemas(Personaje):-
    trabajaPara(Jefe,Personaje),
    peligroso(Jefe),
    sonPareja(Jefe,Pareja),
    encargo(Jefe,Personaje,cuidar(Pareja)). 
    % El Jefe es el solicitante, Personaje el encargado, Pareja la protegida

% tiene que ir a buscar a un boxeador. 
enProblemas(Personaje):-
    encargo(_,Personaje,buscar(Buscado,_)),
    personaje(Buscado,boxeador).

/* Personajes en problemas
vicent
butch */

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sanCayetano/1:  es quien a todos los que tiene cerca les da trabajo (algún encargo). 

sanCayetano(Personaje):-
    existe(Personaje),
    todosSusCercanosConTrabajo(Personaje).

todosSusCercanosConTrabajo(Personaje):-
    lesDaTrabajo(Personaje,_),
    forall(cercano(Personaje,Alguien),lesDaTrabajo(Personaje,Alguien)).

% Alguien tiene cerca a otro personaje si es su amigo o empleado. 
cercano(Personaje,Alguien):- sonAmigos(Personaje,Alguien).
cercano(Personaje,Alguien):- trabajaPara(Personaje,Alguien).

lesDaTrabajo(Jefe,Solicitante):-
    encargo(Jefe,Solicitante,_).

/* San cayetanos: No me dio ninguno creo que por faltante de hechos */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% masAtareado/1. Es el más atareado aquel que tenga más encargos que cualquier otro personaje.
masAtareado(Personaje):-
    existe(Personaje),
    % Para todo personaje existente, Personaje tiene mas encargos.
    forall(existe(Alguien),masEncargos(Personaje,Alguien)).

masEncargos(Atareado,Alguien):-
    encargos(Atareado,CantEncargosAtareado),
    encargos(Alguien,CantEncargosAlguien),
    CantEncargosAtareado >= CantEncargosAlguien.

encargos(Personaje,CantidadEncargos):-
    existe(Personaje),
    findall(Tarea,encargo(_, Personaje,Tarea),Encargos),
    length(Encargos, CantidadEncargos).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
personajesRespetables/1: genera la lista de todos los personajes respetables. 

Es respetable cuando su actividad tiene un nivel de respeto mayor a 9. 

Se sabe que:
    
    Los mafiosos que resuelven problemas tienen un nivel de 10 de respeto, 
    los matones 1 y los capos 20.
    Al resto no se les debe ningún nivel de respeto. */

personajesRespetables(Personajes):-
findall(Personaje,esRespetable(Personaje),Personajes).

esRespetable(Personaje):-
    existe(Personaje),
    nivelRespeto(Personaje,Respeto),
    Respeto > 9.

% Las actrices tienen un nivel de respeto de la décima parte de su cantidad de peliculas.
nivelRespeto(Persona,Respeto):-
    personaje(Persona,actriz(Peliculas)),
    length(Peliculas, CantidadPeliculas),
    Respeto is CantidadPeliculas / 10.

% Los mafiosos que resuelven problemas tienen un nivel de 10 de respeto,los matones 1 y los capos 20.
nivelRespeto(Persona,10):- personaje(Persona,mafioso(resuelveProblemas)).
nivelRespeto(Persona,1):- personaje(Persona,mafioso(maton)).
nivelRespeto(Persona,20):- personaje(Persona,mafioso(capo)).

% Al resto no se les debe ningún nivel de respeto.

% Personajes Respetables: [marsellus, winston]
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 7 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hartoDe/2: un personaje está harto de otro, cuando todas las tareas asignadas 
% al primero requieren interactuar con el segundo (cuidar, buscar o ayudar) o un amigo del segundo. 
% Ejemplo: ? hartoDe(winston, vincent).
% true  % winston tiene que ayudar a vincent, y a jules, que es amigo de vincent. 

hartoDe(Asignado,Alguien):-
    existe(Asignado),
    existe(Alguien),
    encargo(_,Asignado,_),
    forall(encargo(_,Asignado,Tarea),interactuarCon(Alguien,Tarea)).

interactuarCon(Alguien,cuidar(Alguien)).
interactuarCon(Alguien,cuidar(Amigo)):-  
    sonAmigos(Alguien,Amigo).

interactuarCon(Alguien,ayudar(Alguien)).
interactuarCon(Alguien,ayudar(Amigo)):-  
    sonAmigos(Alguien,Amigo).

interactuarCon(Alguien,buscar(Alguien,_)).
interactuarCon(Alguien,buscar(Amigo,_)):-  
    sonAmigos(Alguien,Amigo).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Punto 8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


