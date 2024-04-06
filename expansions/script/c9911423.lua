--统魔王『世界统一』
function c9911423.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9911423.spcon)
	e1:SetOperation(c9911423.spop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,9911423)
	e2:SetOperation(c9911423.efop)
	c:RegisterEffect(e2)
end
function c9911423.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckLPCost(tp,2000)
end
function c9911423.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,2000)
end
function c9911423.effilter(c)
	return c:IsType(TYPE_EFFECT) and c:GetTurnID()==Duel.GetTurnCount() and not c:IsReason(REASON_RETURN)
end
function c9911423.efop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911423.effilter,tp,0,LOCATION_GRAVE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(9911423,0))
		e1:SetCategory(CATEGORY_DISABLE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetCondition(c9911423.discon)
		e1:SetCost(c9911423.discost)
		e1:SetOperation(c9911423.disop)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c9911423.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)&LOCATION_ONFIELD~=0
end
function c9911423.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.GetFlagEffect(tp,9911423)==0 and Duel.GetFlagEffect(1-tp,9911423)==0 end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,9911423,RESET_CHAIN,0,1)
end
function c9911423.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
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
end
