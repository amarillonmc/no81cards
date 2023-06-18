--天威之圣仙女
function c98920098.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
--negate activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920098,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920098)
	e1:SetCost(c98920098.cost)
	e1:SetTarget(c98920098.target)
	e1:SetOperation(c98920098.operation)
	c:RegisterEffect(e1) 
	 --Revive
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920098,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98930098)
	e2:SetTarget(c98920098.sumtg)
	e2:SetOperation(c98920098.sumop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(98920098,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetTarget(c98920098.sptg)
	e3:SetOperation(c98920098.spop)
	c:RegisterEffect(e3)
end
function c98920098.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920098.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),TYPE_EFFECT) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),TYPE_EFFECT)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98920098.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_EFFECT)
	Duel.Destroy(g,REASON_EFFECT)
	e:GetHandler():RegisterFlagEffect(98920098,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c98920098.thfilter(c)
	return c:IsSetCard(0x12c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920098.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920098.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) and e:GetHandler():GetFlagEffect(98920098)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98920098.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920098.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920098.filter(c,e,tp)
	return c:IsType(TYPE_LINK) and not c:IsType(TYPE_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98920098.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920098.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and e:GetHandler():GetFlagEffect(98920098)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920098.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920098.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end