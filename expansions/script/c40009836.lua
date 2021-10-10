--魔界侯爵 阿蒙逆
local m=40009836
local cm=_G["c"..m]
cm.named_with_Amon=1
cm.named_with_Reverse=1
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(function(e,c) return e:GetHandler()~=c and c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM) end)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)  
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.valcheck1)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
	--add type
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(cm.tncon)
	e4:SetOperation(cm.tnop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(cm.valcheck2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5) 
	--decrease tribute
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DECREASE_TRIBUTE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(LOCATION_HAND,0)
	e6:SetCountLimit(1,m)
	e6:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_SZONE+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_PZONE,0)
	e6:SetValue(0x1)
	c:RegisterEffect(e6)  
end
function cm.valcheck1(e,c)
	local g=c:GetMaterial()
	if g:FilterCount(Card.IsType,nil,TYPE_PENDULUM)==#g then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and e:GetLabel()==1
end
function cm.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.thfilter(c)
	return cm.filter(c) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_EXTRA,0,1,c,c:GetCode())
end
function cm.setfilter(c,code)
	return cm.filter(c) and not c:IsCode(code) and not c:IsForbidden()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc1=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc2=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_EXTRA,0,1,1,tc1,tc1:GetCode()):GetFirst()
		Duel.SendtoHand(tc1,nil,REASON_EFFECT)
		Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		Duel.ConfirmCards(1-tp,tc1)
	end
end
function cm.valcheck2(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,40009828) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and e:GetLabel()==1
end
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(600)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e3)
end