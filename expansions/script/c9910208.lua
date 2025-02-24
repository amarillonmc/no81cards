--天空漫步者 市之濑莉佳
function c9910208.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c9910208.mfilter,1,1)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9910208)
	e1:SetCondition(c9910208.tgcon)
	e1:SetTarget(c9910208.tgtg)
	e1:SetOperation(c9910208.tgop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910208)
	e2:SetCondition(c9910208.spcon)
	e2:SetCost(c9910208.spcost)
	e2:SetTarget(c9910208.sptg)
	e2:SetOperation(c9910208.spop)
	c:RegisterEffect(e2)
end
function c9910208.mfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkSetCard(0x6956)
end
function c9910208.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9910208)<=0
end
function c9910208.tgfilter(c)
	return c:IsSetCard(0x6956) and c:IsAbleToGrave()
end
function c9910208.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910208.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(9910208,RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9910208.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910208.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c9910208.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetFlagEffect(9910208)<=0
end
function c9910208.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	c:RegisterFlagEffect(9910208,RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9910208.spfilter(c,e,tp,ec)
	return c:IsLinkBelow(1) and c:IsLinkAbove(1) and c:IsSetCard(0x6956)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,ec,c)>0
end
function c9910208.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910208.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910208.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910208.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
