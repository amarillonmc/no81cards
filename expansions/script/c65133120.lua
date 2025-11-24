--幻叙救济 弥勒
local s,id,o=GetID()
function s.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e0:SetValue(s.matlimit)
	c:RegisterEffect(e0)
	local e01=e0:Clone()
	e01:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e01)
	local e02=e0:Clone()
	e02:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e02)
	local e03=e0:Clone()
	e03:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e03)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(aux.bfgcost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.matlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x838)
end
function s.filter_non_talespace(c)
	return c:IsType(TYPE_MONSTER) and not c:IsSetCard(0x838)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.filter_non_talespace,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(c)
	e1:SetOperation(s.endop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.endop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local g_count=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	if not c:IsLocation(LOCATION_REMOVED) then return end
	if g_count>5 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(s.val)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTargetRange(1,0)
			e2:SetTarget(function(e,tc) return tc:IsLocation(LOCATION_EXTRA) end)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			c:RegisterEffect(e2)			
			Duel.SpecialSummonComplete()		
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local tc=Duel.SelectMatchingCard(tp,Card.IsSummonType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,SUMMON_TYPE_SPECIAL):GetFirst()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetValue(RESET_TURN_SET)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
		end
	elseif g_count<5 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(s.val2)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			c:RegisterEffect(e2)
			
			Duel.SpecialSummonComplete()
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				local pg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
				if #pg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=pg:Select(tp,1,1,nil)
					local tc=sg:GetFirst()
					if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetCode(EFFECT_DISABLE)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e3)
						local e4=Effect.CreateEffect(c)
						e4:SetType(EFFECT_TYPE_SINGLE)
						e4:SetCode(EFFECT_DISABLE_EFFECT)
						e4:SetValue(RESET_TURN_SET)
						e4:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e4)
						Duel.SpecialSummonComplete()
					end
				end
			end
		end
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x838) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil,TYPE_MONSTER)*500
end
function s.val2(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE)*1000
end