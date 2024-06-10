--向空挥拳！
function c33703032.initial_effect(c)
--这张卡在自己场上有且仅有1只怪兽存在的场合可以从手卡发动。 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c33703032.handcon)
	c:RegisterEffect(e1)
--自己场上只有这张卡和1只怪兽的场合才能发动。自己场上的怪兽的攻击力·守备力变成5000。自己没有手卡的场合，自己场上的怪兽直到下个对方的结束阶段时不受效果影响。是自己回合的场合，这个回合结束。
	local e2=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33703032.target)
	e1:SetOperation(c33703032.activate)
	c:RegisterEffect(e2)

end
--这张卡在自己场上有且仅有1只怪兽存在的场合可以从手卡发动。 
function c33703032.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==1
end
function c33703032.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==2 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_SZONE,0)==1
end
--自己场上只有这张卡和1只怪兽的场合才能发动。自己场上的怪兽的攻击力·守备力变成5000。
function c33703032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	for i=1,ev do
		Duel.NegateActivation(i)
	end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup(),tp,LOCATION_MZONE,0,1,nil) end
end
function c33703032.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup(),tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(5000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(5000)
		tc:RegisterEffect(e2)
--自己没有手卡的场合，自己场上的怪兽直到下个对方的结束阶段时不受效果影响。
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e3:SetValue(c33703032.value)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
--是自己回合的场合，这个回合结束。
	if Duel.GetTurnPlayer()==1-tp then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c33703032.value(e,te)
	return te:GetOwner()~=e:GetOwner()
end