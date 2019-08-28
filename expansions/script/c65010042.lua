--幻梦迷境 小玉
function c65010042.initial_effect(c)
	aux.AddLinkProcedure(c,c65010042.linkfil,1,1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,65010042)
	e1:SetCondition(c65010042.thcon)
	e1:SetTarget(c65010042.thtg)
	e1:SetOperation(c65010042.thop)
	c:RegisterEffect(e1)
	--sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65010043)
	e2:SetCost(c65010042.spcost)
	e2:SetTarget(c65010042.sptg)
	e2:SetOperation(c65010042.spop)
	c:RegisterEffect(e2)
end
function c65010042.linkfil(c)
	return c:IsRace(RACE_CYBERSE) and not c:IsCode(65010042)
end
function c65010042.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) 
end
function c65010042.thfil(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToHand()
end
function c65010042.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and chkc:IsSetCard(0x3da0) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c65010042.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65010042.thfil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_REMOVED)
end
function c65010042.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end
function c65010042.cfilter(c,tp)
	return c:IsRace(RACE_CYBERSE) and Duel.GetMZoneCount(tp,c)>0
end
function c65010042.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c65010042.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c65010042.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c65010042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65010042.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
