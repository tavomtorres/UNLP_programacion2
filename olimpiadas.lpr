program olimpiadas;

uses crt ,sysutils;

TYPE

        tipoarbol=^tnodo;
    tnodo= RECORD
           raiz:integer;
           izq:tipoarbol;
           der:tipoarbol;
    end;

      Lista_Olim=^lista_olim_nodo; {lista generada automatico para recorrerla y armar arbol}
      lista_olim_nodo= RECORD
             codigo_resultado:integer;
             CodigoDisci:integer;
             NombreDisci:string;
             puesto:string;
             NombreAtleta:string;
             PaisAtleta:string;
             sig:Lista_Olim;
      end;

      Lista_Paises=^paises_nodo;  {Lista de paises para el registro}
      paises_nodo= RECORD
             nombre:string;
             sig:Lista_Paises;
      end;

      Lista_Registro= ^registro_nodo;  {Lista que contiene cada nodo dato del arbol }
      registro_nodo= Record
           nombre_disciplina:string;
           total_participantes:integer;
           paises: Lista_Paises;
           Sig: Lista_registro; {<< Es necesario un siguiente en lista registro?}
        end;

    Arbol_Disciplinas= ^arbol_disciplina_nodo;  {Arbol de las disciplinas olimpicas}
    arbol_disciplina_nodo = RECORD
           cod_disciplina:integer; {raiz: codigo de disciplina}
           izq:Arbol_Disciplinas;
           der:Arbol_Disciplinas;
           dato:Lista_Registro;
    end;

  CONST
    max=9;
  disciplinas: array[0..max] of string= ('Natacion','Boxeo','Beisbol','Atletismo','Futbol',
  'Golf','Pesas','Ciclismo','FormulaUno','Saltos');

  puestos: array[0..max] of string= ('Oro','Plata','Bronce','4to','5to',
  '6to','7mo','8vo','9no','otro');

  paises: array[0..max] of string= ('Argentina','Chile','USA','Brasil','Mexico',
  'Espana','Alemania','Italia','Colombia','Madagascar');

  nombres: array[0..max] of string= ('Pedro','Fernando','Gustavo','Enrique','Michael',
  'Valentino','Fabio','Roberto','Raul','Jorge');



VAR
   Arbol_De_Disciplinas: Arbol_Disciplinas;{Variable para mostrar arbol de disciplinas olimpicas}

   Lista_Datos: Lista_Registro; {Lista que contiene la informacion de la disciplina}
   Paises_Participantes: Lista_Paises; {Lista de paises participantes de una disciplina}

   arbol:tipoarbol;
   sel,i:integer;
   contador_p:integer;

   ListaOlimpiadas: Lista_Olim;

PROCEDURE mostrarmenu;
begin
       writeln('---------------OLIMPIADAS---------------------');
  writeln('0) SALIR.');
    writeln();
  writeln('1) Armar Lista Olimpiadas automatico');
    writeln();
  writeln('2) Imprimir Lista  Olimpiadas');
    writeln();
  writeln('3) Insertar Registro MANUALMENTE en la lista Olimpiadas');

    writeln();
  writeln('4) Crear un arbol de Olimpiadas');
  writeln();
  writeln('5) Imprimir Raices arbol Olimpiadas (Inorden).');
  writeln();
  writeln('6) Imprimir Nodos Informativos del Arbol-Olimpiadas Inorden');
    writeln();
  writeln('7) Imprimir Nodos Informativos del Arbol-Olimpiadas Pre-orden');
    writeln();
  writeln('9) Informar numero de atletas de disciplinas entre codigo 100 y 200');
  writeln();
end;


PROCEDURE insercion(var arbol:tipoarbol;elem:integer);
BEGIN
  if arbol = nil then
     begin
       new (arbol);
       arbol^.raiz:=elem;
       arbol^.izq:=nil;
       arbol^.der:=nil;
     end
  ELSE
   if elem<arbol^.raiz THEN
      insercion(arbol^.izq,elem)
      ELSE
      insercion(arbol^.der,elem);
end;

PROCEDURE insertarelem( VAR arbol:tipoarbol);
VAR
   elem:integer;
BEGIN
     write('Inserte el elemento:');
     readln(elem);
     insercion(arbol,elem);
END;

function RandomDisciplina:string;
begin
     Result:= disciplinas[random(max)];
end;

function RandomPuesto:string;
begin
     Result:= puestos[random(max)];
end;

function RandomPais:string;
begin
     Result:= paises[random(max)];
end;

function RandomNombre:string;
begin
     Result:= nombres[random(max)];
