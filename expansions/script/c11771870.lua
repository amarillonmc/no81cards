--森树长老 萨若米亚
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id,11771865)
	c:SetUniqueOnField(1,0,id)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFacedown() or not c:IsAttribute(ATTRIBUTE_WIND)
end
function s.ffilter(c)
	return c:IsFaceup() and c:IsCode(11771865)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_FZONE,0,1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return s.spfilter(chkc,e,tp) and chkc:IsControler(tp) and chkc:IsLocation(0x30) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(s.spfilter,tp,0x30,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectTarget(tp,s.spfilter,tp,0x30,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc+Group.FromCards(c),2,tp,LOCATION_HAND|0x30)
end
function s.lvfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevelAbove(1)
		and not c:IsLevel(4)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
		and Duel.SpecialSummon(Group.FromCards(c,tc),0,tp,tp,false,false,POS_FACEUP)==2 and Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local lc=Duel.SelectMatchingCard(tp,s.lvfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		if lc then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(4)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			lc:RegisterEffect(e1)
		end
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk) 
   if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end 
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetFlagEffect(tp,id)==0 then return end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND))
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--
	local turn_ct=Duel.GetTurnCount()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(function() return Duel.GetTurnCount()~=turn_ct end)
	e2:SetOperation(s.desop)
	e2:SetReset(RESET_PHASE|PHASE_STANDBY,Duel.GetCurrentPhase()<=PHASE_STANDBY and 2 or 1)
	Duel.RegisterEffect(e2,tp)
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() 
end
function s.desfilter(c)
	return (c:IsFacedown() or c:GetAttribute()~=ATTRIBUTE_WIND)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #sg==0 then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Destroy(sg,REASON_EFFECT)
end