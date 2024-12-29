local m=15000256
local cm=_G["c"..m]
cm.name="永寂之生命：苍夜"
function cm.initial_effect(c)
	--xyz summon  
	c:EnableReviveLimit()  
	aux.AddXyzProcedure(c,nil,7,2)
	--extra summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,2)) 
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)  
	e1:SetRange(LOCATION_MZONE)  
	--e1:GetCondition(cm.immcon)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)  
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf37))  
	c:RegisterEffect(e1) 
	--actlimit  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetTargetRange(0,1)  
	e3:SetValue(1)  
	e3:SetCondition(cm.actcon)  
	c:RegisterEffect(e3)
	--XyzSummon 
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e4:SetOperation(cm.regop)  
	c:RegisterEffect(e4)
end
function cm.tgfilter(c,e,tp)  
	return c:IsType(TYPE_LINK)
end
function cm.immcon(e)
	local g=e:GetHandler():GetOverlayGroup()
	return g:IsExists(cm.tgfilter,1,nil)
end
function cm.actcon(e)  
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()  
end 
function cm.regop(e,tp,eg,ep,ev,re,r,rp)  
	if e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) then
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)  
		e1:SetValue(LOCATION_DECKBOT)  
		e:GetHandler():RegisterEffect(e1,true)
	end
end