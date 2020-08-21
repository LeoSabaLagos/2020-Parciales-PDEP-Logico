%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  VOCALOID %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASE DE CONOCIMIENTOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% De cada vocaloid (o cantante) se conoce el nombre y además la canción que sabe cantar. 
% De cada canción se conoce el nombre y la cantidad de minutos de duración.

% canta(NombreCantante,NombreCancion,Duracion).  Duracion en minutos

% megurineLuka sabe cantar la canción nightFever cuya duración es de 4 min y 
% también canta la canción foreverYoung que dura 5 minutos.	
canta(megurineLuka,nightFever,4).
canta(megurineLuka,foreverYoung,5).
% hatsuneMiku sabe cantar la canción tellYourWorld que dura 4 minutos.
canta(hatsuneMiku,tellYourWorld,4).
% gumi sabe cantar foreverYoung que dura 4 min y tellYourWorld que dura 5 min
canta(gumi,foreverYoung,4).
canta(gumi,tellYourWorld,5).
% seeU sabe cantar novemberRain con una duración de 6 min 
% y nightFever con una duración de 5 min.
canta(seeU,novemberRain,6).
canta(seeU,nightFever,5).
% kaito no sabe cantar ninguna canción.
% lo tomamos como hecho desconocido, por universo cerrado falso
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARTE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 1
% Saber si un vocaloid es novedoso cuando saben al menos 2 canciones 
% y el tiempo total que duran todas las canciones debería ser menor a 15

vocaloid(NombreCantante):-
    canta(NombreCantante,_,_).

novedoso(NombreCantante):-
    vocaloid(NombreCantante),
    alMenosDosCanciones(NombreCantante),
    tiempoTotalMenorAQuince(NombreCantante).
    
alMenosDosCanciones(NombreCantante):-
    canta(NombreCantante,Cancion1,_),
    canta(NombreCantante,Cancion2,_),
    Cancion1 \= Cancion2.

tiempoTotalMenorAQuince(NombreCantante):-
    tiempoTotal(NombreCantante,TiempoTotal),
    TiempoTotal < 15.

tiempoTotal(NombreCantante,TiempoTotal):-
    findall(Duracion,canta(NombreCantante,_,Duracion),Duraciones),
    sumlist(Duraciones, TiempoTotal).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 2
% Saber si un cantante es acelerado, condición que se da cuando 
% todas sus canciones duran 4 minutos o menos. 
% Resolver sin usar forall/2.
acelerado(NombreCantante):-
    vocaloid(NombreCantante),
    todasCancionesDeCuatroOMenosMinutos(NombreCantante).

todasCancionesDeCuatroOMenosMinutos(NombreCantante):-
    noExisteCancionLarga(NombreCantante).

noExisteCancionLarga(NombreCantante):-
    not(masDeCuatroMinutos(NombreCantante)).

masDeCuatroMinutos(NombreCantante):-
    canta(NombreCantante,_,Duracion),
    Duracion > 4.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARTE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Además de los vocaloids, conocemos información acerca de varios conciertos 
que se darán en un futuro no muy lejano. 

De cada concierto se sabe: 
    su nombre 
    el país donde se realizará
    una cantidad de fama
    el tipo de concierto.

Hay tres tipos de conciertos:
    gigante del cual se sabe:
        la cantidad mínima de canciones que el cantante tiene que saber 
        la duración total de todas las canciones tiene que ser mayor a una cantidad dada.

    mediano sólo pide que: 
    la duración total de las canciones del cantante sea menor a una cantidad determinada.
    
    pequeño el único requisito es que:
        alguna de las canciones dure más de una cantidad dada.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 1
% Modelar los conciertos y agregar en la base de conocimiento todo lo necesario.

% mikuExpo, es un concierto gigante que se va a realizar en Estados Unidos, 
% le brinda 2000 de fama al vocaloid que pueda participar en él 
% y pide que el vocaloid sepa más de 2 canciones 
% y el tiempo mínimo de 6 minutos.	
concierto(mikuExpo,estadosUnidos,2000,gigante(2,6)).

% Magical Mirai, se realizará en Japón y también es gigante, 
% pero da una fama de 3000 y pide saber más de 3 canciones por cantante 
% con un tiempo total mínimo de 10 minutos. 
concierto(magicalMirai,japon,3000,gigante(3,10)).