end;


{-------------GENERAR ARBOL---------------------}

 FUNCTION ExistePais(auxPais:Lista_Paises; pais:string):integer; {funcion que devuelve 1 si el pais ya esta en la lista 0 si no}
VAR
   existe:boolean = false;
BEGIN
   while auxPais <> nil do
        begin
             if auxPais^.nombre = pais then
                begin
                    existe:=true;
                    auxPais:=auxPais^.sig;
                end
             else
             begin
                 auxPais:=auxPais^.sig;
             end;
        end;
   if existe = True then
      Result:=1
   else
       Result:=0;
END;


PROCEDURE InsertarEnArbol(var arbol:Arbol_Disciplinas; var lista:Lista_Olim;lista_aux:Lista_Olim); {NO SE USA}
VAR

lista_datos:Lista_Registro; {Lista datos linkeada a Arbol}
l_pais,auxPais,auxPais2:Lista_Paises;  {Lista paises linkeada a lista_datos}
contador_atletas,existe:integer;
BEGIN
  contador_atletas:=0;
  new(arbol);
  new(lista_datos);
  new(l_pais);

  arbol^.cod_disciplina:= lista^.CodigoDisci;
  arbol^.der:=nil;
  arbol^.izq:=nil;
  l_pais:=nil;


  while lista_aux <> nil do {recorro lista principal}
       begin
          if lista_aux^.CodigoDisci = lista^.CodigoDisci then  {si en la lista principal coincide el codigo disci con el que inserté en arbol}
             begin
                contador_atletas:= contador_atletas +1;

                if l_pais = nil then  {si la lista de paises esta vacia}
                   begin
                    new (auxPais);
                    auxPais^.nombre := lista_aux^.PaisAtleta;
                    auxPais^.sig := nil;
                    l_pais:= auxPais;
                   end
                else {si no esta vacia recorro lista paises e inserto al ultimo}
                begin
                   existe:= ExistePais(l_pais,lista_aux^.PaisAtleta); {si devuelve 0 el pais no esta en la lista}
                   if existe = 0 then
                      begin
                          new(auxPais);
                          auxPais :=l_pais;
                          while auxPais^.sig <> nil do
                            auxPais:= auxPais^.sig;

                          new (auxPais2);
                          auxPais2^.nombre :=lista_aux^.PaisAtleta;
                          auxPais2^.sig:= nil;
                          auxPais^.sig:= auxPais2;
                      end

                end; {fin if de l_pais = nil}
                lista_aux:= lista_aux^.sig;
             end
          else
             begin
               lista_aux:= lista_aux^.sig;
             end

       end;   {fin del while, ya se contaron todos los atletas y paises participantes de la disciplina}
     lista_datos^.nombre_disciplina:=lista^.NombreDisci;
     lista_datos^.total_participantes:= contador_atletas;
     lista_datos^.paises:=l_pais;
     lista_datos^.Sig:=nil;

     arbol^.dato:=lista_datos;



END;


PROCEDURE GenerarArbol(var arbol:Arbol_Disciplinas; var lista:Lista_Olim;lista_aux:Lista_Olim); {NO SE USA}
VAR
   contador_atletas,existe:integer;
BEGIN
          if arbol = nil then
             begin
                InsertarEnArbol(arbol,lista,lista_aux);
             end
          else if lista^.CodigoDisci = arbol^.cod_disciplina then
               begin
                  write('');
               end
          else if lista^.CodigoDisci < arbol^.cod_disciplina then
               begin
                  GenerarArbol(arbol^.izq,lista,lista_aux)
               end
          else if lista^.CodigoDisci > arbol^.cod_disciplina then
               begin
                  GenerarArbol(arbol^.der,lista,lista_aux)
               end


END;


