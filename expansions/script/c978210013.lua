--多元闪刀姬-零衣∞
function c978210013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(978210013,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c978210013.spcost1)
	e1:SetTarget(c978210013.sptg1)
	e1:SetOperation(c978210013.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(978210013,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c978210013.spcon2)
	e2:SetTarget(c978210013.sptg2)
	e2:SetOperation(c978210013.spop2)
	c:RegisterEffect(e2)
------
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_CHAIN_END+TIMING_END_PHASE)
	e3:SetCost(c978210013.sumcost)
	e3:SetTarget(c978210013.sumtg)
	e3:SetOperation(c978210013.sumop)
	c:RegisterEffect(e3)
------
	 local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(978210013,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c978210013.tgtg)
	e4:SetOperation(c978210013.tgop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c978210013.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c978210013.spfilter1(c,e,tp,ec)
	return c:IsSetCard(0x2115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c978210013.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c978210013.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c978210013.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c978210013.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
	end
end
function c978210013.cfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and bit.band(c:GetPreviousTypeOnField(),TYPE_LINK)~=0
		and c:IsPreviousSetCard(0x2115) and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function c978210013.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c978210013.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function c978210013.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c978210013.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
------
function c978210013.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,114824019)==0 end
	Duel.RegisterFlagEffect(tp,114824019,RESET_CHAIN,0,1)
end
function c978210013.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(true,nil) or e:GetHandler():IsMSetable(true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c978210013.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Summon(tp,c,true,nil)
end
-----
function c978210013.tgfilter(c)
	return c:IsSetCard(0x2115) and not c:IsCode(978210013) and c:IsAbleToHand()
end
function c978210013.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c978210013.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c978210013.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c978210013.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end