% Vocalekt Visions, se realizará en Estados Unidos y es mediano brinda 1000 de fama 
% y exige un tiempo máximo total de 9 minutos.	
concierto(vocalektVisions,estadosUnidos,1000,mediano(9)).

% Miku Fest, se hará en Argentina y es un concierto pequeño que solo da 100 de fama 
% al vocaloid que participe en él, con la condición de que sepa 
% una o más canciones de más de 4 minutos.
concierto(mikuFest,argentina,100,pequeño(4)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 2
% Se requiere saber si un vocaloid puede participar en un concierto, 
% esto se da cuando cumple los requisitos del tipo de concierto. 

puedeParticipar(NombreCantante,NombreConcierto):-
    vocaloid(NombreCantante),
    condiciones(NombreConcierto,Condiciones),
    cumpleCondiciones(NombreCantante,Condiciones).

% También sabemos que Hatsune Miku puede participar en cualquier concierto.
puedeParticipar(hatsuneMiku,NombreConcierto):-
    concierto(NombreConcierto,_,_,_).

condiciones(NombreConcierto,Condiciones):-
    concierto(NombreConcierto,_,_,Condiciones).

:- discontiguous cumpleCondiciones/2.

% gigante del cual se sabe:
%    la cantidad mínima de canciones que el cantante tiene que saber 
%    la duración total de todas las canciones tiene que ser mayor a una cantidad dada.
cumpleCondiciones(NombreCantante,gigante(CantMinCanciones,TiempoTotalMinimo)):-
    cumpleCantidadMinDeCanciones(NombreCantante,CantMinCanciones),
    cumpleTiempoTotalMinimo(NombreCantante,TiempoTotalMinimo).

cumpleCantidadMinDeCanciones(NombreCantante,CantMinCanciones):-
    cantidadDeCanciones(NombreCantante,CantidadCanciones),
    CantidadCanciones >= CantMinCanciones.

cantidadDeCanciones(NombreCantante,CantidadCanciones):-
    findall(Cancion,canta(NombreCantante,Cancion,_),Canciones),
    length(Canciones, CantidadCanciones).

cumpleTiempoTotalMinimo(NombreCantante,TiempoTotalMinimo):-
    tiempoTotal(NombreCantante,TiempoTotal),
    TiempoTotal > TiempoTotalMinimo.

% mediano sólo pide que: 
%    la duración total de las canciones del cantante sea menor a una cantidad determinada.
cumpleCondiciones(NombreCantante,mediano(TiempoTotalMaximo)):-
    tiempoTotal(NombreCantante,TiempoTotal),
    TiempoTotal < TiempoTotalMaximo.

% pequeño el único requisito es que:
%    alguna de las canciones dure más de una cantidad dada.
cumpleCondiciones(NombreCantante,pequeño(DuracionMinimaDeUnaCancion)):-
    canta(NombreCantante,_,Duracion),
    Duracion > DuracionMinimaDeUnaCancion.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 3
% Conocer el vocaloid más famoso, es decir con mayor nivel de fama. 
% El nivel de fama de un vocaloid se calcula como la fama total 
% que le dan los conciertos en los cuales puede participar 
% multiplicado por la cantidad de canciones que sabe cantar.

masFamoso(NombreCantante):-
    vocaloid(NombreCantante),
    forall(vocaloid(OtroCantante),esMasFamosoQue(NombreCantante,OtroCantante)).

esMasFamosoQue(NombreCantante,OtroCantante):-
    vocaloid(OtroCantante),
    distintosCantantes(NombreCantante,OtroCantante),
    nivelFama(NombreCantante,NivelFama),
    nivelFama(OtroCantante,OtroNivelFama),
    NivelFama >= OtroNivelFama.

distintosCantantes(NombreCantante,OtroCantante):-
	NombreCantante \= OtroCantante.

nivelFama(Cantante,NivelFama):-
    vocaloid(Cantante),
    famaTotal(Cantante,FamaTotal),
    cantidadDeCanciones(Cantante,CantidadCanciones),
    NivelFama is FamaTotal * CantidadCanciones.

famaTotal(Cantante,TotalFama):-
    vocaloid(Cantante),
    findall(FamaConcierto,obtenerFamaConcierto(Cantante,FamaConcierto),FamasObtenidas),
    sort(FamasObtenidas,Famas),
    sumlist(Famas, TotalFama).

obtenerFamaConcierto(Cantante,FamaConcierto):-
    puedeParticipar(Cantante,Concierto),
    concierto(Concierto,_,FamaConcierto,_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%