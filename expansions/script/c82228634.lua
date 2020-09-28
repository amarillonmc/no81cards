local m=82228634
local cm=_G["c"..m]
cm.name="孑影之法皇"
function cm.initial_effect(c)
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,cm.matfilter,2,99)
	--cannot be target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e2:SetTarget(cm.target)
	e2:SetTargetRange(LOCATION_ONFIELD,0)  
	e2:SetValue(aux.tgoval)  
	c:RegisterEffect(e2)
	--activate limit  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetTargetRange(0,1)  
	e3:SetCondition(cm.actcon)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)
	--pierce  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c)  
	e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetCode(EFFECT_CHANGE_DAMAGE)  
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e5:SetTargetRange(1,1)  
	e5:SetValue(cm.damval)  
	c:RegisterEffect(e5) 
	--atk up  
	local e6=Effect.CreateEffect(c)  
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)  
	e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e6:SetCondition(cm.atkcon)
	e6:SetOperation(cm.atkop)  
	c:RegisterEffect(e6)   
end
function cm.matfilter(c)
	return c:IsLinkSetCard(0x3299)
end  
function cm.damval(e,re,dam,r,rp,rc)  
	if bit.band(r,REASON_BATTLE)~=0 and Duel.GetAttacker()==e:GetHandler() and e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetBattleTarget():IsPosition(POS_DEFENSE) then  
		return dam*4 
	else return dam end  
end  
function cm.target(e,c)  
	return c:IsSetCard(0x3299) 
end  
function cm.actcon(e)  
	local ph=Duel.GetCurrentPhase()  
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE  
end  
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	local bc=e:GetHandler():GetBattleTarget()  
	return bc:IsDefensePos()
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp) 
	Debug.Message("踏入死境的旅人，你已无路可逃，")
	Debug.Message("在这噩梦般疯狂的荒草残烟之中，化为灰烬吧…… ")
end