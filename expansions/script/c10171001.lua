--余火
function c10171001.initial_effect(c)
	--release self
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c10171001.rscost)
	e1:SetTarget(c10171001.rstg)
	e1:SetOperation(c10171001.rsop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10171001,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10171001.thcon)
	e2:SetTarget(c10171001.thtg)
	e2:SetOperation(c10171001.thop)
	c:RegisterEffect(e2)
end
function c10171001.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10171001.spfilter(c,e,tp)
	return c:IsSetCard(0xa335) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10171001.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c10171001.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(10171001,2)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(10171001,4)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	else
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end
function c10171001.rsop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10171001.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		if tc and not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_INACTIVATE)
			e3:SetLabel(1)
			e3:SetValue(c10171001.effectfilter)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_CANNOT_DISEFFECT)
			e4:SetLabel(2)
			Duel.RegisterEffect(e4,tp)
			e3:SetLabelObject(e4)
			e4:SetLabelObject(tc)
			--chk
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_LEAVE_FIELD_P)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END)
			e0:SetLabelObject(e3)
			e0:SetOperation(c10171001.chk)
			tc:RegisterEffect(e0)
			tc:RegisterFlagEffect(10171001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10171001,5))
		end
	end
end
function c10171001.effectfilter(e,ct)
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
function c10171001.chk(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=e:GetLabelObject()
	local e4=e3:GetLabelObject()
	local te=c:GetReasonEffect()
	if c:GetFlagEffect(10171001)==0 or not te or not te:IsActivated() or te:GetHandler()~=c then
		e3:Reset()
		e4:Reset()
	else
		--reset
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetLabelObject(e3)
		e0:SetOperation(c10171001.resetop)
		Duel.RegisterEffect(e0,tp)
	end
end
function c10171001.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e3=e:GetLabelObject()
	local e4=e3:GetLabelObject()
	e3:Reset()
	e4:Reset()
	e:Reset()
end
function c10171001.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0xa335,0xc335)
end
function c10171001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10171001.cfilter,1,nil)
end
function c10171001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentChain()==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10171001.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