PROCEDURE GenerarArbol2(var arbol:Arbol_Disciplinas; var lista:Lista_Olim);{<<<<<<<NUEVO GENERAR ARBOL, PROCEDIMIENTO CORRECTO}
VAR
lista_datos:Lista_Registro; {Lista datos linkeada a Arbol}
l_pais,auxPais,auxPais2:Lista_Paises;  {Lista paises linkeada a lista_datos}
contador_atletas,existe:integer;
BEGIN
   if arbol = nil then
      begin
        new(arbol);
        new(lista_datos);
        new(l_pais);

        arbol^.cod_disciplina:= lista^.CodigoDisci; {asigno el codigo de la disciplina al nodo arbol}
        arbol^.der:=nil;
        arbol^.izq:=nil;
        l_pais:=nil;
        lista_datos^.nombre_disciplina:=lista^.NombreDisci;
        lista_datos^.total_participantes:= 1;
        lista_datos^.paises:=l_pais;
        lista_datos^.Sig:=nil;

        new (auxPais); {armo el pais}
        auxPais^.nombre := lista^.PaisAtleta;
        auxPais^.sig := nil;
        l_pais:= auxPais; {lo asigno a la lista nueva de pais}

        lista_datos^.paises:=l_pais;{asigno la lista de pais a los datos}
        arbol^.dato:=lista_datos;  {asigno los datos al nodo arbol}
     end
     else if lista^.CodigoDisci = arbol^.cod_disciplina then
               begin
                  arbol^.dato^.total_participantes:= arbol^.dato^.total_participantes + 1 ;
                   existe:= ExistePais(arbol^.dato^.paises,lista^.PaisAtleta); {si devuelve 0 el pais no esta en la lista}
                   if existe = 0 then
                      begin
                          new(auxPais);
                          auxPais :=arbol^.dato^.paises;
                          while auxPais^.sig <> nil do
                            auxPais:= auxPais^.sig;

                          new (auxPais2);
                          auxPais2^.nombre :=lista^.PaisAtleta;
                          auxPais2^.sig:= nil;
                          auxPais^.sig:= auxPais2;
                      end

               end
     else if lista^.CodigoDisci < arbol^.cod_disciplina then
               begin
                  GenerarArbol2(arbol^.izq,lista)
               end
     else if lista^.CodigoDisci > arbol^.cod_disciplina then
               begin
                  GenerarArbol2(arbol^.der,lista)
               end


END;








PROCEDURE RecorreLista_GeneraArbol(var arbol:Arbol_Disciplinas;lista:Lista_Olim);
VAR
   elem,anterior:integer;
BEGIN
          while lista <> nil do
               begin
                  GenerarArbol2(arbol,lista);
                  lista:=lista^.sig;
               end;

END;



{----------------------------------}





   {disciplinas: array[0..max] of string= ('Natacion','Boxeo','Beisbol','Atletismo','Futbol',
  'Golf','Pesas','Ciclismo','FormulaUno','Saltos'); }
FUNCTION AsignarCodigoDisciplina(nom_disci:string ): integer;
VAR
   bandera:boolean;
BEGIN
     case nom_disci of
          'Natacion': result:=120;
          'Boxeo': result:=90;
          'Beisbol': result:=160;
          'Atletismo': result:=250;
          'Futbol': result:=180;
          'Golf': result:=50;
          'Pesas': result:=130;
          'Ciclismo': result:=110;
          'FormulaUno': result:=20;
          'Saltos': result:=220;
     end;
END;


PROCEDURE InsertarEnLista(var lista:Lista_Olim;cod_disci:integer;cod_result:integer;
  nom_disci:string;puesto:string;nom_atl:string;pais:string);
VAR
 aux,aux2:Lista_Olim;
BEGIN
  if lista = nil then
       begin
         new(aux);{nuevo registro}
         aux^.codigo_resultado:= cod_result;
         aux^.CodigoDisci:=cod_disci;
         aux^.NombreDisci:=nom_disci;
         aux^.puesto:= puesto;
         aux^.NombreAtleta:= nom_atl;
         aux^.PaisAtleta := pais;
         lista:=aux;
         lista^.sig:=nil;
         end
    else
        begin
         new(aux);
           aux :=lista;
           while aux^.sig <> nil do
              aux:= aux^.sig;

           new (aux2);{nuevo registro}
           aux2^.codigo_resultado := cod_result;
           aux2^.CodigoDisci := cod_disci;
           aux2^.NombreDisci := nom_disci;
           aux2^.puesto := puesto;
           aux2^.NombreAtleta := nom_atl;
           aux2^.PaisAtleta := pais;

           aux2^.sig:= nil;
           aux^.sig:= aux2;

         end;

END;

{Crear Lista automatica de olimpiadas}
{codigo_resultado:integer;
             CodigoDisci:integer;
             NombreDisci:string;
             puesto:string;
             NombreAtleta:string;
             PaisAtleta:string;
             sig:Lista_Olimpiadas;}
PROCEDURE GenerarListaAuto(var lista:Lista_Olim);
var
   cod_disci,cod_result,i:integer;
   aux,aux2:Lista_Olim;
   nom_disci,puesto,nom_atl,pais:string;
