-- 报仇的占卜师·艾塞克莱因
local s,id=GetID()
function s.initial_effect(c)
  aux.AddCodeList(c,60012048)
	c:EnableCounterPermit(0x624)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1b)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(s.atkcon2)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2b)
end
function s.thfilter1(c)
	return c:IsCode(60012048) and c:IsAbleToHand()
end
function s.thfilter2(c)
	return aux.IsCodeListed(c,60012048) and c:IsAbleToHand() and not c:IsCode(m)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end
function s.atkcon2(e)
	return e:GetHandler():GetCounter(0x624)>0
end