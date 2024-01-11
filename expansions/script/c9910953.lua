--忘却的永夏 水织静久
function c9910953.initial_effect(c)
	c:EnableCounterPermit(0x6954)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910953,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910953)
	e1:SetTarget(c9910953.sptg)
	e1:SetOperation(c9910953.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910954)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9910953.setcon)
	e2:SetCost(c9910953.setcost)
	e2:SetTarget(c9910953.settg)
	e2:SetOperation(c9910953.setop)
	c:RegisterEffect(e2)
end
function c9910953.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local pchk=0
	if Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then pchk=1 end
	e:SetLabel(pchk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910953.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and e:GetLabel()==1 then
		Duel.BreakEffect()
		c:AddCounter(0x6954,1)
	end
end
function c9910953.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5954)
end
function c9910953.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910953.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c9910953.tgfilter(c)
	return c:IsSetCard(0x5954) and c:IsAbleToGraveAsCost()
end
function c9910953.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910953.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910953.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910953.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,1,nil) end
end
function c9910953.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,Card.IsSSetable,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc,tp,false)>0 and c:IsRelateToChain() and c:GetCounter(0x6954)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if tc:IsType(TYPE_SPELL) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_INACTIVATE)
			e2:SetLabel(1)
			e2:SetValue(c9910953.effectfilter)
			Duel.RegisterEffect(e2,tp)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_DISEFFECT)
			e3:SetLabel(2)
			Duel.RegisterEffect(e3,tp)
			e2:SetLabelObject(e3)
			e3:SetLabelObject(tc)
			--chk
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_LEAVE_FIELD_P)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e0:SetLabelObject(e2)
			e0:SetOperation(c9910953.chk)
			tc:RegisterEffect(e0)
			tc:RegisterFlagEffect(9910953,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910953,1))
		end
	end
end
function c9910953.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local label=e:GetLabel()
	local tc
	if label==1 then
		tc=e:GetLabelObject():GetLabelObject()
	else
		tc=e:GetLabelObject()
	end
	return tc and tc==te:GetHandler()
end
function c9910953.chk(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=e:GetLabelObject()
	local e3=e2:GetLabelObject()
	local te=c:GetReasonEffect()
	if c:GetFlagEffect(9910953)==0 or not te or not te:IsActivated() or te:GetHandler()~=c then
		e2:Reset()
		e3:Reset()
	else
		--reset
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetLabelObject(e3)
		e0:SetOperation(c9910953.resetop)
		Duel.RegisterEffect(e0,tp)
	end
end
function c9910953.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e3=e:GetLabelObject()
	local e4=e3:GetLabelObject()
	e3:Reset()
	e4:Reset()
	e:Reset()
end
