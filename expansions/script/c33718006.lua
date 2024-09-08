--水之女演员 地图鱼
function c33718006.initial_effect(c)
--c9822220
--你控制的「水之女演员 / Aquaactress」怪兽攻击对手的怪兽的场合，对对手造成穿刺伤害。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcd))
	c:RegisterEffect(e1)
--一回合一次（快速效果）；指定对手场上不多于你控制的「水之女演员 / Aquaactress」怪兽数量的卡片，那些卡只要此卡在场上存在就效果无效，指定了怪兽卡的场合，再让那些怪兽的ATK·DEF成为0。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33718006,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33718006.target)
	e2:SetOperation(c33718006.activate)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33718006.discondition)
	e3:SetOperation(c33718006.disactivate)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c33718006.leaveactivate)
	c:RegisterEffect(e4)
end
function c33718006.filter(c)
	return c:IsSetCard(0xcd)
end
function c33718006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c33718006.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c33718006.filter,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.HintSelection(g)--可删
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do 
		if tc:IsRelateToEffect(e) and Duel.RegisterFlagEffect(tc,33718006,0,0,0)~=0 and tc:IsType(TYPE_MONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetValue(0)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e4:SetValue(0)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
		end
		tc=g:GetNext()
	end
end
function c33718006.discondition(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp==1-tp and re:GetHandler():GetCounter(0x46d)>0
end
function c33718006.disactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c33718006.leaveactivate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	tc=g:GetFirst()
	while tc do
		Duel.ResetFlagEffect(tc,33718006)
		c=g:GetNext()
	end
end










