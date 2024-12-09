--人理之基 斯卡哈
function c22021220.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff1),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--disable and reduce ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021220,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22021220)
	e1:SetCondition(c22021220.condition1)
	e1:SetCost(c22021220.cost)
	e1:SetTarget(c22021220.target)
	e1:SetOperation(c22021220.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,0x21e0)
	e2:SetCondition(c22021220.condition2)
	c:RegisterEffect(e2) 
	--damage 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(22021220,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DETACH_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET) 
	e3:SetTarget(c22021220.damtg)
	e3:SetOperation(c22021220.damop)
	c:RegisterEffect(e3)
end
function c22021220.ckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,22021220) 
end 
function c22021220.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c22021220.ckfil,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22021220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22021220.filter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or aux.NegateMonsterFilter(c))
end
function c22021220.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c22021220.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22021220.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c22021220.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SelectOption(tp,aux.Stringid(22020370,2))
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
	end
end
function c22021220.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22021220.ckfil,tp,LOCATION_ONFIELD,0,1,nil)
		and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end
function c22021220.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetTargetPlayer(1-tp) 
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500) 
end 
function c22021220.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.SelectOption(tp,aux.Stringid(22020370,3))
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	if Duel.Damage(p,d,REASON_EFFECT)~=0 and c:GetOverlayCount()>0 then 
		local x=c:GetOverlayCount() 
		if x>5 then x=5 end 
		for i=1,x do 
			Duel.Damage(1-tp,500,REASON_EFFECT) 
		end 
	end 
end 

