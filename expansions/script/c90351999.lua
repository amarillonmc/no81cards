--巴别塔
function c90351999.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCountLimit(1,90351999+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e2)
	--add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0xff,0)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0x1)
	c:RegisterEffect(e3)
	--activate cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_DECK+LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c90351999.costtg)
	e4:SetOperation(c90351999.costop)
	c:RegisterEffect(e4)
	--change effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(90351999)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	c:RegisterEffect(e5)
	--workaround
	if not aux.setcard_hack_check then
		aux.setcard_hack_check=true
		_IsSetCard=Card.IsSetCard
		function Card.IsSetCard(c,setname)
			if Duel.IsPlayerAffectedByEffect(c:GetControler(),90351999) then
				return _IsSetCard(c,setname) or _IsSetCard(c,0x1)
			end
			return _IsSetCard(c,setname)
		end
		_IsFusionSetCard=Card.IsFusionSetCard
		function Card.IsFusionSetCard(c,setname)
			if Duel.IsPlayerAffectedByEffect(c:GetControler(),90351999) then
				return _IsFusionSetCard(c,setname) or _IsFusionSetCard(c,0x1)
			end
			return _IsFusionSetCard(c,setname)
		end
		_IsLinkSetCard=Card.IsLinkSetCard
		function Card.IsLinkSetCard(c,setname)
			if Duel.IsPlayerAffectedByEffect(c:GetControler(),90351999) then
				return _IsLinkSetCard(c,setname) or _IsLinkSetCard(c,0x1)
			end
			return _IsLinkSetCard(c,setname)
		end
	end
end
function c90351999.costtg(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc==e:GetHandler() and te:IsHasType(EFFECT_TYPE_QUICK_O) and (tc:IsLocation(LOCATION_HAND) or tc:IsLocation(LOCATION_DECK))
end
function c90351999.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	te:SetType(EFFECT_TYPE_ACTIVATE)
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	local ge3=Effect.CreateEffect(tc)
	ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetCode(EVENT_CHAIN_SOLVED)
	ge3:SetLabelObject(te)
	ge3:SetReset(RESET_PHASE+PHASE_END)
	ge3:SetOperation(c90351999.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function c90351999.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		re:SetType(EFFECT_TYPE_QUICK_O)
		e:Reset()
	end
end
