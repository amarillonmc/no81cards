--狂风精灵聚集
function c51928010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,51928010+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c51928010.cost)
	e1:SetTarget(c51928010.target)
	e1:SetOperation(c51928010.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(51928010,ACTIVITY_SPSUMMON,c51928010.counterfilter)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c51928010.thcon)
	e2:SetCost(c51928010.thcost)
	e2:SetTarget(c51928010.thtg)
	e2:SetOperation(c51928010.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CUSTOM+51928010)
	e3:SetCondition(c51928010.thcon2)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(51928010,ACTIVITY_SPSUMMON,c51928010.counterfilter)
end
function c51928010.counterfilter(c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER)) and c:IsLocation(LOCATION_EXTRA)
end
-------------
function c51928010.counterfilter(c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER)) and c:IsLocation(LOCATION_EXTRA)
end
function c51928010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c51928010.filter(c,e,tp)
	return c:IsSetCard(0x9256) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c51928010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(51928010,tp,ACTIVITY_SPSUMMON)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c51928010.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c51928010.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c51928010.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--------------
function c51928010.thcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return rp==tp and de and dp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function c51928010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c51928010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c51928010.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c51928010.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and c:GetReasonEffect()==nil
end





