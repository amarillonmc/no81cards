local m=31407005
local cm=_G["c"..m]
cm.name="白音齿真理龙"
if not pcall(function() require("expansions/script/c31407000") end) then require("expansions/script/c31407000") end
function cm.initial_effect(c)
	Seine_Metafor.Syn_Big_Proc(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.tohtg)
	e1:SetOperation(cm.tohop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
end
function cm.efilter(e,te)
	return (te:IsActiveType(TYPE_MONSTER) or te:IsActiveType(TYPE_SPELL)) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.tohtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
end
function cm.tohop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
end