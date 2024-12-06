
# Documentação de Funções ADVPL

## GFEA1181

**Descrição**:  
A função `GFEA1181` altera a tributação de um registro na tabela `GXG` para o valor "2-Isento", caso a tributação atual não seja "1-Tributado" ou "2-Isento". Além disso, zera os valores relacionados ao imposto.

**Detalhes**:
- **Autor**: Thalys Augusto  
- **Data de criação**: 27/11/2024  
- **Versão**: 1.0  
- **Bibliotecas utilizadas**: `Totvs.ch`

**Fluxo de funcionamento**:  
1. Captura o valor da tributação (`GXG_TRBIMP`) e o valor base de imposto (`GXG_VLDF`) do registro atual.
2. Verifica se a tributação atual é diferente de "1-Tributado" e "2-Isento".
3. Caso a condição seja verdadeira:
   - Realiza o bloqueio do registro para edição.
   - Zera os valores de imposto (`GXG_VLIMP`, `GXG_PCIMP`) e define a base de imposto (`GXG_BASIMP`).
   - Altera o valor da tributação para "2-Isento".
   - Libera o registro após a alteração.

**Parâmetros**:  
Nenhum.

**Retorno**:  
Nenhum.

**Código**:

```advpl
#Include "Totvs.ch"

/*/{Protheus.doc} GFEA1181
	A função GFEA1181 altera a tributação de um registro na tabela `GXG` para o valor "2-Isento", 
	caso a tributação atual não seja "1-Tributado" ou "2-Isento". 
	Além disso, zera os valores relacionados ao imposto.

@author Thalys Augusto
@since 27/11/2024
@version 1.0
@type function
/*/
User Function GFEA1181()
    Local aArea   := FWGetArea()
    Local cTRBIMP := GXG->GXG_TRBIMP
    Local nBaseImp := GXG->GXG_VLDF

    // Caso 1: Alterar tributação para "2-Isento" se não for "1-Tributado" ou "2-Isento"
    If !cTRBIMP $ ("1", "2")
        // Realiza gravação na tabela
        RecLock('GXG', .F.)
        GXG->GXG_VLIMP := 0
        GXG->GXG_PCIMP := 0
        GXG->GXG_BASIMP := nBaseImp
        GXG->GXG_TRBIMP := "2"
        GXG->(MsUnlock())
    EndIf

    FWRestArea(aArea)
Return Nil
```

---

## GFEA1157

**Descrição**:  
A função `GFEA1157` executa ajustes nos valores e atributos tributários de uma tabela chamada `GW3`.  
Realiza ajustes específicos em casos de isenção de imposto ou quando há valores de pedágio.

**Detalhes**:
- **Autor**: Thalys Augusto  
- **Data de criação**: 27/11/2024  
- **Versão**: 1.0  
- **Bibliotecas utilizadas**: `Totvs.ch`

**Fluxo de funcionamento**:  
1. Captura os valores das colunas `GW3_TRBIMP`, `GW3_ICMPDG`, e `GW3_PEDAG`.
2. **Caso 1**: Se o valor da tributação for "2-Isento":
   - Zera os valores de imposto, base de imposto e alíquota.
3. **Caso 2**: Se o campo `GW3_ICMPDG` for "2-Não" e houver pedágio:
   - Define `GW3_ICMPDG` como "1-Sim".
   - Ajusta outros campos relacionados, como `GW3_PDGPIS`.

**Parâmetros**:  
Nenhum.

**Retorno**:  
Nenhum.

**Código**:

```advpl
#Include "TOTVS.ch"

/*/{Protheus.doc} GFEA1157

A função GFEA1157 executa ajustes nos valores e atributos tributários de uma tabela chamada 'GW3'.  
Realiza ajustes específicos em casos de isenção de imposto ou quando há valores de pedágio.

@author Thalys Augusto
@since 27/11/2024
@version 1.0
@type function
/*/
User Function GFEA1157()

    Local oModelGW3 := PARAMIXB[1]
    Local cTRBIMP := FWFldGet("GW3_TRBIMP")
    Local cICMPDG := FWFldGet("GW3_ICMPDG")
    Local nPedagio := FWFldGet("GW3_PEDAG") // Valor do pedágio, se aplicável

    // Caso 1: Garantir que Valor e Base de Imposto sejam zerados para Isento/Não-tributado
    If cTRBIMP == "2" // 2-Isento
        oModelGW3:SetValue("GFEA065_GW3", "GW3_VLIMP", 0) // Zera o valor do imposto
        oModelGW3:SetValue("GFEA065_GW3", "GW3_BASIMP", 0) // Zera a base do imposto
        oModelGW3:SetValue("GFEA065_GW3", "GW3_PCIMP", 0) // Zera Aliquota Imposto
    EndIf

    // Caso 2: Forçar GW3_ICMPDG para "1-Sim" se estiver "2-Não" e houver pedágio
    If cICMPDG == "2" .And. nPedagio > 0
        oModelGW3:SetValue("GFEA065_GW3", "GW3_ICMPDG", "1")
        oModelGW3:SetValue("GFEA065_GW3", "GW3_PDGPIS", "2")
    EndIf

Return
```
