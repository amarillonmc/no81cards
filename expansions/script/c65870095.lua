--Protoss·折跃棱镜
function c65870095.initial_effect(c)
	aux.AddCodeList(c,65870015)
	aux.EnableChangeCode(c,65870015,LOCATION_ONFIELD)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65870095,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65870095)
	e1:SetCost(c65870095.discost)
	e1:SetTarget(c65870095.destg)
	e1:SetOperation(c65870095.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65870095,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65870095+1)
	e2:SetCondition(c65870095.chcon)
	e2:SetCost(c65870095.discost)
	e2:SetTarget(c65870095.target1)
	e2:SetOperation(c65870095.activate1)
	c:RegisterEffect(e2)
end

function c65870095.chcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c65870095.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and (c:IsAbleToHandAsCost() or c:IsAbleToExtraAsCost()) and aux.NecroValleyFilter() and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x3a37))
end
function c65870095.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65870095.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c65870095.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c65870095.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65870095.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c65870095.spfilter(c,e,tp)
	return c:IsSetCard(0x3a37) and c:IsType(TYPE_MONSTER) and aux.NecroValleyFilter() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65870095.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65870095.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c65870095.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65870095.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end