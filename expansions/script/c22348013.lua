--金 属 化 盆 栽
local m=22348013
local cm=_G["c"..m]
function cm.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348013,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348013.thcon)
	e1:SetTarget(c22348013.thtg)
	e1:SetOperation(c22348013.thop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348013,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22348013)
	e2:SetCondition(c22348013.spcon)
	e2:SetCost(c22348013.spcost)
	e2:SetTarget(c22348013.sptg)
	e2:SetOperation(c22348013.spop)
	c:RegisterEffect(e2)
end

function c22348013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c22348013.costfilter(c)
	if c:IsLocation(LOCATION_HAND) then return c:IsCode(22348012) and c:IsDiscardable() end
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c22348013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable()
		and Duel.IsExistingMatchingCard(c22348013.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c22348013.costfilter,tp,LOCATION_HAND,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if te then
		te:UseCountLimit(tp)
		Duel.Release(e:GetHandler(),REASON_COST)
		Duel.SendtoGrave(tc,REASON_COST)
	else
		Duel.Release(e:GetHandler(),REASON_COST)
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function c22348013.spfilter(c,e,tp)
	return c:IsSetCard(0x613) and not c:IsCode(22348013) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c22348013.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22348013.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348013.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348013.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

function c22348013.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end

function c22348013.thfilter(c)
	return c:IsCode(22348012) and c:IsAbleToHand()
end
function c22348013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348013.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348013.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348013.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