BEGIN

  nom_disci:= RandomDisciplina();
  puesto:=RandomPuesto();
  pais:=RandomPais();
  nom_atl:=RandomNombre();
  cod_disci:= AsignarCodigoDisciplina(nom_disci);
  cod_result:=random(10);
  InsertarEnLista(lista,cod_disci,cod_result,nom_disci,puesto,nom_atl,pais);
END;




{GENERAR LISTA}
PROCEDURE MenuGenerarListaAuto(var lista:Lista_Olim);
VAR
  Numero_Registros,i:integer;
  BEGIN
          write('Cual es el numero de registros que desea en la lista? ');
          writeln('');
          readln(Numero_Registros);
          if(Numero_Registros=0)then
             begin
               write('Saliste');
             end
          else
          begin
            for i:=1 to Numero_Registros do
               GenerarListaAuto(lista);

          end;

  end;

{INSERTAR EN LA LISTA MANUALMENTE}
PROCEDURE MenuInsertarRegistroLista(var lista:Lista_Olim);
VAR
   cod_disci,cod_result,i:integer;
   aux,aux2:Lista_Olim;
   nom_disci,puesto,nom_atl,pais:string;

BEGIN
    clrscr();
   if lista = nil then
      writeln('Inserte el primer registro de la lista...presione una tecla')
   else
      writeln('Inserte el siguiente registro de la lista...presione una tecla');
   readln();
   writeln('DISCIPLINAS QUE YA EXISTEN PARA GENERAR LISTA AUTOMATICA: ');
   writeln('Natacion,Boxeo,Beisbol,Atletismo,Futbol,Golf,Pesas,Ciclismo,FormulaUno,Saltos ');
   writeln('');
   writeln('Inserte el nombre de la disciplina');
   readln(nom_disci);
   writeln('');
   writeln('Inserte el codigo de la disciplina');
   readln(cod_disci);
   writeln('');
   writeln('Inserte codigo de resultado de la disciplina');
   readln(cod_result);
   writeln('');
   writeln('Inserte nombre del atleta');
   readln(nom_atl);
   writeln('');
   writeln('Inserte pais del atleta');
   readln(pais);
   writeln('');
   writeln('Inserte puesto/lugar del atleta- ej: Oro,Plata,Bronce,4to,5to...');
   readln(puesto);
   InsertarEnLista(lista,cod_disci,cod_result,nom_disci,puesto,nom_atl,pais);
END;



{RECORRIDOS E IMPRESIONES}

PROCEDURE recorridoinordenO(arbol:Arbol_Disciplinas);   {Inorden, se imprimeel subarbol izq, luego la razis, y por ultimo el sub arbol der}
BEGIN
      if arbol <> nil then
          begin
            if arbol^.izq <> nil then
              recorridoinordenO(arbol^.izq);

            write(arbol^.cod_disciplina, '  ');

            if arbol^.der<> nil then
              recorridoinordenO(arbol^.der);

          end
      else
      begin
        write('el arbol esta vacio');
        readln();
      end;
END;


PROCEDURE ImprimirArbolPorNodosP(arbol:Arbol_Disciplinas);   {PreOrden, primero la raiz, luego sub izq, luego sub der}
BEGIN

      if arbol <> nil then
          begin
            writeln('-------------NODO:',arbol^.cod_disciplina,'-----------');
            writeln('Nombre disciplina: ',arbol^.dato^.nombre_disciplina);
            writeln('Total de participantes: ',arbol^.dato^.total_participantes);
            writeln('Paises de esta disciplina:  ');
            while arbol^.dato^.paises <> nil do
               begin
                   write('--',arbol^.dato^.paises^.nombre);
                   arbol^.dato^.paises:= arbol^.dato^.paises^.sig;

               end;
            writeln('');
            if arbol^.izq <> nil then
              ImprimirArbolPorNodosP(arbol^.izq);
            if arbol^.der<> nil then
              ImprimirArbolPorNodosP(arbol^.der);

          end
      else
      begin
        write('el arbol esta vacio');
        readln();
      end;
END;



PROCEDURE ImprimirArbolPorNodosI(arbol:Arbol_Disciplinas);   {Inorden, se imprimeel subarbol izq, luego la razis, y por ultimo el sub arbol der}
VAR
   contador:integer;
