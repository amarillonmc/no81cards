--閃刀姫－カガリ
function c978210014.initial_effect(c)
	c:SetSPSummonOnce(978210014)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c978210014.matfilter,1,1)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c978210014.atkval)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(978210014,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c978210014.thtg)
	e3:SetOperation(c978210014.thop)
	c:RegisterEffect(e3)
------
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(978210014,1))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetHintTiming(0,TIMING_END_PHASE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCost(c978210014.spcost1)
	e8:SetTarget(c978210014.sptg1)
	e8:SetOperation(c978210014.spop1)
	c:RegisterEffect(e8)
end
function c978210014.matfilter(c)
	return c:IsLinkSetCard(0x2115) and not c:IsLinkAttribute(ATTRIBUTE_FIRE)
end
function c978210014.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_SPELL)*100
end
function c978210014.thfilter(c,tp)
	return c:IsSetCard(0x2115) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c978210014.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c978210014.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c978210014.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c978210014.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c978210014.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
-----
function c978210014.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c978210014.spfilter1(c,e,tp,ec)
	return c:IsSetCard(0x2115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c978210014.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c978210014.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c978210014.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c978210014.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
	end
end