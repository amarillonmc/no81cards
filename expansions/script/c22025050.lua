--人理之诗 包围苍天的小世界
function c22025050.initial_effect(c)
	aux.AddCodeList(c,22025040,22025820)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetTarget(c22025050.target)
	e1:SetOperation(c22025050.activate)
	c:RegisterEffect(e1)
	--aeg
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22025050.aegcon)
	e3:SetOperation(c22025050.aegop)
	c:RegisterEffect(e3)
end
function c22025050.lmfilter(c)
	return c:IsFaceup() and c:IsSetCard(22025040) 
end
function c22025050.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1) 
end
function c22025050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22025050.filter,tp,LOCATION_MZONE,0,1,nil) end
	if Duel.IsExistingMatchingCard(c22025050.lmfilter,tp,LOCATION_MZONE,0,1,nil) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c22025050.chainlm)
	end
end
function c22025050.chainlm(e,rp,tp)
	return tp==rp
end
function c22025050.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(c22025050.filter,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c22025050.efilter)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			e4:SetOwnerPlayer(tp)
			tc:RegisterEffect(e4)
			tc=g:GetNext()
	end
end
function c22025050.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c22025050.aegcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==tp and re:GetHandler():IsCode(22025820) and Duel.GetFlagEffect(tp,22026360)==0 and c:IsAbleToRemove()
end
function c22025050.aegop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(22025050,0)) then
		Duel.Hint(HINT_CARD,0,22025050)
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,22025050,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(22025050,1))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
	end
end
