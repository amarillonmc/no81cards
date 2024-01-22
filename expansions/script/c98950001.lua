--于贝尔-罪恶的愉悦
function c98950001.initial_effect(c)
	aux.AddCodeList(c,78371393)
	 --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98950001,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c98950001.spcon)
	e3:SetTarget(c98950001.sptg)
	e3:SetOperation(c98950001.spop)
	c:RegisterEffect(e3)
--search
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(98950001,0))
	e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e10:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetCode(EVENT_SUMMON_SUCCESS)
	e10:SetCountLimit(1,98950001)
	e10:SetTarget(c98950001.tg)
	e10:SetOperation(c98950001.op)
	c:RegisterEffect(e10)
	local e2=e10:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(c98950001.cond)
	e1:SetOperation(c98950001.activate)
	c:RegisterEffect(e1)
end
function c98950001.cfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(1)
end
function c98950001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c98950001.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98950001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98950001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c98950001.filter(c)
	return aux.IsCodeListed(c,78371393) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98950001.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98950001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98950001.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98950001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98950001.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(c98950001.disop)
	e1:SetCondition(c98950001.discon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98950001.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp and Duel.IsExistingMatchingCard(Card.IsCode,tp,0,LOCATION_GRAVE,1,nil,re:GetHandler():GetCode())
end
function c98950001.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c98950001.disfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(10) and c:IsAttack(0) and c:IsDefense(0)
end
function c98950001.cond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98950001.disfilter,tp,LOCATION_MZONE,0,1,nil)
end