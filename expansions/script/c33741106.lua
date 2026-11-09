--Innocent Shower
function c33741106.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c33741106.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c33741106.damop)
	c:RegisterEffect(e4)
end
function c33741106.atkfilter(c)
	return c:IsAttackAbove(1) and c:GetEquipCount()==0 and c:IsFaceup()
end
function c33741106.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33741106.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local t={[0]=0,[1]=0}
	for tc in aux.Next(g) do
		local patk=tc:GetAttack()
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		e0:SetValue(-300)
		tc:RegisterEffect(e0)
		local i=patk-tc:GetAttack()--increment
		if i>0 and not tc:IsImmuneToEffect(e) then
			local p=tc:GetControler()
			t[p]=t[p]+i
			local cum=tc:GetFlagEffectLabel(33741106)+i or i--cumulative
			if cum==i then
				tc:RegisterFlagEffect(33741106,0,0,0,cum)
			else
				tc:SetFlagEffectLabel(33741106,cum)
			end
			if cum>=600 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			if cum>=1000 then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
				e2:SetValue(1)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			if cum>=1500 then
				tc:ReplaceEffect(33741077,RESET_EVENT+RESETS_STANDARD)--immune
				tc:ResetFlagEffect(33741106)
			end
		end
	end
	for p in aux.TurnPlayers() do Duel.Recover(p,t[p],REASON_EFFECT,true) end
	Duel.RDComplete()
end
function c33741106.damfilter(c)
	return c:GetFlagEffect(33741106)>0
end
function c33741106.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c33741106.damfilter,nil)
	local t={[0]=0,[1]=0}
	for tc in aux.Next(g) do
		local p=tc:GetPreviousControler()
		local val=tc:GetTextAttack()>0 and math.abs(tc:GetPreviousAttackOnField()-tc:GetTextAttack()) or tc:GetPreviousAttackOnField()
		t[p]=t[p]+val
		tc:ResetFlagEffect(33741106)
	end
	for p in aux.TurnPlayers() do Duel.Damage(p,t[p],REASON_EFFECT,true) end
	Duel.RDComplete()
end
