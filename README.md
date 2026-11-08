# Avaliação A2 \- Paradigmas de Linguagens de Programação

**Grupo 07** 

## 👥 Integrantes (3 a 5 alunos)

- \[Guilherme Lourenço Verardino (36388173)\]  
- \[Ruan Vitor Da Silva Santos (35173432)\]  
- \[Pétrus Pereira De Lima (39289575)\]  
- \[Andre Garcia Da Silva (35919108)\]  
- \[YEICOF PACO ALIAGA  (35520973)\]

## Definição do Tema

- **Paradigma:** \[Lógico\]  
- **Linguagem:** \[Prolog\]  
- **Código do Tema:** \[L3\]  
- **Descrição do Desafio:** \[Resolvedor de Sudoku 9x9 com restrições (CLP(FD)) e gerador de puzzles aleatórios\]

## Execução do Código

- **Ambiente Online Utilizado:** \[SWISH\]  
- **Permalink:** \[[https\://swish.swi-prolog.org/p/KCdZlbGS.pl](https://swish.swi-prolog.org/p/KCdZlbGS.pl)\]

### Instruções de Teste (Entrada e Saída)

*Explique de forma clara como executar o código no ambiente online linkado.*

1.Abra o SWISH em https\://swish.swi-prolog.org.

2.Na caixa **Query**, digite uma das consultas abaixo (sem o `?-`) e clique em **Run\!**. O programa não pede nenhuma entrada do usuário: o tabuleiro está definido no próprio código.

Consultas disponíveis:

| Consulta | O que faz |
| :---- | :---- |
| resolver | Resolve o puzzle predefinido (25 pistas, solução única). |
| resolver\_aleatorio | Gera um puzzle novo (60% das células vazias) e o resolve. A saída muda a cada execução. |
| resolver\_aleatorio(0.4) | Igual à anterior, escolhendo a fração de células vazias (0.0 a 1.0). |
| resolver\_sem\_solucao | Testa um puzzle inválido (dois 1 na mesma linha) e mostra a mensagem de erro. |

**Entrada de Exemplo:**

Consulta digitada no SWISH:

`resolver`

Tabuleiro definido em `puzzle_9x9/1` (cada `_` é uma célula vazia, ou seja, uma variável lógica):

`[_, _, _, _, 5, _, 6, _, _],`

`[_, _, _, 8, _, 2, 1, _, _],`

`[_, 3, _, _, _, _, _, _, 8],`

`[1, _, _, 3, _, _, _, _, 7],`

`[_, _, _, 9, 6, 8, _, 5, _],`

`[_, _, _, _, _, 1, _, 6, 3],`

`[_, _, _, _, 4, _, 7, _, _],`

`[4, _, _, 6, _, _, _, 1, _],`

`[3, 5, _, _, 8, _, _, _, _]`

**Saída Esperada:**

`Tabuleiro inicial (. = vazio):`

`. . . | . 5 . | 6 . .`

`. . . | 8 . 2 | 1 . .`

`. 3 . | . . . | . . 8`

`------+-------+------`

`1 . . | 3 . . | . . 7`

`. . . | 9 6 8 | . 5 .`

`. . . | . . 1 | . 6 3`

`------+-------+------`

`. . . | . 4 . | 7 . .`

`4 . . | 6 . . | . 1 .`

`3 5 . | . 8 . | . . .`

`Solução encontrada:`

`2 8 1 | 7 5 9 | 6 3 4`

`5 4 6 | 8 3 2 | 1 7 9`

`9 3 7 | 4 1 6 | 5 2 8`

`------+-------+------`

`1 6 5 | 3 2 4 | 8 9 7`

`7 2 3 | 9 6 8 | 4 5 1`

`8 9 4 | 5 7 1 | 2 6 3`

`------+-------+------`

`6 1 9 | 2 4 3 | 7 8 5`

`4 7 8 | 6 9 5 | 3 1 2`

`3 5 2 | 1 8 7 | 9 4 6`

Para `resolver_sem_solucao` a saída esperada é: "Não foi possível encontrar solução para este tabuleiro."

Para `resolver_aleatorio` o tabuleiro muda a cada execução; o esperado é sempre uma grade 9x9 completa, sem números repetidos em linhas, colunas ou blocos 3x3.

8 . . \| . . . \| . . .

1 . . \| 9 . . \| 7 . .

. . 4 \| . 8 . \| . 1 2

\------+-------+------

. . . \| . 7 1 \| 4 . 3

6 . . \| 5 . 8 \| . 7 .

7 . 1 \| . 6 3 \| . . 8

\------+-------+------

4 . 9 \| 1 . . \| 3 . .

. . . \| 8 . . \| . 5 .

. . 7 \| . . . \| 8 . .

Solução encontrada:

8 7 2 \| 6 1 4 \| 9 3 5

1 6 5 \| 9 3 2 \| 7 8 4

3 9 4 \| 7 8 5 \| 6 1 2

\------+-------+------

9 5 8 \| 2 7 1 \| 4 6 3

6 4 3 \| 5 9 8 \| 2 7 1

7 2 1 \| 4 6 3 \| 5 9 8

\------+-------+------

4 8 9 \| 1 5 6 \| 3 2 7

2 3 6 \| 8 4 7 \| 1 5 9

5 1 7 \| 3 2 9 \| 8 4 6 

Relatório Técnico

### Descrição da Solução

*O desafio escolhido foi resolver um Sudoku 9x9 clássico. A decisão central do grupo foi **não escrever um algoritmo de busca**: as regras do jogo foram declaradas como restrições sobre variáveis lógicas, e a biblioteca CLP(FD) do SWI-Prolog descobre os valores que faltam.*

***Modelagem.** O tabuleiro é uma lista de 9 listas com 9 elementos. Uma célula conhecida é um inteiro; uma célula vazia é uma variável lógica anônima (`_`). Todas as células recebem o domínio 1..9 com o operador `ins`.*

**Restrições.** Três regras são declaradas com `all_distinct/1`: (1) cada linha tem valores distintos, com `maplist(all_distinct, Linhas)`; (2) cada coluna tem valores distintos, usando `transpose/2` para trocar linhas por colunas; (3) cada bloco 3x3 tem valores distintos, usando o predicado auxiliar `blocos/3`.

**Busca.** A propagação das restrições já elimina muitos valores. As células que continuam ambíguas são resolvidas por `labeling([ff], Celulas)`, que escolhe primeiro a variável de menor domínio (\*first-fail\*) e volta atrás (\*backtracking\*) quando uma escolha gera conflito.

Núcleo do programa, o predicado `sudoku/1`:

`sudoku(Linhas) :-`

`&nbsp;length(Linhas, 9),`

`&nbsp;&nbsp;&nbsp;&nbsp;maplist(same_length(Linhas), Linhas),   % tabuleiro 9 x 9`

`&nbsp;append(Linhas, Celulas),`

`&nbsp;Celulas ins 1..9,                   	% dominio`

`&nbsp;maplist(all_distinct, Linhas),      	% linhas`

`&nbsp;transpose(Linhas, Colunas),`

`&nbsp;maplist(all_distinct, Colunas),     	% colunas`

`&nbsp;Linhas = [L1,L2,L3,L4,L5,L6,L7,L8,L9],`

`&nbsp;blocos(L1,L2,L3), blocos(L4,L5,L6), blocos(L7,L8,L9),`

`&nbsp;labeling([ff], Celulas).            	% busca`

**Arquitetura do código.** O arquivo tem quatro partes:

●     **Modelo:** `sudoku/1` e `blocos/3`. O `blocos/3` recebe três linhas consecutivas e, de três em três colunas, aplica `all_distinct` a cada bloco, por recursão sobre as listas (caso base `blocos([],[],[])`).

●     **Dados:** `puzzle_9x9/1` (puzzle predefinido, solução única) e `puzzle_sem_solucao/1` (dois 1 na mesma linha).

●     **Gerador de puzzles aleatórios:** `gerar_puzzle/2` parte de uma grade completa válida (`grade_base/1`, calculada por fórmula) e a embaralha mantendo a validade: permutação aleatória dos dígitos, das faixas de linhas e das linhas dentro de cada faixa, e o mesmo para colunas (via `transpose/2`). Por fim, `oculta/3` esvazia cada célula com probabilidade `Prob`.

●     **Execução e impressão:** `resolver/0`, `resolver_aleatorio/0,1`, `resolver_sem_solucao/0` e `mostrar_e_resolver/1`, que imprime o tabuleiro, chama `sudoku/1` e, se o predicado falhar, mostra a mensagem de erro (if-then-else com `->`). `imprime_tabuleiro/1` desenha a grade com `forall/2` e `nth0/3`.

O mesmo `sudoku/1` serve para o puzzle predefinido, os aleatórios e o inválido: basta passar outra lista de listas. Isso acontece porque o programa descreve a relação "este tabuleiro é uma solução válida", e não um procedimento.

### Análise Comparativa

*Comparação entre Prolog com CLP(FD) (paradigma lógico) e C, Java e Python (imperativo e orientado a objetos), usando o código do Sudoku como exemplo.*

### 1\. Sintaxe

*Em Prolog não há comandos, laços (`for`/`while`) nem variáveis alteradas por atribuição. O programa é um conjunto de cláusulas (fatos e regras) terminadas por ponto, e a repetição vem da recursão e do backtracking. A solução fica bem mais curta: o modelo do Sudoku (`sudoku/1` e `blocos/3`) tem cerca de 15 linhas, enquanto uma versão imperativa com backtracking explícito costuma ter de 40 a 60\.*

*Exemplo: a regra "linhas sem repetição" é uma linha em Prolog:*

*`maplist(all_distinct, Linhas),`*

*Em C seria preciso escrever o teste de validade com laços aninhados:*

*`int valido(int g[9][9], int r, int c, int v) {`*

*`&nbsp;&nbsp;&nbsp;&nbsp;for (int k = 0; k < 9; k++)`*

*`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (g[r][k] == v || g[k][c] == v) return 0;`*

*`&nbsp;&nbsp;&nbsp;&nbsp;int br = r/3*3, bc = c/3*3;`*

*`&nbsp;&nbsp;&nbsp;&nbsp;for (int i = 0; i < 3; i++)`*

*`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;for (int j = 0; j < 3; j++)`*

*`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (g[br+i][bc+j] == v) return 0;`*

*`&nbsp;return 1;`*

*`}`*

*`/* ...e ainda a funcao recursiva que acha a proxima celula vazia,`*

*`&nbsp;&nbsp;&nbsp;tenta 1..9, chama a si mesma e desfaz a atribuicao se falhar. */`*

*Outras diferenças: variáveis começam com letra maiúscula ou `_` (átomos e predicados, com minúscula); listas usam colchetes e `[Cabeca|Cauda]`; o resultado de uma "função" é um argumento do predicado (`transpose(Linhas, Colunas)` em vez de `colunas = transpose(linhas)`); e os operadores do CLP(FD) (`#=`, `#\=`, `ins`, `..`) misturam restrição e aritmética numa notação próxima da matemática.*

### 2\. Semântica

***Unificação versus atribuição.** Em C, Java ou Python, `x = 5` copia um valor para um local de memória que pode ser sobrescrito. Em Prolog a variável é lógica: começa livre e, ao ser unificada com um valor, passa a tê-lo naquele ramo da computação; não pode ser reatribuída, e só volta a ser livre quando o backtracking desfaz a unificação. No Sudoku, as células vazias (`_`) são variáveis livres que o solver vai ligando a valores.*

***Tipos.** Tipagem dinâmica: não há declaração de tipos e os dados são termos (inteiros, átomos, listas, estruturas). Um erro de tipo só aparece na execução, ao contrário de C e Java, em que os tipos são verificados na compilação.*

***Escopo.** O escopo de uma variável é a cláusula onde ela aparece. Não há variáveis globais nem blocos aninhados como em C. Os dados são compartilhados passando argumentos, como a lista `Linhas`, que vai de `sudoku/1` para `blocos/3`.*

***Forma de avaliação.** A execução usa resolução SLD: objetivos da esquerda para a direita, cláusulas de cima para baixo, em profundidade e com backtracking (não é avaliação preguiçosa nem estrita como em linguagens funcionais). No CLP(FD), uma restrição como `all_distinct` não é calculada na hora: ela é registrada na variável e reativada (propagação) sempre que o domínio de uma variável envolvida muda. Por isso o `labeling` só começa depois que a propagação já reduziu os domínios. É a mesma diferença entre `X is 1+2` (aritmética comum, exige o lado direito já calculado) e `X #= 1+2` (restrição, funciona mesmo com variáveis livres).*

***Determinismo.** Um predicado pode ter várias respostas. Em `resolver_aleatorio(0.9)` há muitas soluções válidas, e o `->` em `mostrar_e_resolver/1` corta as alternativas para imprimir só a primeira.*

### 3\. Gerenciamento de Memória

*Em C, o programador aloca e libera memória (`malloc`/`free`) e responde por vazamentos e ponteiros inválidos. Em Java, a JVM executa bytecode e coleta o lixo automaticamente no heap. O SWI-Prolog fica mais perto de Java: roda numa máquina virtual própria (variação da WAM, \*Warren Abstract Machine\*) e nunca expõe ponteiros ao programador.*

*Internamente usa pilhas: a pilha local (registros das chamadas), a pilha global (termos, listas e estruturas) e o \*trail\* (registro das ligações de variáveis que precisam ser desfeitas no backtracking). Duas características se destacam:*

*●*     ***O backtracking também recupera memória:** ao voltar a um ponto de escolha, o topo da pilha global é cortado e tudo o que foi alocado depois dele é descartado de uma vez, o que é mais barato do que coletar lixo objeto por objeto.*

*●*     ***Coleta de lixo automática:** quando as pilhas crescem, o coletor recupera termos inacessíveis (e átomos sem uso). Os limites de pilha são configuráveis, e o SWISH impõe um limite de memória por consulta.*

*No CLP(FD), as restrições ficam em atributos das variáveis e os propagadores na pilha global. Para o Sudoku 9x9 isso é pouco (81 variáveis e 27 restrições), mas em problemas maiores o custo de memória dos propagadores pode pesar mais do que o da busca.*

Para este desafio, o paradigma lógico com restrições é um bom encaixe, porque o Sudoku já é um problema de satisfação de restrições (variáveis, domínios finitos e restrições \*all-different\*). A desvantagem é a menor transparência: o grupo não controla a ordem das tentativas, e o desempenho depende de a modelagem aproveitar a propagação (por exemplo, `all_distinct/1` é mais forte que `all_different/1`, mas custa mais).

### **Resumo da Análise Comparativa**

Pontos principais da comparação com C, Java e Python:

●     **Sintaxe:** Sem laços, atribuições nem comandos; o programa é um conjunto de fatos e regras. As regras do Sudoku viram três chamadas de all\_distinct/1, no lugar de laços aninhados em C. A solução fica mais curta e declarativa.

●     **Semântica:** Tipagem dinâmica, escopo restrito à cláusula e variáveis lógicas que se unificam em vez de receber atribuição (uma variável é ligada uma só vez por ramo). Avaliação por resolução em profundidade com backtracking; as restrições do CLP(FD) são registradas e propagadas, não calculadas na hora.

●     **Gerenciamento de Memória:** Automático, numa máquina virtual (WAM) com pilhas local e global, trail e coleta de lixo; o backtracking recupera a memória das tentativas descartadas. Sem malloc/free como em C e sem JVM como em Java.

●     **Trade-offs:** Vantagens: código curto, regras explícitas, o solver faz a busca, e um modelo serve para resolver, completar e validar. Desvantagens: curva de aprendizado, pouco controle sobre a busca, desempenho menos previsível e depuração mais difícil.

### 4\. Trade-offs

| *Aspecto* | *CLP(FD) em Prolog (lógico)* | *Backtracking em C/Java (imperativo/OO)* |
| :---- | :---- | :---- |
| *Tamanho e clareza* | *Código curto; as regras do jogo aparecem explícitas.* | *Código mais longo; as regras se misturam com o controle da busca.* |
| *Quem controla a busca* | *O solver (propagação \+ labeling). O programador só escolhe opções, como \[ff\].* | *O programador escreve a busca e as podas.* |
| *Reaproveitamento* | *O mesmo modelo resolve, completa ou verifica tabuleiros; basta mudar a consulta.* | *Em geral serve para uma direção só (resolver).* |
| *Desempenho* | *Mais difícil de prever; depende da modelagem e da propagação.* | *Mais fácil de medir e otimizar, com controle total do laço.* |
| *Aprendizado* | *Curva difícil no início (unificação, backtracking, restrições).* | *Mais familiar para quem já programa em C, Java ou Python.* |
| *Depuração* | *Um "false" não diz qual restrição causou o conflito.* | *Depuradores e pilha de chamadas maduros.* |
| *Memória* | *Gerenciada pela VM; pilhas e propagadores consomem memória.* | *C: manual e enxuta; Java: heap com GC.* |

### Resumo da Análise Comparativa

*Compare a linguagem/paradigma estudado com os que você já domina (C, Java ou Python). O detalhamento completo deve estar no PDF, mas inclua os pontos principais aqui.*

* **Sintaxe:** (O que muda na forma de escrever a solução?)  
* **Semântica:** (Tipos, escopo, forma de avaliação \- ex: estrita vs. preguiçosa, unificação vs. atribuição)  
* **Gerenciamento de Memória:** (Coleta de lixo automática vs. gerenciamento manual)  
* **Trade-offs:** (Vantagens e desvantagens do novo paradigma em relação aos anteriores)

## Log de Uso de Inteligência Artificial (IA)

*O uso de IA (ChatGPT, Claude, Gemini, etc.) é permitido e incentivado para aprendizado, mas deve ser documentado. Preencha o log abaixo:*

* **O que foi pedido à IA:** \[Os prompts foram feitos em etapas, do conceito até o código: Explicar o paradigma lógico e como o Sudoku vira um problema de satisfação de restrições em Prolog com CLP(FD). Gerar um código em Prolog para o Sudoku 9x9, com puzzle predefinido, gerador de puzzles aleatórios e tratamento de puzzle sem solução. Explicar termos do código, como o significado de “FD” (*Finite Domain*), `ins`, `all_distinct/1`, `transpose/2` e `labeling/2`.\]  
* **Qual IA foi utilizada:** \[ChatGPT, Claude Code e Gemini\]  
* **O que foi aproveitado:** \[**Código:** a estrutura do `sudoku/1`, com domínio 1..9 via `ins`, restrições `all_distinct/1` em linhas, colunas (com `transpose/2`) e blocos 3x3 (predicado auxiliar `blocos/3`), e busca com `labeling([ff], ...)`. Também o gerador de puzzles aleatórios e o tratamento de puzzle inválido. **Explicações:** os conceitos de CLP(FD), propagação de restrições e *backtracking*, a diferença entre `is` e `#=`, e a comparação de sintaxe, semântica, memória e trade-offs. **Verificação:** a saída esperada do puzzle predefinido foi conferida com um resolvedor independente em Python, que confirmou que a solução é única.\]  
* **O que foi reescrito/entendido pelo grupo:** \[Executamos o código no SWISH e comparamos a saída com a esperada. Reescrevemos as explicações conforme a expectativa, porém utilizamos a IA para auxiliar a escrita.\]