BEGIN
      if arbol <> nil then
          begin

            if arbol^.izq <> nil then
              ImprimirArbolPorNodosI(arbol^.izq);

            writeln('-------------NODO:',arbol^.cod_disciplina,'-----------');
            writeln('Nombre disciplina: ',arbol^.dato^.nombre_disciplina);
            writeln('Total de participantes: ',arbol^.dato^.total_participantes);
            writeln('Paises de esta disciplina:  ');
            while arbol^.dato^.paises <> nil do
               begin
                   write('--',arbol^.dato^.paises^.nombre);
                   arbol^.dato^.paises:= arbol^.dato^.paises^.sig;

               end;
            writeln('');

            if arbol^.der<> nil then
              ImprimirArbolPorNodosI(arbol^.der);

          end
      else
      begin
        write('el arbol esta vacio');
        readln();
      end;
END;



procedure ImprimirListaOlimpiadas(lista:Lista_Olim);
begin
      while lista <> nil do
           begin
           writeln('------------------------------');
           writeln('Disciplina numero: ',lista^.CodigoDisci);
           writeln('Nombre Disciplina: ',lista^.NombreDisci);
           writeln('Pais Del Atleta: ',lista^.PaisAtleta);
           writeln('Nombre Del Atleta: ',lista^.NombreAtleta);
           writeln('Puesto Competencia: ',lista^.puesto);
           writeln('------------------------------');
           writeln('');
           lista:=lista^.sig;
           end;
      writeln('fin');

end;


{BUESQUEDA OLIMPIADAS:
b)Informar la cantidad de atletas de las disciplinas cuyo código se encuentre entre 100 y 200.}

{Hace falta hacer un Menu ImprimirAtletasMinMax para informar la variable contador_p y no tener esos writeln adentro}

PROCEDURE ImprimirAtletasMinMax(arbol:Arbol_Disciplinas; var contador_p:integer);
VAR
   min,max,elem:integer;
BEGIN
     if (arbol <> nil) then
     begin
      if(arbol^.cod_disciplina<100)then {si el numero es menor a 100}
       begin
        writeln('numero participantes en el nodo > ',arbol^.cod_disciplina,' es :',arbol^.dato^.total_participantes);
        writeln('');
        ImprimirAtletasMinMax(arbol^.der,contador_p);
       end
      else {en caso que no sea menor a 100 ,entonces esta entre 100-200 o es mayor a 200}
       begin
         if(arbol^.cod_disciplina>200) then {si el numero es mayor a 200}
          begin
            writeln('numero participantes en el nodo > ',arbol^.cod_disciplina,' es :',arbol^.dato^.total_participantes);
            writeln('');
            ImprimirAtletasMinMax(arbol^.izq,contador_p);
          end
         else {si entro aca es porque el numero esta en el rango}
          begin
            writeln('numero participantes en el nodo > ',arbol^.cod_disciplina,' es :',arbol^.dato^.total_participantes);
            writeln('');
             contador_p:=contador_p+ arbol^.dato^.total_participantes;
             if arbol^.izq <> nil then
                ImprimirAtletasMinMax(arbol^.izq,contador_p);
             if arbol^.der<> nil then
                ImprimirAtletasMinMax(arbol^.der,contador_p);
          writeln('El numero total es : ',contador_p);
          readln();

          end
       end
     end
     else
     write('Fin del recorrido     ');
END;


 {-----------------------------------------------------------------------------------}

{RECORRIDOS---Normales}
PROCEDURE recorridoinorden(arbol:tipoarbol);   {Inorden, se imprimeel subarbol izq, luego la razis, y por ultimo el sub arbol der}
     BEGIN

          if arbol^.izq <> nil then
             recorridoinorden(arbol^.izq);
          write(arbol^.raiz, '  ');
          if arbol^.der<> nil then
             recorridoinorden(arbol^.der);

     END;

BEGIN

    crt.WindMaxY := 500;
  repeat
    writeln(' ,presione tecla para continuar...');
    readln();
    clrscr();
    writeln(' ');
    randomize;
    mostrarmenu;
    write('Elige una opcion: ');
    readln(sel);
    contador_p:=0;
    CASE sel OF
    1:MenuGenerarListaAuto(ListaOlimpiadas);
    2:ImprimirListaOlimpiadas(ListaOlimpiadas);
    3:MenuInsertarRegistroLista(ListaOlimpiadas);
    4:RecorreLista_GeneraArbol(Arbol_De_Disciplinas,ListaOlimpiadas);
    5:recorridoinordenO(Arbol_De_Disciplinas);
    6:ImprimirArbolPorNodosI(Arbol_De_Disciplinas);
    7:ImprimirArbolPorNodosP(Arbol_De_Disciplinas);
    9:ImprimirAtletasMinMax(Arbol_De_Disciplinas, contador_p);
    END;
  UNTIL sel=0;

END.  {Fin programa}

