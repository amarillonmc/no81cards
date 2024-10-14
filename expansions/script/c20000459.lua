--威天之创导龙
dofile("expansions/script/c20000450.lua")
local cm, m = fu_GD.RM_initial()
--e1
cm.e1 = fuef.FTO("DR"):PRO("DE+TG"):RAN("M"):CTL(1):Func("sd_con,tg1,op1")
function cm.tg1f(g)
	return function(e,ep,tp)
		return not g:IsContains(e:GetHandler())
	end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) end
	if chk==0 then return fugf.GetFilter(tp,"+MS","TgChk",e,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g = fugf.SelectTg(tp,"+MS","TgChk",e,1,ev)
	Duel.SetChainLimit(cm.tg1f(g))
end
function cm.op1con1(e)
	local tp = e:GetOwnerPlayer()
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) and fugf.GetFilter(tp,"M","IsTyp+IsRac+IsPos","RI+M,DR,FU",1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	fuef.S(e,EFFECT_CANNOT_TRIGGER,g):DES(1):PRO("HINT"):CON("op1con1"):RES("STD")(EFFECT_DISABLE)
end