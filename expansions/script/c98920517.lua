--DDD 炙血王 阿提拉
function c98920517.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--atk def down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920517,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c98920517.target)
	e2:SetOperation(c98920517.operation)
	c:RegisterEffect(e2)
	 --gain atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920517,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920517.atkcon)
	e2:SetOperation(c98920517.atkop)
	c:RegisterEffect(e2)
end
function c98920517.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c98920517.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local att=tc:GetAttribute()
	if tc:IsAttribute(ATTRIBUTE_DARK) then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_ATTACK_ALL)
	   e1:SetValue(c98920517.atkfilter)
	   c:RegisterEffect(e1)
	end
	if tc:IsAttribute(ATTRIBUTE_DEVINE) then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_ATTACK_ALL)
	   e1:SetValue(c98920517.atkfilter1)
	   c:RegisterEffect(e1)
	end
	if tc:IsAttribute(ATTRIBUTE_EARTH) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(c98920517.atkfilter2)
		c:RegisterEffect(e1)
	end
	if tc:IsAttribute(ATTRIBUTE_FIRE) then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_ATTACK_ALL)
	   e1:SetValue(c98920517.atkfilter3)
	   c:RegisterEffect(e1)
	end
	if tc:IsAttribute(ATTRIBUTE_LIGHT) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(c98920517.atkfilter4)
	c:RegisterEffect(e1)
	end
	if tc:IsAttribute(ATTRIBUTE_WATER) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(c98920517.atkfilter5)
	c:RegisterEffect(e1)
	end
	if tc:IsAttribute(ATTRIBUTE_WIND) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(c98920517.atkfilter6)
	c:RegisterEffect(e1)
	end
	local e11=Effect.CreateEffect(e:GetHandler())
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_ATTACK)
	e11:SetTargetRange(LOCATION_MZONE,0)
	e11:SetTarget(c98920517.ftarget)
	e11:SetLabel(e:GetHandler():GetFieldID())
	e11:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e11,tp)
	local e4=Effect.CreateEffect(e:GetHandler())  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_PIERCE)  
	e4:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(e:GetHandler())  
	e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetCode(EFFECT_CHANGE_DAMAGE)  
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetTargetRange(1,1)  
	e5:SetValue(c98920517.damval)  
	c:RegisterEffect(e5)
end
function c98920517.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c98920517.atkfilter(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c98920517.atkfilter1(e,c)
	return c:IsAttribute(ATTRIBUTE_DEVINE)
end
function c98920517.atkfilter2(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c98920517.atkfilter3(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c98920517.atkfilter4(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c98920517.atkfilter5(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c98920517.atkfilter6(e,c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c98920517.damval(e,re,dam,r,rp,rc)  
	if bit.band(r,REASON_BATTLE)~=0 and Duel.GetAttacker()==e:GetHandler() and e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetBattleTarget():IsPosition(POS_DEFENSE) then  
		return dam+1000
	else return dam end  
end 
function c98920517.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r&REASON_EFFECT==REASON_EFFECT 
end
function c98920517.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetLabelObject(e)
		e1:SetValue(ev)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end