--人理之基 拉克什米·芭伊
function c22024260.initial_effect(c)
	--summon  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_MZONE)
	e1:SetTarget(function(e,c) 
	return c:IsType(TYPE_MONSTER) and c~=e:GetHandler() end)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1) 
	--tribute check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c22024260.valcheck)
	c:RegisterEffect(e2)
	--sum eff 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e3:SetCode(EVENT_SUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetLabelObject(e2)
	e3:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) end)
	e3:SetTarget(c22024260.sumetg) 
	e3:SetOperation(c22024260.sumeop) 
	c:RegisterEffect(e3) 
end
function c22024260.valcheck(e,c)
	local g=c:GetMaterial() 
	local tp=c:GetControler() 
	local mchk1=0 
	local mchk2=0 
	local mchk3=0 
	local tc=g:GetFirst()
	while tc do
	if tc:IsLocation(LOCATION_HAND) then mchk1=1 end 
	if tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) then mchk2=1 end 
	if tc:IsLocation(LOCATION_MZONE) and tc:IsControler(1-tp) then mchk3=1 end 
	tc=g:GetNext()
	end 
	e:SetLabel(mchk1,mchk2,mchk3)
end
function c22024260.sumetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end 
function c22024260.sumeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local mchk1,mchk2,mchk3=e:GetLabelObject():GetLabel()  
	if mchk1==1 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c22024260.discon)
		e1:SetOperation(c22024260.disop)
		Duel.RegisterEffect(e1,tp)
	end 
	if mchk2==1 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c22024260.discon1)
		e1:SetOperation(c22024260.disop1)
		Duel.RegisterEffect(e1,tp)
	end 
	if mchk3==1 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c22024260.discon2)
		e1:SetOperation(c22024260.disop2)
		Duel.RegisterEffect(e1,tp)
	end 
end 
function c22024260.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(22021400)==0 and ep~=tp
end
function c22024260.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	e:GetHandler():RegisterFlagEffect(22021400,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Hint(HINT_CARD,0,22021400)
		Duel.Destroy(rc,REASON_EFFECT)
		e:Reset()
	end
end

function c22024260.discon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_TRAP) and e:GetHandler():GetFlagEffect(22021401)==0 and ep~=tp
end
function c22024260.disop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	e:GetHandler():RegisterFlagEffect(22021401,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Hint(HINT_CARD,0,22021401)
		Duel.Destroy(rc,REASON_EFFECT)
		e:Reset()
	end
end

function c22024260.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetFlagEffect(22021402)==0 and ep==tp
end
function c22024260.disop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	e:GetHandler():RegisterFlagEffect(22021402,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Hint(HINT_CARD,0,22021402)
		Duel.Destroy(rc,REASON_EFFECT)
		e:Reset()
	end
end