# BITWAY — Pedido de Venda

Teste técnico para a vaga de **Analista Desenvolvedor Delphi** na Bitway Sistemas.

Aplicação desktop desenvolvida em **Delphi** com persistência em **Firebird 3.0** via **FireDAC**, seguindo boas práticas de organização em camadas (Repository/Service), Clean Code e queries parametrizadas.

---

## Índice

- [Pré-requisitos](#pré-requisitos)
- [Estrutura do projeto](#estrutura-do-projeto)
- [Criando o banco de dados](#criando-o-banco-de-dados)
- [Configurando o INI](#configurando-o-ini)
- [Executando o projeto](#executando-o-projeto)
- [Roteiro de testes manuais](#roteiro-de-testes-manuais)
- [Executando os testes unitários](#executando-os-testes-unitários)
- [Decisões técnicas relevantes](#decisões-técnicas-relevantes)

---

## Pré-requisitos

| Ferramenta | Versão mínima |
|---|---|
| Delphi | 10.4 Sydney ou superior |
| Firebird Server | 3.0 |
| fbclient.dll | 3.0 (incluída em `/bin`) |

---

## Estrutura do projeto

```
BITWAY-PedidoVenda/
│
├── bin/
│   ├── fbclient.dll          # Client library do Firebird 3.0
│   └── config.ini.example    # Modelo de configuração
│
├── database/
│   ├── create-database.sql   # Cria o arquivo .fdb
│   └── db.sql                # DDL + inserts de carga
│
└── src/
    ├── app/
    │   └── UMain             # Tela principal (View)
    ├── connection/
    │   ├── UConfigINI        # Leitura do config.ini
    │   └── UDM               # DataModule com TFDConnection
    ├── entities/
    │   ├── UEntityBase       # Classe base das entidades
    │   ├── UCliente
    │   ├── UProduto
    │   ├── UPedido           # Agrega TObjectList<TPedidoItem>
    │   └── UPedidoItem       # Auto-calcula VlrTotal nos setters
    ├── repositories/
    │   ├── URepositoryBase   # Base genérica com ObterPorCodigo
    │   ├── UClienteRepository
    │   ├── UProdutoRepository
    │   └── UPedidoRepository # Gravar/Carregar/Excluir com transação
    ├── services/
    │   └── UPedidoService    # Validações e orquestração
    └── tests/
        └── UPedidoVendaTests # Testes unitários com DUnitX
```

---

## Criando o banco de dados

### 1. Criar o arquivo .fdb

Execute o script abaixo via **isql**, **FlameRobin** ou **IBExpert**, ajustando o caminho conforme seu ambiente:

```sql
CREATE DATABASE 'C:\BITWAY-PedidoVenda\database.fdb'
  USER 'SYSDBA' PASSWORD 'masterkey'
  PAGE_SIZE = 4096
  DEFAULT CHARACTER SET UTF8;
```

Ou use o arquivo pronto:

```
database/create-database.sql
```

### 2. Rodar o script DDL + carga

Com o banco criado, conecte nele e execute:

```
database/db.sql
```

O script cria:
- Sequences `SEQ_PEDIDO` e `SEQ_PEDIDO_ITEM`
- Tabelas `CLIENTE`, `PRODUTO`, `PEDIDO`, `PEDIDO_ITEM`
- Triggers de auto-incremento
- Índices e chaves estrangeiras
- 10 clientes e 10 produtos para teste

> **Atenção:** execute os scripts na ordem acima. O `db.sql` pressupõe que o banco já existe.

---

## Configurando o INI

Copie o arquivo de exemplo e renomeie:

```
bin/config.ini.example  →  bin/config.ini
```

Edite com os dados do seu ambiente:

```ini
[DATABASE]
Server=localhost
Port=3050
Database=C:\BITWAY-PedidoVenda\database.fdb
Username=SYSDBA
Password=masterkey
ClientLibrary=.\fbclient.dll
```

| Chave | Descrição |
|---|---|
| `Server` | IP ou hostname do servidor Firebird |
| `Port` | Porta TCP (padrão: 3050) |
| `Database` | Caminho completo do arquivo `.fdb` |
| `Username` | Usuário do banco |
| `Password` | Senha do usuário |
| `ClientLibrary` | Caminho para o `fbclient.dll` |

> O `fbclient.dll` do Firebird 3.0 está incluído em `/bin`. Se o Firebird já estiver instalado na máquina, pode apontar para `C:\Program Files\Firebird\Firebird_3_0\fbclient.dll`.

> O `config.ini` deve estar na **mesma pasta do executável** (`PedidoVenda.exe`).

---

## Executando o projeto

### Via Delphi IDE

1. Abra o group project: `src/grpPedidoVenda.groupproj`
2. Defina `PedidoVenda` como projeto ativo
3. Compile e execute (`F9`)
4. Certifique-se de que o `config.ini` está em `src/Win32/Debug/` (ou no diretório de saída configurado)

### Via executável compilado

1. Copie para uma pasta o `PedidoVenda.exe`, o `fbclient.dll` e o `config.ini`
2. Execute o `PedidoVenda.exe`

---

## Roteiro de testes manuais

Os testes abaixo cobrem todos os requisitos funcionais do desafio.

---

### 1. Cliente inválido

1. No campo **Cód. Cliente**, informe um código inexistente (ex: `999`)
2. Pressione TAB para sair do campo
3. **Resultado esperado:** mensagem "Cliente não encontrado"

---

### 2. Novo pedido com um item

1. Clique em **Novo Pedido**
2. No campo **Cód. Cliente**, informe `1` e pressione TAB
3. Verifique que **Nome**, **Cidade** e **UF** foram preenchidos automaticamente (somente leitura)
4. No campo **Cód. Produto**, informe `1` e pressione TAB
5. Verifique que **Descrição** e **Valor Unitário** foram preenchidos automaticamente
6. No campo **Quantidade**, informe `2`
7. Clique em **Inserir/Atualizar Item**
8. **Resultado esperado:** item aparece no grid, total do pedido atualizado no rodapé
9. Clique em **Gravar Pedido**
10. **Resultado esperado:** mensagem de sucesso com número do pedido gerado

---

### 3. Produtos repetidos

1. Com um pedido aberto, informe o mesmo **Cód. Produto** duas vezes com quantidades diferentes
2. **Resultado esperado:** dois itens distintos no grid (linhas separadas)

---

### 4. Editar item via teclado (ENTER)

1. Com itens no grid, clique sobre um item
2. Pressione **ENTER**
3. **Resultado esperado:** campos de produto/quantidade/valor são preenchidos para edição
4. Altere a quantidade e clique em **Inserir/Atualizar Item**
5. **Resultado esperado:** item atualizado no grid, total recalculado

---

### 5. Excluir item via teclado (DEL)

1. Com itens no grid, selecione um item
2. Pressione **DEL**
3. Confirme a exclusão
4. **Resultado esperado:** item removido do grid e **total do pedido recalculado imediatamente**

---

### 6. Gravar pedido sem cliente

1. Clique em **Novo Pedido**
2. Adicione um item sem informar o cliente
3. Clique em **Gravar Pedido**
4. **Resultado esperado:** mensagem de validação "Informe o cliente"

---

### 7. Gravar pedido sem itens

1. Clique em **Novo Pedido**
2. Informe um cliente válido
3. Clique em **Gravar Pedido** sem adicionar itens
4. **Resultado esperado:** mensagem de validação "Pedido sem itens"

---

### 8. Carregar pedido existente (bônus)

1. Anote o número de um pedido gravado no teste 2
2. Clique em **Novo Pedido** para limpar a tela
3. Informe o número no campo **Nº Pedido** e clique em **Carregar**
4. **Resultado esperado:** cabeçalho e itens carregados corretamente

---

### 9. Cancelar pedido (bônus)

1. Com um pedido carregado na tela, clique em **Cancelar Pedido**
2. Confirme a operação
3. **Resultado esperado:** pedido e itens excluídos do banco, tela limpa
4. Tente carregar o mesmo número novamente
5. **Resultado esperado:** mensagem "Pedido não encontrado"

---

### 10. Observação no pedido

1. Clique em **Novo Pedido**
2. Informe cliente, item e preencha o campo **Observação**
3. Grave o pedido
4. Carregue o pedido pelo número
5. **Resultado esperado:** campo Observação exibido com o texto informado

---

## Executando os testes unitários

1. No Delphi IDE, defina `PedidoVendaTests` como projeto ativo no group project
2. Compile e execute (`F9`)
3. O runner do DUnitX exibe os resultados no console

Os testes cobrem:
- Cálculo do total do item ao setar quantidade e valor unitário
- Recálculo automático ao alterar qualquer campo
- Cálculo do total do pedido com múltiplos itens
- Recálculo do total do pedido após exclusão de item
- Permissão de produtos repetidos em linhas distintas
- Valores fracionados e edge cases (item com valor zero, pedido sem itens)

---

## Decisões técnicas relevantes

**Produtos repetidos:** ao digitar um código de produto manualmente, sempre insere uma nova linha. A atualização de linha existente só ocorre quando o item foi carregado via ENTER no grid — esse comportamento foi documentado pois o requisito é ambíguo nesse ponto.

**`TRepositoryBase<T>` com generics:** a base genérica centraliza o `ObterPorCodigo` parametrizado e o `ValidarSeExiste`, evitando duplicação nas implementações de `TClienteRepository` e `TProdutoRepository`.

**`TPedidoItem` com self-calculation:** os setters de `Quantidade` e `VlrUnitario` recalculam `VlrTotal` automaticamente, garantindo que a entidade nunca fique em estado inconsistente.

**Atualizar pedido com delete/insert dos itens:** na operação de atualização, os itens existentes são excluídos e reinseridos. Essa abordagem simplifica o controle de estado em tela e é segura dado o volume esperado para um pedido de venda.

**`config.ini` lido em runtime:** a conexão FireDAC é configurada dinamicamente via `TConfigINI`, sem nenhuma credencial hardcoded no código ou no DFM.
