--幼发拉底的傍晚
function c9950130.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9950130.activate)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950130,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTarget(c9950130.ottg)
	e1:SetOperation(c9950130.otop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9950130,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,9950130)
	e5:SetTarget(c9950130.target)
	e5:SetOperation(c9950130.operation)
	c:RegisterEffect(e5)
end
function c9950130.thfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9ba5) and c:IsAbleToHand()
end
function c9950130.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9950130.thfilter2,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9950130,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9950130.ottg(e,c)
	return c:IsSetCard(0x9ba5)
end
function c9950130.otop(e,tp,eg,ep,ev,re,r,rp)
	  local e1=Effect.CreateEffect(e:GetHandler())
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_EXTRA_RELEASE)
	  e1:SetTargetRange(0,LOCATION_MZONE)
	  e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	  e1:SetCountLimit(1)
	  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	  Duel.RegisterEffect(e1,tp)
end
function c9950130.thfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c9950130.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950130.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950130.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950130.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end