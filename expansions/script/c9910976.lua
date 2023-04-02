--永夏的畅行
require("expansions/script/c9910950")
function c9910976.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910976+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c9910976.target)
	e1:SetOperation(c9910976.activate)
	c:RegisterEffect(e1)
end
function c9910976.filter(c)
	return c:IsSetCard(0x5954) and c:IsFaceup()
end
function c9910976.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910976.filter,tp,LOCATION_MZONE,0,1,nil) end
	local tep=nil
	if Duel.GetCurrentChain()>1 then tep=Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_PLAYER) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and tep and tep==1-tp then
		e:SetLabel(1)
	end
end
function c9910976.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910976.filter,tp,LOCATION_MZONE,0,nil)
	local res=#g>0
	if res then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
		if e:GetLabel()==1 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil,tp,POS_FACEDOWN)
			and Duel.SelectYesNo(tp,aux.Stringid(9910976,0)) then
			Duel.BreakEffect()
			local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil,tp,POS_FACEDOWN)
			if #rc>0 and Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)>0 then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(c9910976.negcon)
				e2:SetOperation(c9910976.negop)
				e2:SetReset(RESET_CHAIN)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
	QutryYx.ExtraEffectSelect(e,tp,res)
end
function c9910976.negcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and (LOCATION_HAND+LOCATION_GRAVE)&loc~=0
		and Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,9910976)==0
end
function c9910976.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910976)
	Duel.RegisterFlagEffect(tp,9910976,RESET_CHAIN,0,1)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
	end
	e:Reset()
end
