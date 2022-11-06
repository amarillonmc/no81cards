--天空漫步者 白濑未萌
function c9910591.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x955),2,2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910591)
	e1:SetCondition(c9910591.thcon)
	e1:SetCost(c9910591.thcost)
	e1:SetTarget(c9910591.thtg)
	e1:SetOperation(c9910591.thop)
	e1:SetLabel(9910591)
	c:RegisterEffect(e1)
	if not c9910591.global_check then
		c9910591.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c9910591.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(c9910591.checkop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_SOLVED)
		ge3:SetOperation(c9910591.checkop3)
		Duel.RegisterEffect(ge3,0)
	end
end
function c9910591.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) or re:GetLabel()==9910591 then return end
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if loc~=LOCATION_MZONE then return end
	if rc:GetFlagEffect(9910591+p)==0 then
		rc:RegisterFlagEffect(9910591+p,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,1)
	else
		local flag=rc:GetFlagEffectLabel(9910591+p)
		if flag then rc:SetFlagEffectLabel(9910591+p,flag+1) end
	end
end
function c9910591.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) or re:GetLabel()==9910591 then return end
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if loc~=LOCATION_MZONE or rc:GetFlagEffect(9910591+p)==0 then return end
	local flag=rc:GetFlagEffectLabel(9910591+p)
	if flag==1 then
		rc:ResetFlagEffect(9910591+p)
	elseif flag then
		rc:SetFlagEffectLabel(9910591+p,flag-1)
	end
end
function c9910591.checkop3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) or re:GetLabel()==9910591 then return end
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE and rc:GetFlagEffect(9910593+p)==0 then
		rc:RegisterFlagEffect(9910593+p,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c9910591.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910591.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9910591.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsAbleToHand()
end
function c9910591.filter2(c,p)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and (c:GetFlagEffect(9910591+p)>0 or c:GetFlagEffect(9910593+p)>0)
end
function c9910591.filter3(c,b1,b2,p)
	return (b1 and c9910591.filter1(c)) or (b2 and c9910591.filter2(c,p))
end
function c9910591.filter4(c,b2,b3)
	return c:IsAbleToHand() or (b2 and b3)
end
function c9910591.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingTarget(c9910591.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c9910591.filter2,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil)
	if chkc then return false end
	if chk==0 then return b1 or b2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c9910591.filter3,tp,LOCATION_MZONE,0,1,1,nil,b1,b2,p)
	local tc=g1:GetFirst()
	e:SetLabelObject(tc)
	local b3=c9910591.filter2(tc,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,c9910591.filter4,tp,0,LOCATION_MZONE,1,1,nil,b2,b3)
end
function c9910591.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) and (tc:GetFlagEffect(9910591+tp)>0 or tc:GetFlagEffect(9910593+tp)>0)
		and Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910591,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local sg=Duel.SelectMatchingCard(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
		if sg:GetCount()>0 then
			local sc=sg:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(sc,RESET_TURN_SET)
			Duel.Destroy(sc,REASON_EFFECT)
		end
	else
		local tg=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
