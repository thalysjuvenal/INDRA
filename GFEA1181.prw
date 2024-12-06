//Bibliotecas
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
		//Realiza gravação na tabela
		RecLock('GXG', .F.)
		GXG->GXG_VLIMP := 0
		GXG->GXG_PCIMP := 0
		GXG->GXG_BASIMP := nBaseImp
		GXG->GXG_TRBIMP := "2"
		GXG->(MsUnlock())
	EndIf

	FWRestArea(aArea)
Return Nil
