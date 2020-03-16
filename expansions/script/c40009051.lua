--忍法 御灵降身
function c40009051.initial_effect(c)
	aux.AddRitualProcGreater2(c,c40009051.mfilter,nil,c40009051.mfilter) 
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTarget(c40009051.reptg)
	e5:SetValue(c40009051.repval)
	e5:SetOperation(c40009051.repop)
	c:RegisterEffect(e5) 
end
function c40009051.mfilter(c)
	return c:IsSetCard(0x2b)
end
function c40009051.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x2b)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c40009051.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c40009051.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c40009051.repval(e,c)
	return c40009051.repfilter(c,e:GetHandlerPlayer())
end
function c40009051.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
