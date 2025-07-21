--忍缚之圣沌 圆月
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.Initial()
--e1
cm.e1 = fuef.A():Cat("NEGE"):Pro("TG"):Func("tg1,op1")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = fugf.GetFilter(tp,"+M","TgChk+NegateMonsterFilter",e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)	
	fugf.SelectTg(tp, g)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc = fusf.GetTarget(e, "FU")
	if not tc:IsCanBeDisabledByEffect(e) then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1 = fuef.S(e,EFFECT_DISABLE,tc):Res("STD+ED")(EFFECT_MUST_ATTACK)
	e1(EFFECT_DISABLE_EFFECT):Val(RESET_TURN_SET)
end
--e2
cm.e2 = fuef.QO():Ctl(m):Ran("G"):Func("con2,bfgcost,op2")
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return fu_HC.IsMantraAct(tp)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	fuef.F(e,EFFECT_PATRICIAN_OF_DARKNESS,1):Pro("PTG"):Tran(0,1)
end