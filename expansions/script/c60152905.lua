--虚伪的臊动 美树沙耶香
function c60152905.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c60152905.e1filter,nil,nil,c60152905.e1matfilter,true)
	e1:SetDescription(aux.Stringid(60152905,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,60152905)
	e1:SetCondition(c60152905.e1con)
	c:RegisterEffect(e1)
	
	Duel.AddCustomActivityCounter(60152905,ACTIVITY_CHAIN,aux.TRUE)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60152905,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,6012905)
	e2:SetCondition(c60152905.con)
	e2:SetTarget(c60152905.e2tg)
	e2:SetOperation(c60152905.e2op)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60152905,2))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,602905)
	e3:SetCondition(c60152905.con)
	e3:SetTarget(c60152905.e3tg)
	e3:SetOperation(c60152905.e3op)
	c:RegisterEffect(e3)
end
function c60152905.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
end
function c60152905.e1filter(c,e,tp,chk)
	return c:IsSetCard(0x3b29) and (not chk or c~=e:GetHandler())
end
function c60152905.e1matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
function c60152905.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c60152905.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=PLAYER_ALL
	if chk==0 then return Duel.GetCustomActivityCount(60152905,1-tp,ACTIVITY_CHAIN)~=0 end
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,1000)
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsOnField() and tc:IsRelateToEffect(te) and tc:IsAbleToDeck() then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
end
function c60152905.e2op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==PLAYER_ALL then
		Duel.Damage(0,d,REASON_EFFECT,true)
		Duel.Damage(1,d,REASON_EFFECT,true)
		Duel.RDComplete()
		Duel.BreakEffect()
		local dg=Group.CreateGroup()
		for i=1,ev do
			local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.NegateActivation(i) then
				local tc=te:GetHandler()
				if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) and tc:IsAbleToDeck() then
					dg:AddCard(tc)
				end
			end
		end
	end
end
function c60152905.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c60152905.e3op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end