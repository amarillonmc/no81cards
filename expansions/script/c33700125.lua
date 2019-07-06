--霓火眠醒
function c33700125.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33700125.condition)
	e1:SetTarget(c33700125.target)
	e1:SetOperation(c33700125.activate)
	c:RegisterEffect(e1)
   --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCost(c33700125.cost)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c33700125.con)
	e2:SetTarget(c33700125.tg)
	e2:SetOperation(c33700125.op)
	c:RegisterEffect(e2)
end
function c33700125.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)
end
function c33700125.filter(c,e,tp)
	return c:IsSetCard(0x443)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700125.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c33700125.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function c33700125.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) 
	and Duel.CheckLPCost(1-tp,800) and Duel.SelectYesNo(1-tp,aux.Stringid(33700125,0)) then
	Duel.PayLPCost(1-tp,800)
	Duel.NegateEffect(0)
   else 
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33700125.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
	Duel.BreakEffect()
	local tg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,tp,0,LOCATION_DECK,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,tg)
	end
end
end
function c33700125.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c33700125.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700125.cfilter,1,nil,1-tp) and aux.exccon(e,tp,eg,ep,ev,re,r,rp)
end
function c33700125.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c33700125.spfilter(c,e,sp)
	return c:IsSetCard(0x443) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c33700125.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700125.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33700125.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33700125.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
end