; v1版本
; MsgBox, % GetFirstChar("你好呀") ; 输出“NHY”;
; 功能: 中文转为拼音首字母，非中文保持不变
; 备注: 在 AutoHotkey Unicode 中运行

#Requires AutoHotkey v1.1+
#NoEnv
FileEncoding, UTF-8

MsgBox, % GetFirstChar("你好呀") ; 输出“NHY”;
MsgBox, % GetFirstChar("Hello 你好") ; 输出“Hello HN”
MsgBox, % GetFirstChar("Unicode 中运行") ; 输出“Unicode ZYX”

GetFirstChar(str)
{
	static nothing := VarSetCapacity(var, 2)
	static array   := [ [-20319,-20284,"A"], [-20283,-19776,"B"], [-19775,-19219,"C"], [-19218,-18711,"D"], [-18710,-18527,"E"], [-18526,-18240,"F"], [-18239,-17923,"G"], [-17922,-17418,"H"], [-17417,-16475,"J"], [-16474,-16213,"K"], [-16212,-15641,"L"], [-15640,-15166,"M"], [-15165,-14923,"N"], [-14922,-14915,"O"], [-14914,-14631,"P"], [-14630,-14150,"Q"], [-14149,-14091,"R"], [-14090,-13319,"S"], [-13318,-12839,"T"], [-12838,-12557,"W"], [-12556,-11848,"X"], [-11847,-11056,"Y"], [-11055,-10247,"Z"] ]
	
	; 如果不包含中文字符，则直接返回原字符
	if !RegExMatch(str, "[^\x{00}-\x{ff}]")
		Return str
	Loop, Parse, str
	{
		if ( Asc(A_LoopField) >= 0x2E80 and Asc(A_LoopField) <= 0x9FFF )
		{
			StrPut(A_LoopField, &var, "CP936")
			nGBKCode := (NumGet(var, 0, "UChar") << 8) + NumGet(var, 1, "UChar") - 65536
			For i, a in array
				if nGBKCode between % a.1 and % a.2
				{
					out .= a.3
					Break
				}
		}
		else
			out .= A_LoopField
	}
	Return out
}