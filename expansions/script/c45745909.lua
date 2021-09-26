--极翼灵兽 烈空坐
function c45745909.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745909,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCost(c45745909.accost)
	e1:SetTarget(c45745909.actg)
	e1:SetOperation(c45745909.acop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c45745909.reptg)
	e2:SetValue(c45745909.repval)
	e2:SetOperation(c45745909.repop)
	c:RegisterEffect(e2)
end
--e1
function c45745909.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c45745909.acfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsCode(45745921) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c45745909.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45745909.acfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c45745909.acop(e,tp,eg,ep,ev,re,r,rp)  
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,45745909,RESET_CHAIN,0,1) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(45745909,2))
	local tc=Duel.SelectMatchingCard(tp,c45745909.acfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	Duel.ResetFlagEffect(tp,45745909)
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
--e2
function c45745909.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c45745909.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x881) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c45745909.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c45745909.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c45745909.repval(e,c)
	return c45745909.repfilter(c,e:GetHandlerPlayer())
end
function c45745909.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end