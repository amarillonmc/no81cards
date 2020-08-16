--多元闪刀姬-雫空∞
function c978210015.initial_effect(c)
	c:SetSPSummonOnce(978210015)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c978210015.matfilter,1,1)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c978210015.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c978210015.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(978210015,0))
	e4:SetCategory(CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c978210015.thcon)
	e4:SetTarget(c978210015.thtg)
	e4:SetOperation(c978210015.thop)
	c:RegisterEffect(e4)
	--
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(978210015,1))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetHintTiming(0,TIMING_END_PHASE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCost(c978210015.spcost1)
	e8:SetTarget(c978210015.sptg1)
	e8:SetOperation(c978210015.spop1)
	c:RegisterEffect(e8)
end
function c978210015.matfilter(c)
	return c:IsLinkSetCard(0x2115) and not c:IsLinkAttribute(ATTRIBUTE_WATER)
end
function c978210015.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_SPELL)*-100
end
function c978210015.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(978210015,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c978210015.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(978210015)~=0
end
function c978210015.thfilter(c,tp)
	return c:IsSetCard(0x2115) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c978210015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c978210015.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c978210015.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c978210015.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
----
function c978210015.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c978210015.spfilter1(c,e,tp,ec)
	return c:IsSetCard(0x2115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c978210015.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c978210015.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c978210015.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c978210015.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
	end
end