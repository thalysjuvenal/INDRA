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
