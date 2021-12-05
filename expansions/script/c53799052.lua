local m=53799052
local cm=_G["c"..m]
cm.name="苦涩的杀灭"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.tgcost)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
function cm.tgcfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,c:GetCode())
end
function cm.tgfilter(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsCode(code) and c:IsAbleToGrave()
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgcfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgcfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
