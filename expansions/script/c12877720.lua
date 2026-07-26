-- 极彩色的绯红骑士
local s,id,o=GetID()
function s.initial_effect(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit0)
	c:RegisterEffect(e0)
	--specialsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DRAW_PHASE)
	e1:SetCost(s.e1cost)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	--change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.e2con)
	e2:SetCost(s.e2cost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	s.self_hand_effect=e1
end
function s.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function s.splimit0(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function s.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	Duel.RegisterEffect(e2,tp)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function s.rmfilter(c)
	return c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT)
end
function s.rlfilter(c,tp,code)
	if Duel.GetMatchingGroupCount(s.rmfilter,tp,0,LOCATION_HAND,nil)==0 and c:IsLocation(LOCATION_HAND) then return false end
	if Duel.GetMatchingGroupCount(s.rmfilter,tp,0,LOCATION_ONFIELD,nil)==0 and c:IsLocation(LOCATION_MZONE) then return false end
	return not c:IsCode(code) and c:IsReleasableByEffect() and c:IsSetCard(0x5a73) and c:IsType(TYPE_MONSTER)
end
function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.rlfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp,c:GetCode()) and c:GetFlagEffect(id)==0 end
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
		local g=Duel.GetMatchingGroupCount(s.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,s.rlfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp,c:GetCode())
	if #sg>0 and Duel.Release(sg,REASON_EFFECT)>0 then
		local tc=sg:GetFirst()
		local loc=0
		local rg
		if tc:IsPreviousLocation(LOCATION_HAND) then loc=LOCATION_HAND end
		if tc:IsPreviousLocation(LOCATION_MZONE) then loc=LOCATION_ONFIELD end
		local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,loc,nil)
		if #g>0 then
			if loc==LOCATION_HAND then
				rg=g:RandomSelect(tp,1)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				rg=g:Select(tp,1,1,nil)
			end
			if #rg>0 then
				Duel.HintSelection(rg)
				local rc=rg:GetFirst()
				if Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)>0 and rc:IsLocation(LOCATION_REMOVED) then
					if rc:IsPreviousLocation(LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
					local cid=c:GetOriginalCode()
					local fid=c:GetFieldID()
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(id,0))
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetLabel(cid,fid)
					e1:SetLabelObject(rc)
					e1:SetCountLimit(1)
					e1:SetCondition(s.retcon)
					if rc:IsPreviousLocation(LOCATION_HAND) then
						e1:SetOperation(s.retop1)
					else
						e1:SetOperation(s.retop2)
					end
					Duel.RegisterEffect(e1,tp)
					rc:RegisterFlagEffect(cid,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(id,4))
				end
			end
		end
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	local cid,fid=e:GetLabel()
	if rc:GetFlagEffectLabel(cid)==fid then
		return true
	else
		e:Reset()
		return false
	end
end
function s.retop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local rc=e:GetLabelObject()
	Duel.SendtoHand(rc,nil,REASON_EFFECT)
end
function s.retop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local rc=e:GetLabelObject()
	if not Duel.ReturnToField(rc) and rc:IsLocation(LOCATION_REMOVED) and Duel.GetMZoneCount(rc:GetPreviousControler())>0 then
		Duel.MoveToField(rc,rc:GetPreviousControler(),rc:GetPreviousControler(),rc:GetPreviousLocation(),rc:GetPreviousPosition(),true)
	end
end
function s.ffilter(c,tp)
	return c:IsOriginalCodeRule(12877735) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.e2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function s.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsAbleToHand() or Duel.IsPlayerAffectedByEffect(tp,12877735))
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local g=Duel.GetMatchingGroup(s.ffilter,tp,LOCATION_HAND,0,nil,tp)
	if Duel.IsPlayerAffectedByEffect(tp,12877735) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(12877735,0)) then
		Duel.Hint(HINT_CARD,0,12877735)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else
		Duel.SendtoHand(c,nil,REASON_COST)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x5a73) and c:IsType(TYPE_MONSTER) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g==0 then return end
	local tc=g:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local te=c.self_hand_effect
		local ce=te:Clone()
		ce:SetReset(RESET_EVENT+RESETS_STANDARD)
		ce:SetRange(LOCATION_MZONE)
		ce:SetCost(s.cost)
		tc:RegisterEffect(ce,true)
		tc:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		if not tc:IsType(TYPE_EFFECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_EFFECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
end