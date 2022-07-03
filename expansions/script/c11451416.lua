--waking of dragon palace
local m=11451416
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,nil,LOCATION_HAND+LOCATION_GRAVE,nil,cm.matfilter)
	e1:SetDescription(aux.Stringid(m,0))
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.filter(c,tp)
	return c:IsPreviousSetCard(0x6978) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:GetReasonPlayer()==tp
end
function cm.filter1(c)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function cm.filter2(c)
	return c:IsSetCard(0x6978) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g3=g2:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g4=g1:Select(tp,1,1,nil)
		g3:Merge(g4)
		Duel.SendtoHand(g3,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g3)
	end
end