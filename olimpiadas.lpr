program olimpiadas;

uses crt ,sysutils;

TYPE

        tipoarbol=^tnodo;
    tnodo= RECORD
           raiz:integer;
           izq:tipoarbol;
           der:tipoarbol;
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


VAR
   Arbol_De_Disciplinas: Arbol_Disciplinas;{Variable para mostrar arbol de disciplinas olimpicas}
   {Debo inicializar la lista de Registros y la de paises? }
   Lista_Datos: Lista_Registro; {Lista que contiene la informacion de la disciplina}
   Paises_Participantes: Lista_Paises; {Lista de paises participantes de una disciplina}
   arbol:tipoarbol;
   sel:integer;

PROCEDURE mostrarmenu;
begin
  writeln('0) SALIR.');
  writeln('1) Insertar un elemento en el arbol.');
  writeln('2) Imprimir el arbol (preorden).');
  writeln('3) Imprimir el arbol (postOrden).');
  writeln('4) Imprimir el arbol (Inorden).');
  writeln('---------------OLIMPIADAS---------------------');
  writeln('5) Crear un arbol de olimpiadas');
  writeln();
  writeln('6) Imprimir arbol olimpiadas (preorden).');
  writeln();
  writeln('7) Imprimir arbol olimpiadas (postOrden).');
  writeln();
  writeln('8) Imprimir arbol olimpiadas (Inorden).');
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







{-----------------------------------------------------------------------------
CREARLISTA - Inserta un codigo de disciplina en el arbol olimpico }
procedure InsertarEnArbolDisciplinas(var arbol:Arbol_Disciplinas; raizInicial:integer);
var
  n_aleatorio,n_atletas,n_paises,i:integer;
  list:Lista_Registro;
  l_pais,auxPais,auxPais2:Lista_Paises;

begin

  n_atletas:= random (200)+ 1;  {numero de atletas}
  n_paises:= random (5) + 2 ; {numero de paises a generar}
  if (arbol = nil) then   {si el arbol esta vacio}
     begin
      new (arbol);
      new(list);
      new(l_pais);
      arbol^.cod_disciplina:= raizInicial;
      arbol^.izq :=nil;
      arbol^.der :=nil;
      {Lleno la lista de registro que irá linkeada a arbol^.datos}
      list^.nombre_disciplina := Concat('Deporte',IntToStr(raizInicial));
      list^.total_participantes := n_atletas;
      {Lleno la lista de paises que ira linkeada a list.paises}
      for i := 1 to n_paises do
          begin
                if i = 1 then
                   begin
                    new (auxPais);
                    auxPais^.nombre := Concat('Pais00', IntToStr(i));
                    auxPais^.sig := nil;
                    l_pais:= auxPais;
                   end
                else
                 begin
                       new(auxPais);
                       auxPais :=l_pais;
                       while auxPais^.sig <> nil do
                            auxPais:= auxPais^.sig;

                       new (auxPais2);
                       auxPais2^.nombre := Concat('Pais00', IntToStr(i));
                       auxPais2^.sig:= nil;
                       auxPais^.sig:= auxPais2;
                 end;

          end; {termina el for}

      {Una vez creada la lista de paises aleatorios y la lista de regitro , se asignan
      al puntero dato del arbol}
      list^.paises:=l_pais;

      arbol^.dato := list;

     end
  ELSE
      begin
        if raizInicial < arbol^.cod_disciplina THEN
           InsertarEnArbolDisciplinas(arbol^.izq,raizInicial)
        ELSE
           InsertarEnArbolDisciplinas(arbol^.der,raizInicial)
      end

end;

{insertar en arbol Olimpiadas disciplina MENU}
PROCEDURE insertarNumeroDeDisciplina(var arbol:Arbol_Disciplinas);
VAR
   elem:integer;
BEGIN

          clrscr();
          write('Inserte el codigo de su disciplina (para salir numero 0): ');
          writeln('');
          readln(elem);
          if(elem=0)then
           begin
            writeln('saliste');
           end
          else
           begin
              InsertarEnArbolDisciplinas(arbol,elem);
              insertarNumeroDeDisciplina(arbol);
           end;




END;



{RECORRIDOS E IMPRESIONES---OLIMPIADAS---------OLIMPIADAS--------------------------OLIMPIADAS-----------------------OLIMPIADAS----------------}
PROCEDURE recorridopreordenO(arbol:Arbol_Disciplinas); {Se imprime la raiz, despues el sub arbol izq, y luego el sub arbol der}
     BEGIN
       if arbol <> nil then
        begin
         write(arbol^.cod_disciplina, '  ');
          if arbol^.izq <> nil then
             recorridopreordenO(arbol^.izq);
          if arbol^.der<> nil then
             recorridopreordenO(arbol^.der);

        end

       else
       begin
        write('el arbol esta vacio');

       end;


     END;
PROCEDURE recorridopostordenO(arbol:Arbol_Disciplinas); {postorden, se imprime el subarbol izq , despues el der, y de ultimo la raiz}
BEGIN
     if arbol <> nil then
          begin
           if arbol^.izq <> nil then
             recorridopostordenO(arbol^.izq);
           if arbol^.der<> nil then
             recorridopostordenO(arbol^.der);

           write(arbol^.cod_disciplina, '  ');
          end
     else
     begin
        write('el arbol esta vacio');
        readln();
     end

END;

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

{BUESQUEDA OLIMPIADAS:
b)Informar la cantidad de atletas de las disciplinas cuyo código se encuentre entre 100 y 200.}


PROCEDURE ImprimirAtletasMinMax(arbol:Arbol_Disciplinas; contador_p:integer);
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
PROCEDURE recorridopreorden(arbol:tipoarbol); {Se imprime la raiz, despues el sub arbol izq, y luego el sub arbol der}
     BEGIN
     write(arbol^.raiz, '  ');
          if arbol^.izq <> nil then
             recorridopreorden(arbol^.izq);
          if arbol^.der<> nil then
             recorridopreorden(arbol^.der);

     END;
PROCEDURE recorridopostorden(arbol:tipoarbol); {postorden, se imprime el subarbol izq , despues el der, y de ultimo la raiz}
     BEGIN

          if arbol^.izq <> nil then
             recorridopreorden(arbol^.izq);
          if arbol^.der<> nil then
             recorridopreorden(arbol^.der);
     write(arbol^.raiz, '  ');
     END;
PROCEDURE recorridoinorden(arbol:tipoarbol);   {Inorden, se imprimeel subarbol izq, luego la razis, y por ultimo el sub arbol der}
     BEGIN

          if arbol^.izq <> nil then
             recorridopreorden(arbol^.izq);
          write(arbol^.raiz, '  ');
          if arbol^.der<> nil then
             recorridopreorden(arbol^.der);

     END;

BEGIN

  repeat
    writeln(' ,presione tecla para continuar...');
    readln();
    clrscr();
    writeln(' ');
    randomize;
    mostrarmenu;
    write('Elige una opcion: ');
    readln(sel);

    CASE sel OF
    1:insertarelem(arbol);
    2:recorridopreorden(arbol);
    3:recorridopostorden(arbol);
    4:recorridoinorden(arbol);
    5:insertarNumeroDeDisciplina(Arbol_De_Disciplinas);
    6:recorridopreordenO(Arbol_De_Disciplinas);
    7:recorridopostordenO(Arbol_De_Disciplinas);
    8:recorridoinordenO(Arbol_De_Disciplinas);
    9:ImprimirAtletasMinMax(Arbol_De_Disciplinas,0);
    END;
  UNTIL sel=0;
END.  {Fin programa}

