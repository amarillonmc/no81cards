--摸鱼龙姬 铃夏
function c67200800.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)

	--splimit

	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c67200800.effcon)
	e2:SetOperation(c67200800.effop)
	c:RegisterEffect(e2)   
	--must be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_MUST_BE_FMATERIAL)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_MUST_BE_SMATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_MUST_BE_XMATERIAL)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_MUST_BE_LMATERIAL)
	c:RegisterEffect(e6) 
end
--
function c67200800.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK)~=0 
end
function c67200800.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(67200800,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c67200800.destg)
	e1:SetOperation(c67200800.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
	--rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(67200800,5))
end
function c67200800.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c67200800.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_CHANGE_CODE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(82732705)
			c:RegisterEffect(e2)
			local cid=c:CopyEffect(82732705,RESET_EVENT+RESETS_STANDARD)
		end
	end
end


