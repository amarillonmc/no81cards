--Hollow Knight-小骑士 挑战格林
function c79034028.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLevel,1),1)
	c:EnableReviveLimit() 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCost(c79034028.lzcost)
	e1:SetCondition(c79034028.lzcon)
	e1:SetTarget(c79034028.lztg)
	e1:SetOperation(c79034028.lzop)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetCountLimit(1,79034028)
	e2:SetCost(c79034028.spcost)
	e2:SetTarget(c79034028.sptg)
	e2:SetOperation(c79034028.op)
	c:RegisterEffect(e2)	  
end
function c79034028.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79034028.lzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c79034028.thfilter2(c,e,tp)
	return c:IsSetCard(0xa009) and c:IsAbleToHand()
end
function c79034028.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79034028.thfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c79034028.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function c79034028.lzop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function c79034028.thfilter(c,e,tp)
	return c:IsSetCard(0xa009) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLink(1) and (c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c79034028.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_EFFECT)
end
function c79034028.cfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_HAND) and c:IsSetCard(0xa009)
end
function c79034028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c79034028.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) and eg:IsExists(c79034028.cfil,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79034028.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0)
end
function c79034028.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end















