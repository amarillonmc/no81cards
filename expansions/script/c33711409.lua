--恐怖谷
local m=33711409
local cm=_G["c"..m]
function cm.initial_effect(c)
   function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.con(e,tp)
	return Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)==1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function cm.operation(e,tp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
		for sc in aux.Next(mg) do
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,2))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(tc:GetRace())
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetValue(tc:GetAttribute())
			sc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_SET_ATTACK)
			e3:SetValue(tc:GetAttack())
			sc:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_DEFENSE)
			e4:SetValue(tc:GetDefense())
			sc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
			e5:SetValue(1)
			sc:RegisterEffect(e5)
			local e8=Effect.CreateEffect(c)
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e8:SetValue(1)
			sc:RegisterEffect(e8)
		end
		cm[0]=tc:GetRace()
		cm[1]=tc:GetAttribute()
		cm[2]=tc:GetAttack()
		cm[3]=tc:GetDefense()
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_ADJUST)
		e0:SetOperation(cm.cop)
		Duel.RegisterEffect(e0,tp)
	end
end
function cm.afilter(c)
	return c:IsFaceup() and c:GetFlagEffect(m)==0
end
function cm.op(e,tp)
		local c=e:GetHandler()
		local mg=Duel.GetMatchingGroup(cm.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		for sc in aux.Next(mg) do
			sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,2))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(cm[0])
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetValue(cm[1])
			sc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_SET_ATTACK)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY)
			e3:SetValue(cm[2])
			sc:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_DEFENSE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY)
			e4:SetValue(cm[3])
			sc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
			e5:SetValue(1)
			sc:RegisterEffect(e5)
			local e8=Effect.CreateEffect(c)
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e8:SetValue(1)
			sc:RegisterEffect(e8)
		end 
end