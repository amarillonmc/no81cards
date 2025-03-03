--创导龙裔·研究者
dofile("expansions/script/c20000450.lua")
local cm, m = fuef.initial(fu_GD, _glo)
cm.e1 = fuef.STO("DR"):RAN("H"):PRO("DAM"):CTL(m):Func("con1,N_cos1,tg1,op1")
cm.e2 = fuef.QO():RAN("H"):PRO("TG"):CTL(m):Func("con2,tg2,op2")
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return (r & REASON_EFFECT == REASON_EFFECT) and fucf.Filter(re:GetHandler(), "IsSet+IsTyp", "bfd4,M")
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local te = re:GetHandler().public_effect
	if not te then return false end
	te = te.e
	local tg = te:GetTarget()
	if chk==0 then return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) end
	e:SetLabelObject(te)
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local op = e:GetLabelObject():GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPublic() and Duel.GetTurnPlayer() ~= tp
end
function cm.tg2tg1(e,c)
	return not fusf.Creat_CF("IsSet+IsTyp","3fd4,RI+M")(c)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local e1 = fuef.F(e,EFFECT_CANNOT_SPECIAL_SUMMON,tp):PRO("PTG"):TRAN(1,0):TG("tg2tg1")
	local g = fugf.GetFilter(tp,"G","IsTyp+CheckActivateEffect+TgChk",{"RI+S",{true,true,false},e})
	e1.e:Reset()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and g:IsContains(chkc) end
	if chk==0 then return #g > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	g = fugf.SelectTg(tp, g)
	local te, ceg, cep, cev, cre, cr, crp = g:GetFirst():CheckActivateEffect(true,true,true)
	e:SetProperty(te:GetProperty())
	local tg = te:GetTarget()
	if tg then tg(e, tp, ceg, cep, cev, cre, cr, crp, 1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local e1 = fuef.F(e,EFFECT_CANNOT_SPECIAL_SUMMON,tp):PRO("PTG"):TRAN(1,0):TG("tg2tg1")
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	e1.e:Reset()
end