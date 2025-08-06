--银 河 眼 亚 光 子 龙
local m=22348307
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,22348307+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22348307.spcon)
	e1:SetOperation(c22348307.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCost(c22348307.thcost)
	e2:SetTarget(c22348307.thtarget)
	e2:SetOperation(c22348307.thoperation)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c22348307.spcost2)
	e3:SetTarget(c22348307.sptg2)
	e3:SetOperation(c22348307.spop2)
	c:RegisterEffect(e3)
	
end

function c22348307.sprfilter(c,tp)
	return c:IsCode(93717133) and c:IsType(TYPE_MONSTER) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function c22348307.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c22348307.sprfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)
end
function c22348307.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c22348307.sprfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22348307.thcfilter(c)
	return c:IsCode(93717133) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c22348307.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348307.thcfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22348307.thcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22348307.thfilter(c)
	return c:IsSetCard(0x7b) and c:IsAbleToHand()
end
function c22348307.thtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348307.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348307.thoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348307.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22348307.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c22348307.sp2filter(c,e,tp)
	return c:IsSetCard(0x107b) and c:IsFaceup()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348307.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c:IsControler(tp) and c22348307.sp2filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22348307.sp2filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22348307.sp2filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22348307.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end



