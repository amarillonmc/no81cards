--鱼越龙镜
local m=14000458
local cm=_G["c"..m]
cm.named_with_Goverfish=1
function cm.initial_effect(c)
	aux.AddRitualProcGreater2(c,cm.filter,LOCATION_HAND+LOCATION_GRAVE,cm.mfilter)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.setfilter(c)
	return c:IsCode(14000452) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end