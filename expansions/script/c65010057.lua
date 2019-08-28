--幻梦迷境船长 格蕾丝
function c65010057.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c65010057.fumfil,2,false)
	 --sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65010057)
	e1:SetCondition(c65010057.spcon)
	e1:SetTarget(c65010057.sptg)
	e1:SetOperation(c65010057.spop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,65010058)
	e2:SetCondition(c65010057.condition)
	e2:SetCost(c65010057.cost)
	e2:SetTarget(c65010057.target)
	e2:SetOperation(c65010057.operation)
	c:RegisterEffect(e2)
end
function c65010057.fumfil(c)
	return c:IsSetCard(0x6da0) and c:IsType(TYPE_LINK)
end
function c65010057.spconfil(c)
	return c:IsRace(RACE_CYBERSE)
end

function c65010057.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65010057.spconfil,1,e:GetHandler()) 
end

function c65010057.spfil(c,e,tp)
	return c:IsSetCard(0x6da0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsType(TYPE_LINK)
end

function c65010057.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65010057.spfil(chkc,e,tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65010057.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectTarget(tp,c65010057.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function c65010057.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function c65010057.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and ep~=tp 
end

function c65010057.costfil(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToDeckAsCost()
end

function c65010057.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010057.costfil,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65010057.costfil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c65010057.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c65010057.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end