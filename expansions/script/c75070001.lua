--幻想异闻录#FE “领主”法尔西昂
function c75070001.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c75070001.lcheck)
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(function(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.GetCurrentPhase()==PHASE_MAIN1 end) 
	c:RegisterEffect(e1) 
	--battle 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(c75070001.bttg) 
	e1:SetOperation(c75070001.btop) 
	c:RegisterEffect(e1)  
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(function(e,te)
	return te:GetOwner()~=e:GetOwner() end) 
	e2:SetCondition(function(e)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE end) 
	c:RegisterEffect(e2) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(function(e)
	local tp=e:GetHandlerPlayer() 
	local mag,atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetMaxGroup(Card.GetAttack) 
	if atk then 
	return atk/2
	else return 0 end end) 
	e2:SetCondition(function(e)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE end) 
	c:RegisterEffect(e2) 
	--atk 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_COIN)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)  
	e3:SetCondition(aux.dsercon)
	e3:SetTarget(c75070001.atktg)
	e3:SetOperation(c75070001.atkop)
	c:RegisterEffect(e3) 
end  
c75070001.toss_coin=true
function c75070001.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_LIGHT) 
end
function c75070001.bttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetChainLimit(c75070001.chlimit)
end
function c75070001.chlimit(e,ep,tp)
	return not e:IsActiveType(TYPE_MONSTER) 
end
function c75070001.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p=Duel.GetTurnPlayer() 
	if Duel.IsAbleToEnterBP() then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(EFFECT_CANNOT_EP) 
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
		e1:SetTargetRange(1,0) 
		e1:SetReset(RESET_PHASE+PHASE_BATTLE) 
		Duel.RegisterEffect(e1,p) 
		Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
	end 
end 
function c75070001.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,4)
end 
function c75070001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local c1,c2,c3,c4=Duel.TossCoin(tp,4)
	local ct=c1+c2+c3+c4  
	if ct>=2 and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(c:GetAttackAnnouncedCount())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1) 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e2)
	end 
end 





