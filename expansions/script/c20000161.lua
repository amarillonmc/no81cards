--概念虚械 美德
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e = {fu_cim.XyzUnite(c)}
end
function cm.Add(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_CODE,tp,m)
	local e1=fuef.F(e,nil,EFFECT_CANNOT_INACTIVATE,nil,nil,nil,cm.val1,nil,nil,nil,nil,tp,RESET_PHASE+PHASE_END)
	local e2=fuef.Clone(e1,tp,{"COD",EFFECT_CANNOT_DISEFFECT})
end
function cm.val1(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0xcfd1) and bit.band(loc,LOCATION_ONFIELD)~=0
end