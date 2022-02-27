local m=53799215
local cm=_G["c"..m]
cm.name="怪物YUH"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cm.rtg)
	e1:SetValue(function(e,c)return false end)
	c:RegisterEffect(e1,true)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local res=c:GetOwner()==tp and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and Duel.IsExistingMatchingCard(SNNM.SetDirectlyf,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return res end
	if res then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,SNNM.SetDirectlyf,tp,0,LOCATION_ONFIELD,1,1,nil)
		SNNM.SetDirectly(g,e,tp)
		return true
	else return false end
end
