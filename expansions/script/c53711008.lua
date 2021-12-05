local m=53711008
local cm=_G["c"..m]
cm.name="魔理沙役 UDK"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,5,2,cm.ovfilter,aux.Stringid(m,0))
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsRank(4) and c:GetOverlayCount()==0
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.spfilter(c,e,tp)
	local cd=c:GetOriginalCode()-53711000
	return c:IsLevel(4) and c:IsSetCard(0x3538) and c:IsAbleToHand() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,cd,nil,e,tp,cd)
end
function cm.timefilter(c,tp)
	return c:IsHasEffect(53711065,tp) and c:GetFlagEffect(53711015)<2
end
function cm.filter(c,e,tp,cd)
	local timeg=Duel.GetMatchingGroup(cm.timefilter,tp,LOCATION_MZONE,0,c,tp)
	if c:IsLocation(LOCATION_HAND) then
		if cd<3 then return c:IsType(TYPE_SPELL) and c:IsDiscardable()
		elseif cd==3 then return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
		else return c:IsDiscardable() end
	elseif c:IsLocation(LOCATION_GRAVE) then
		return c:IsAbleToRemove() and c:IsHasEffect(53711009,tp)
	else
		return c:IsSetCard(0x3538) and c:IsType(TYPE_SPELL) and #timeg>0
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local cd=g:GetFirst():GetOriginalCode()-53711000
	if #g>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,cd,nil,e,tp,cd) and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then Duel.RaiseSingleEvent(g:GetFirst(),EVENT_CUSTOM+53711005,e,0,0,0,0) end
end
