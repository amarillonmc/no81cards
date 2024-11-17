--炼金领域
function c51926002.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,51926002+EFFECT_COUNT_CODE_OATH)
	e0:SetOperation(c51926002.activate)
	c:RegisterEffect(e0)
	--inactivatable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(c51926002.effectfilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(c51926002.effectfilter)
	c:RegisterEffect(e2)
	--act qp in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5257))
	e3:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(3,51926002+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(c51926002.thcon)
	e4:SetCost(c51926002.thcost)
	e4:SetTarget(c51926002.thtg)
	e4:SetOperation(c51926002.thop)
	c:RegisterEffect(e4)
end
function c51926002.tffilter(c,tp)
	return c:IsCode(51926001) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c51926002.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c51926002.tffilter,tp,LOCATION_DECK,0,nil,tp)
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(51926002,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,1,nil)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c51926002.effectfilter(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return tp==e:GetHandlerPlayer() and tc:IsType(TYPE_QUICKPLAY) and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c51926002.cfilter(c)
	local g=c:GetMaterial()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsFaceup()
		and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
		and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
		and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
		and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
end
function c51926002.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c51926002.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c51926002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
	if chk==0 then return g:GetCount()>1 and g:GetCount()==g:FilterCount(Card.IsAbleToDeckAsCost,nil) end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c51926002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51926002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
