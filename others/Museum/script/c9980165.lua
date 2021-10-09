--魔法纪录·深月菲莉希亚
function c9980165.initial_effect(c)
	c:EnableCounterPermit(0x1,LOCATION_MZONE+LOCATION_PZONE)
	c:SetCounterLimit(0x1,2)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_PZONE+LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_PZONE+LOCATION_MZONE)
	e3:SetOperation(c9980165.acop)
	c:RegisterEffect(e3)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_PZONE+LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c9980165.ctop)
	c:RegisterEffect(e2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980165,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,99801650)
	e1:SetCost(c9980165.cost)
	e1:SetTarget(c9980165.thtg)
	e1:SetOperation(c9980165.thop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980165,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9980165)
	e1:SetCost(c9980165.cost)
	e1:SetTarget(c9980165.sptg)
	e1:SetOperation(c9980165.spop)
	c:RegisterEffect(e1)
end
c9980165.counter_add_list={0x1}
function c9980165.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c9980165.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbc4)
end
function c9980165.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c9980165.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c9980165.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,2,REASON_COST)
end
function c9980165.thfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c9980165.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980165.thfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_REMOVED)
end
function c9980165.thop(e,tp,eg,ep,ev,re,r,rp)
   if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980165.thfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9980165.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980165.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA+LOCATION_REMOVED) and chkc:IsControler(tp) and c9980165.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9980165.spfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9980165.spfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9980165.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end