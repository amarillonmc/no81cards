--狱火机·萨麦尔
function c98920316.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c98920316.lcheck)
	c:EnableReviveLimit()
	--discard self deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetDescription(aux.Stringid(98920316,1))
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98920316)
	e2:SetCondition(c98920316.thcon)
	e2:SetTarget(c98920316.distg2)
	e2:SetOperation(c98920316.disop2)
	c:RegisterEffect(e2)
	--release replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_RELEASE_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c98920316.reptg)
	e3:SetValue(c98920316.repval)
	c:RegisterEffect(e3)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920316,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930316)
	e3:SetCost(c98920316.thcost)
	e3:SetTarget(c98920316.thtg)
	e3:SetOperation(c98920316.thop)
	c:RegisterEffect(e3)
end
function c98920316.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xbb)
end
function c98920316.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98920316.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c98920316.disop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if ct>0 then
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	end
end
function c98920316.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER)
		and (c:GetDestination()==LOCATION_GRAVE or c:GetDestination()==LOCATION_EXTRA)
end
function c98920316.tgfilter(c)
	return c:IsSetCard(0xbb) and c:IsAbleToGraveAsCost()
end
function c98920316.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return bit.band(r,REASON_COST)~=0 and re and re:IsActiveType(TYPE_MONSTER)
		and (re:GetHandler():IsSetCard(0xbb) and lg:IsContains(re:GetHandler()) ) and Duel.IsExistingMatchingCard(c98920316.tgfilter,tp,LOCATION_DECK,0,1,nil) and eg:IsExists(c98920316.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(98920316,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(24094258,3))
		local g=Duel.SelectMatchingCard(tp,c98920316.tgfilter,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SendtoGrave(g,REASON_COST)
		return true
	else return false end
end
function c98920316.repval(e,c)
	return c98920316.repfilter(c,e:GetHandlerPlayer())
end
function c98920316.thcfilter(c,tp)
	return (c:IsFaceup() or c:IsControler(tp))
end
function c98920316.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98920316.thcfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c98920316.thcfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c98920316.thfilter(c)
	return c:IsSetCard(0xc5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98920316.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920316.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920316.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920316.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
