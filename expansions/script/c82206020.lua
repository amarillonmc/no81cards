local m=82206020
local cm=_G["c"..m]
cm.name="植占师1-太阳"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--light
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.con1)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x129d))  
	e2:SetValue(aux.tgoval)  
	c:RegisterEffect(e2) 
	--water
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)  
	e3:SetRange(LOCATION_FZONE)  
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.con2)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x129d))  
	e3:SetValue(cm.ind)  
	c:RegisterEffect(e3)
	--light
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e4:SetRange(LOCATION_FZONE)   
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(cm.con3)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x129d))  
	e4:SetValue(aux.indoval)  
	c:RegisterEffect(e4)
	--light
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetCode(EFFECT_UPDATE_ATTACK)  
	e5:SetRange(LOCATION_FZONE)  
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(cm.con4)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x129d))  
	e5:SetValue(500)  
	c:RegisterEffect(e5)	
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.filter1(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d) and c:GetOriginalAttribute()==ATTRIBUTE_LIGHT
end 
function cm.con2(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.filter2(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d) and c:GetOriginalAttribute()==ATTRIBUTE_WATER 
end 
function cm.ind(e,re,r,rp)  
	if bit.band(r,REASON_BATTLE)~=0 then  
		return 1  
	else return 0 end  
end  
function cm.con3(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.filter3(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d) and c:GetOriginalAttribute()==ATTRIBUTE_EARTH 
end 
function cm.con4(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.filter4,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.filter4(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d) and c:GetOriginalAttribute()==ATTRIBUTE_FIRE  
end 