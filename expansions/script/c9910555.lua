--甜心机仆的欢笑
require("expansions/script/c9910550")
function c9910555.initial_effect(c)
	--flag
	Txjp.AddTgFlag(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910555)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910555.target)
	e1:SetOperation(c9910555.activate)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetCondition(c9910555.actcon)
	e2:SetOperation(c9910555.actop)
	c:RegisterEffect(e2)
end
function c9910555.spfilter(c,e,tp)
	return c:IsSetCard(0x3951) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910555.filter1(c,id)
	return c:GetTurnID()==id and not c:IsReason(REASON_RETURN)
end
function c9910555.filter2(c,id)
	return c:GetTurnID()<id and not c:IsReason(REASON_RETURN)
end
function c9910555.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910555.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9910555.fselect(g,id)
	return g:FilterCount(c9910555.filter1,nil,id)<2 and g:FilterCount(c9910555.filter2,nil,id)<2
		and g:FilterCount(Card.IsReason,nil,REASON_RETURN)<2
end
function c9910555.activate(e,tp,eg,ep,ev,re,r,rp)
	local id=Duel.GetTurnCount()
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),3)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910555.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c9910555.fselect,false,1,ft,id)
	for tc in aux.Next(sg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(c9910555.splimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c9910555.splimit(e,c)
	return not c:IsRace(RACE_CYBERSE)
end
function c9910555.actcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_REMOVED) and c:IsReason(REASON_RETURN)
end
function c9910555.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c9910555.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910555.actlimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_HAND) and re:IsActiveType(TYPE_MONSTER)
end
