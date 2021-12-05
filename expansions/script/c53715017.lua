local m=53715017
local cm=_G["c"..m]
cm.name="欢乐树友？ 小羊"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tetg)
	e1:SetOperation(cm.teop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.lfilter(c)
	return not c:IsType(TYPE_EFFECT)
end
function cm.lcheck(g)
	return g:IsExists(cm.lfilter,1,nil)
end
function cm.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x353a)
end
function cm.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and #g>1 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,0,tp,LOCATION_DECK)
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if Duel.GetFieldGroup(tp,LOCATION_HAND,0)==0 or #g<2 then return end
	local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,#g-1,REASON_EFFECT+REASON_DISCARD)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local sg=g:Select(tp,ct+1,ct+1,nil)
		if sg:GetCount()>0 then Duel.SendtoExtraP(sg,tp,REASON_EFFECT) end
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_EXTRA,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
