--鼓动的愿望 美树沙耶香
function c60152903.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c60152903.e1filter,nil,nil,c60152903.e1matfilter,true)
	e1:SetDescription(aux.Stringid(60152903,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,60152903)
	e1:SetCondition(c60152903.e1con)
	c:RegisterEffect(e1)
	if not c60152903.global_check then
		c60152903.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c60152903.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60152903,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,6012903)
	e2:SetCondition(c60152903.con)
	e2:SetTarget(c60152903.e2tg)
	e2:SetOperation(c60152903.e2op)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60152903,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,602903)
	e3:SetCondition(c60152903.con)
	e3:SetTarget(c60152903.e3tg)
	e3:SetOperation(c60152903.e3op)
	c:RegisterEffect(e3)
end
function c60152903.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
end
function c60152903.e1filter(c,e,tp,chk)
	return c:IsSetCard(0x3b29) and (not chk or c~=e:GetHandler())
end
function c60152903.e1matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
function c60152903.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c60152903.check(c)
	return c 
end
function c60152903.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c60152903.check(Duel.GetAttacker()) and c60152903.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,60152903,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,60152903,RESET_PHASE+PHASE_END,0,1)
	end
end
function c60152903.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=PLAYER_ALL
	if chk==0 then return not Duel.GetFlagEffect(tp,60152903)==0 and Duel.GetMatchingGroupCount(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)>0 end
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,1000)
end
function c60152903.e2opfilter(c)
	return c:IsAbleToDeck()
end
function c60152903.e2op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p==PLAYER_ALL then
		Duel.Damage(0,d,REASON_EFFECT,true)
		Duel.Damage(1,d,REASON_EFFECT,true)
		Duel.RDComplete()
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c60152903.e2opfilter,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(tc:GetDefense()*2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetValue(1)
			tc:RegisterEffect(e3)
			tc=g:GetNext()
		end
	end
end
function c60152903.e3tgfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x3b29)
end
function c60152903.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60152903.e3tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60152903.e3op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60152903.e3tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end