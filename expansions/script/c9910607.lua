--赛博空间侵袭
function c9910607.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9910607+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910607.target)
	e1:SetOperation(c9910607.activate)
	c:RegisterEffect(e1)
end
function c9910607.rmfilter(c,e)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function c9910607.cfilter(c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x6950)
end
function c9910607.fselect(g,tp)
	return g:IsExists(c9910607.cfilter,1,nil) and Duel.GetMZoneCount(tp,g)>0
end
function c9910607.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c9910607.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
	if chk==0 then return g:CheckSubGroup(c9910607.fselect,1,3,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9910606,0,0x4011,1000,1000,12,RACE_MACHINE,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c9910607.fselect,false,1,3,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c9910607.ogfilter(c)
	return c:IsType(TYPE_TOKEN) or (c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT))
end
function c9910607.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetsRelateToChain()
	if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==0 then return end
	local ct=Duel.GetOperatedGroup():FilterCount(c9910607.ogfilter,nil)
	Duel.AdjustAll()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9910606,0,0x4011,1000,1000,12,RACE_MACHINE,ATTRIBUTE_DARK) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,9910606)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetValue(c9910607.atlimit)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
function c9910607.atlimit(e,c)
	return c~=e:GetHandler()
end
