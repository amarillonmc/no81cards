--救援ACE队 消防栓战士
function c98920568.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920568)
	e1:SetCondition(c98920568.condition)
	e1:SetTarget(c98920568.thtg)
	e1:SetCost(c98920568.cost)
	e1:SetOperation(c98920568.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920568,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98920568)
	e2:SetCondition(c98920568.setcon)
	e2:SetTarget(c98920568.settg)
	e2:SetOperation(c98920568.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c98920568.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c98920568.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98920568.thfilter(c)
	return c:IsSetCard(0x18b) and not c:IsCode(98920568) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920568.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	if chk==0 then return Duel.IsExistingMatchingCard(c98920568.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920568.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920568.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920568.setfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x18b) and not c:IsCode(98920568) and c:IsControler(tp)
end
function c98920568.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920568.setfilter,1,nil,tp)
end
function c98920568.setfilter1(c)
	return c:IsSetCard(0x18b) and c:IsType(TYPE_QUICKPLAY+TYPE_TRAP) and not c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end
function c98920568.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920568.setfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c98920568.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c98920568.setfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
		if c:IsLocation(LOCATION_GRAVE) then
		   Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end