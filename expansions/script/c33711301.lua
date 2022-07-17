--内卷
local m=33711301
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.check(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(cm.check,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.check,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function cm.check(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,c) and not Duel.IsExistingMatchingCard(cm.check2,tp,LOCATION_MZONE,0,1,c,c:GetAttack(),c:GetDefense())
end
function cm.check2(c,atk,def)
	return c:IsFaceup() and c:IsAttackAbove(atk) and c:IsDefenseAbove(def)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,tc)
	local sum=0
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	local op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	if op==0 then
		for dc in aux.Next(g) do
			local at=dc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			dc:RegisterEffect(e1)
			if dc:IsAttack(atk) then sum=math.abs(atk-at)+sum end
		end
	else
		for dc in aux.Next(g) do
			local df=dc:GetDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE)
			e1:SetValue(def)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			dc:RegisterEffect(e1)
			if dc:IsDefense(def) then sum=math.abs(def-df)+sum end
		end
	end
	if sum>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetLabel(sum)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(cm.damop)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam=e:GetLabel()
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) then
		dam=dam/2
	end
	Duel.Damage(tp,dam,REASON_EFFECT)
end
