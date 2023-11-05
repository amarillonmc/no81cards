--加特姆士的战术掩护
function c49811255.initial_effect(c)
	--Summon Launch Effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88232397+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c49811255.condition)
	e1:SetCost(c49811255.cost)
	e1:SetTarget(c49811255.target)
	e1:SetOperation(c49811255.operation)
	c:RegisterEffect(e1)
end
function c49811255.confilter(c)
	return c:IsSetCard(0xb0) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c49811255.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c49811255.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c49811255.cfilter(c)
	return (c:IsSetCard(0xb0) or c:IsSetCard(0x100d)) and c:IsType(TYPE_MONSTER)
end
function c49811255.costfilter(c,g,e,tp)
	return c:IsSetCard(0xb0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and g:IsExists(c49811255.ckfilter,4,nil,g,e,tp,c)
end
function c49811255.ckfilter(c,g,e,tp,tc)
	local sg=g:Filter(c49811255.spfilter,tc,e,tp)
	return sg:GetClassCount(Card.GetRace)>=4
end
function c49811255.spfilter(c,e,tp)
	return c:IsSetCard(0x100d) and c:IsLocation(LOCATION_DECK+LOCATION_GRAVE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811255.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c49811255.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:IsExists(c49811255.costfilter,1,nil,g,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c49811255.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,g,e,tp)
	Duel.SendtoGrave(cg,REASON_COST)
end
function c49811255.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>3 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c49811255.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c49811255.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<4 then return end
	if g:GetClassCount(Card.GetRace)<4 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.drccheck,false,4,4)
	if sg:GetCount()==4 then
		local fid=e:GetHandler():GetFieldID()
		tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e0:SetRange(LOCATION_MZONE)
			e0:SetCode(EFFECT_IMMUNE_EFFECT)
			e0:SetValue(c49811255.efilter)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e0)
			if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END then
				tc:RegisterFlagEffect(49811255,RESET_EVENT+RESETS_STANDARD+0x60000200,0,2,fid)
				tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+0x60000200,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(49811255,0))
			else
				tc:RegisterFlagEffect(49811255,RESET_EVENT+RESETS_STANDARD+0x60000200,0,1,fid)
				tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+0x60000200,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(49811255,0))
			end
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(sg)
		e1:SetCondition(c49811255.retcon)
		e1:SetOperation(c49811255.retop)
		if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
			e1:SetLabel(fid,Duel.GetTurnCount())
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e1:SetLabel(fid,0)
		end
		Duel.RegisterEffect(e1,tp)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c49811255.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(0,1)
    e3:SetValue(HALF_DAMAGE)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
end
function c49811255.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c49811255.retfilter(c,fid)
	return c:GetFlagEffectLabel(49811255)==fid
end
function c49811255.retcon(e,tp,eg,ep,ev,re,r,rp)
	local l1,l2=e:GetLabel()
	if Duel.GetTurnPlayer()==tp or Duel.GetTurnCount()==l2 then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c49811255.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c49811255.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c49811255.retfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
function c49811255.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (se:GetHandler():IsSetCard(0x100d) and se:IsActivated())
end