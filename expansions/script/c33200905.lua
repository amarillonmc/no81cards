--寒霜灵兽 冰冻光束
function c33200905.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33200905.cttg)
	e1:SetOperation(c33200905.ctop)
	c:RegisterEffect(e1)
	--tofield
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33200905)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCondition(c33200905.thcon)
	e2:SetTarget(c33200905.thtg)
	e2:SetOperation(c33200905.thop)
	c:RegisterEffect(e2)
end

function c33200905.ctfilter(c)
	return c:GetCounter(0x132a)>0 and c:IsType(TYPE_MONSTER)
end
function c33200905.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc:GetCounter(33200900)>0 and tc:GetControler()~=tp then 
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,nil,0,0x132a)
	end
end
function c33200905.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,33200905,nil,EFFECT_FLAG_OATH,1)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:GetCounter(0x132a)>0 and tc:GetControler()~=tp then 
			if not tc:IsDisabled() or tc:IsType(TYPE_TRAPMONSTER) then

		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CANNOT_ATTACK)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33200615,3))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end

			end
		else
			local fc=Duel.GetFlagEffect(tp,33200905)+2
			if fc>0 and tc:IsCanAddCounter(0x132a,fc) then
				tc:AddCounter(0x132a,fc)
			end
		end
	end
end


--e2
function c33200905.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c33200905.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,5,REASON_EFFECT) and e:GetHandler():IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c33200905.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,5,REASON_EFFECT) then
		Duel.SSet(tp,c)
	end
end