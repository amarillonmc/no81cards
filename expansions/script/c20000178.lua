--忍缚之圣沌 圆月
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.T_initial()
--e1
cm.e1 = fuef.A():CAT("NEGE"):PRO("TG"):Func("tg1,op1")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = fugf.GetFilter(tp,"+M","TgChk+NegateMonsterFilter",e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)	
	fugf.SelectTg(tp,"+M","TgChk+NegateMonsterFilter",e)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e)) then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1 = fuef.S(e,EFFECT_DISABLE,tc):RES("STD+PH/ED")(EFFECT_MUST_ATTACK)
	e1(EFFECT_DISABLE_EFFECT):VAL(RESET_TURN_SET)
	local g = fugf.GetFilter(tp,"+S","IsPos","FD")
	if fu_HC.chk[tp+1]==0 or #g==0 then return end
	Duel.BreakEffect()
	e1(EFFECT_CANNOT_TRIGGER,g):DES(0):PRO("HINT"):RES("STD+PH/ED",2)
end