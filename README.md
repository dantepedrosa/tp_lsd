# Descrição FSM

Aqui vao **todos os estados**, **entradas (botoes)** e **sinais de saida** que aparecem na FSM da imagem.

---

# ✅ **Estados identificados**

1. **CRONOMETRO PAUSADO**
2. **CRONOMETRO CONTANDO**
3. **RELOGIO CONTANDO**
4. **SETAR MINUTOS**
5. **SETAR HORAS**

Total: **5 estados**.

---

# ✅ **Entradas (botoes) detectadas**

### **1. ACTION**

Usado nos eventos:

* Start
* Stop
* Increment
* inc_min
* inc_hour

### **2. S/R**

Usado para:

* Set (clock)
* Reset (stopwatch timer)

### **3. MODE**

Usado para alternar entre:

* relogio
* cronometro
* setar horas/minutos

Portanto, **entradas sao:**

* **ACTION**
* **S/R**
* **MODE**

---

# ✅ **Sinais de saida identificados (gerados pela FSM)**

Da legenda da imagem, aparecem estes sinais:

### **Saidas de controle do cronometro**

* **rst_stpwtch**: reset do cronometro
* **stpwtch_en**: habilita contagem do cronometro

### **Saidas de modo**

* **watch_mode**: indica que o relogio esta ativo
* **set_min**: modo de ajuste de minutos
* **set_hour**: modo de ajuste de horas

### **Saidas de incremento**

* **inc_min**: incrementa um minuto
* **inc_hour**: incrementa uma hora

---

# 📌 **Resumo final**

### **Estados**

* Cronometro Pausado
* Cronometro Contando
* Relogio Contando
* Setar Minutos
* Setar Horas

### **Entradas**

* ACTION
* S/R
* MODE

### **Saidas**

* rst_stpwtch
* stpwtch_en
* watch_mode
* set_min
* set_hour
* inc_min
* inc_hour

# Descrição Datapath

Quero criar um caminho de dados que implemente baseado nos sinais da FSM.

Pode ser dividido entre dois arquivos: watch_datapath.vhd e stpwtch_datapath.vhd.

Para o caminho de dados do cronometro, existem 4 contadores: stpwtch_min_2, stpwtch_min_1, stpwtch_sec_2 e stpwtch_sec_1.

O stpwtch_sec_1 possui no clock um pulso constante de 1 Hz. No clear a lógica é que ao passar de 9 ele reseta. e o carryout vai para o clk do stpwtch_sec_2. Para o count, basicamente é a saída da fsm stpwtch_en.
Os outros 3 contadores funcionam da seguinte forma: o count sempre ativo, o clock é o cout do contador anterior e o reset segue a lógica 59 59 (minutos e segundos)

PAra o caminho de dados do relógio, existem 5 contadores: 
watch_hour_2
watch_hour_1
watch_min_2
watch_min_1
watch_sec

A lógica para o watch_sec é receber um clock de 1Hz com clear setado para quando passar de 59 e count sempre habilitado.
Os demais recebem o clock do anterior, count sempre habilitado e clear com resets respectivos para contar até 2 3 5 e 9. 
Para os watch_min_1 e watch_hour_1, o clock possui lógica de entrada de COUT(anterior) OU (set_hour AND ACTION)

NEste caso ACTION seria diretamente o sinal do botão ACTION. Na FSM está descrito uma saída mas acredito que seja melhor simplesmente puxar o sinal de ACTION.

Todos os contadores citados exceto o de watch_sec devem ter saídas BCD (4 bits) para enviar para um decodificador (a ser implementado posteriormente). COnsidere o generic do counter como 4 bits (eu alterei)

Para a lógica dos displays, as saídas de cada um dos contadores vão para multiplexadores 2x1 sendo a seguir:

MUX4
1 - dezenas de horas do watch
0 - dezenas de minutos do stopwatch

MUX3
1 - unidades de horas do watch
0 - Unidades de minutos do stopwatch

MUX2
1 - dezenas de minutos do watch
0 - dezenas de segundos do stopwatch

MUX1
1 - unidades de minutos do watch
0 - Unidades de segundos do stopwatch


O sinal que determina qual mux mostrar vem da saída da FSM watch_mode.

De cada MUX, sairá um barramento BCD de 4 bits para o decodificador.

Agora quero que me instrua como juntar com os datapaths existentes. Caso você indique trocar para apenas um arquivo datapath, seguirei sua sugestão.


#  FSM

Para a FSM, quero que construa um arquivo fsm.vhd com a seguinte estrutura, baseada no livro, para que eu possa trabalhar nela e ajustar o necessário:

.std_logic_1164.all;
-- entity
entity fsmx is
Port ( BUM1,BUM2 : in std_logic;
CLK : in std_logic;
TOUT,CTA : out std_logic);
end fsmx;
-- architecture
architecture my_fsmx of fsmx is
type state_type is (S1,S2,S3);
signal PS,NS : state_type;
begin
sync_p: process (CLK)
begin
if (rising_edge(CLK)) then
PS <= NS;
end if;
end process sync_p;
comb_p: process (CLK,BUM1,BUM2)
begin
case PS is
when S1 =>
CTA <= '0';
if (BUM1 = '0') then
TOUT <= '0';
NS <= S1;
elsif (BUM1 = '1') then
TOUT <= '1';
NS <= S2;
end if;
when S2 =>
CTA <= '0';
TOUT <= '0';
NS <= S3;
when S3 =>
CTA <= '1';
TOUT <= '0';
if (BUM2 = '1') then
NS <= S1;
elsif (BUM2 = '0') then
NS <= S2;
end if;
when others => CTA <= '0';
TOUT <= '0';
NS <= S1;
end case;
end process comb_p;
end my_fsmx;


Quero apennas que siga a mesma estrutura lógica, altere os nomes dos estados, variáveis para condizer com a FSM já definida.

# Testbench

Para o testbench, será necessário realizar os seugintes ensaios:


- Deixar relógio rodando por 15 segundos
- Mudar para o modo timer, iniciar timer, pausar timer após 10 segundos e resetar timer.
- Voltar para mmodo relógio e Deixar relógio rodando por 15 segundos