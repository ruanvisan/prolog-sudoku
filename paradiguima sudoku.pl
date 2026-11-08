% =====================================================================
%  SUDOKU 9x9 CLASSICO EM PROLOG COM CLP(FD)
%  Funciona no SWISH (https://swish.swi-prolog.org) e no SWI-Prolog.
%
%  PARADIGMA: o tabuleiro vem INCOMPLETO. Cada celula vazia (_) e uma
%  variavel logica com dominio 1..9. Declaramos as regras do Sudoku
%  como RESTRICOES e o solver descobre os valores que faltam:
%     1) cada linha    tem 9 valores distintos
%     2) cada coluna   tem 9 valores distintos
%     3) cada bloco 3x3 tem 9 valores distintos
%
%  Consultas (digite na caixa de query, sem o "?-"):
%     resolver.               % puzzle predefinido (solucao unica)
%     resolver_aleatorio.     % gera um puzzle novo, diferente a cada vez
%     resolver_aleatorio(0.6).% idem, escolhendo a fracao de celulas vazias
%     resolver_sem_solucao.   % mostra o tratamento de puzzle invalido
% =====================================================================
 
:- use_module(library(clpfd)).
:- use_module(library(random)).
 
% ---------------------------------------------------------------------
% MODELO: sudoku/1
% ---------------------------------------------------------------------
sudoku(Linhas) :-
    length(Linhas, 9),
    maplist(same_length(Linhas), Linhas),     % tabuleiro 9 x 9
    append(Linhas, Celulas),
    Celulas ins 1..9,                         % dominio das celulas
 
    maplist(all_distinct, Linhas),            % regra 1: linhas
 
    transpose(Linhas, Colunas),
    maplist(all_distinct, Colunas),           % regra 2: colunas
 
    Linhas = [L1, L2, L3, L4, L5, L6, L7, L8, L9],
    blocos(L1, L2, L3),                       % regra 3: blocos 3x3
    blocos(L4, L5, L6),
    blocos(L7, L8, L9),
 
    labeling([ff], Celulas).                  % enumera o que faltar
 
% blocos/3: recebe 3 linhas consecutivas e restringe, de 3 em 3
% colunas, cada bloco 3x3 a ter valores distintos.
blocos([], [], []).
blocos([A, B, C | T1], [D, E, F | T2], [G, H, I | T3]) :-
    all_distinct([A, B, C, D, E, F, G, H, I]),
    blocos(T1, T2, T3).
 
% ---------------------------------------------------------------------
% PUZZLE PREDEFINIDO (25 pistas, solucao unica)
% _ = celula vazia
% ---------------------------------------------------------------------
puzzle_9x9([
    [_, _, _, _, 5, _, 6, _, _],
    [_, _, _, 8, _, 2, 1, _, _],
    [_, 3, _, _, _, _, _, _, 8],
    [1, _, _, 3, _, _, _, _, 7],
    [_, _, _, 9, 6, 8, _, 5, _],
    [_, _, _, _, _, 1, _, 6, 3],
    [_, _, _, _, 4, _, 7, _, _],
    [4, _, _, 6, _, _, _, 1, _],
    [3, 5, _, _, 8, _, _, _, _]
]).
 
% Puzzle invalido (dois 1 na mesma linha) para testar o tratamento de erro
puzzle_sem_solucao([
    [1, 1, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _]
]).
 
% ---------------------------------------------------------------------
% GERADOR DE PUZZLE ALEATORIO
% 1) parte de uma grade completa valida
% 2) embaralha digitos, linhas e colunas (continua valida)
% 3) esvazia celulas ao acaso
% Observacao: com muitas celulas vazias o puzzle pode ter mais de uma
% solucao; o programa encontra uma delas.
% ---------------------------------------------------------------------
grade_base(Grade) :-
    findall(Linha,
            ( between(0, 8, R),
              findall(V,
                      ( between(0, 8, C),
                        V is (3 * (R mod 3) + R // 3 + C) mod 9 + 1 ),
                      Linha) ),
            Grade).
 
gerar_puzzle(Prob, Puzzle) :-
    grade_base(G0),
    embaralha_digitos(G0, G1),
    embaralha_linhas(G1, G2),
    transpose(G2, G3),
    embaralha_linhas(G3, G4),
    transpose(G4, G5),
    maplist(maplist(oculta(Prob)), G5, Puzzle).
 
embaralha_digitos(G0, G1) :-
    numlist(1, 9, Digitos),
    random_permutation(Digitos, Perm),
    maplist(maplist(troca_digito(Perm)), G0, G1).
 
troca_digito(Perm, V, V2) :- nth1(V, Perm, V2).
 
embaralha_linhas(G0, G1) :-
    random_permutation([0, 1, 2], Faixas),
    maplist(indices_faixa, Faixas, Grupos),
    append(Grupos, Indices),
    maplist(linha_de(G0), Indices, G1).
 
indices_faixa(F, Is) :-
    random_permutation([0, 1, 2], Ps),
    maplist(soma_faixa(F), Ps, Is).
 
soma_faixa(F, P, I) :- I is 3 * F + P.
linha_de(G, I, Linha) :- nth0(I, G, Linha).
 
% oculta/3: com probabilidade Prob a celula fica vazia (variavel livre)
oculta(Prob, Valor, Celula) :-
    random(R),
    (   R < Prob
    ->  true
    ;   Celula = Valor
    ).
 
% ---------------------------------------------------------------------
% EXECUCAO
% ---------------------------------------------------------------------
resolver :-
    puzzle_9x9(P),
    mostrar_e_resolver(P).
 
resolver_sem_solucao :-
    puzzle_sem_solucao(P),
    mostrar_e_resolver(P).
 
resolver_aleatorio :-
    resolver_aleatorio(0.6).
 
resolver_aleatorio(Prob) :-
    gerar_puzzle(Prob, P),
    mostrar_e_resolver(P).
 
mostrar_e_resolver(Puzzle) :-
    writeln('Tabuleiro inicial (. = vazio):'),
    imprime_tabuleiro(Puzzle),
    (   sudoku(Puzzle)
    ->  nl, writeln('Solucao encontrada:'),
        imprime_tabuleiro(Puzzle)
    ;   nl, writeln('Nao foi possivel encontrar solucao para este tabuleiro.')
    ).
 
% ---------------------------------------------------------------------
% IMPRESSAO DO TABULEIRO
% ---------------------------------------------------------------------
imprime_tabuleiro(Linhas) :-
    forall(nth0(I, Linhas, Linha),
           (   ( I > 0, I mod 3 =:= 0
               ->  writeln('------+-------+------')
               ;   true ),
               imprime_linha(Linha) )).
 
imprime_linha(Linha) :-
    forall(nth0(J, Linha, Celula),
           (   ( J > 0, J mod 3 =:= 0
               ->  write('| ')
               ;   true ),
               imprime_celula(Celula),
               write(' ') )),
    nl.
 
imprime_celula(X) :-
    (   var(X)
    ->  write('.')
    ;   write(X)
    ).