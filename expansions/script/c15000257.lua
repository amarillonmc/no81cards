local m=15000257
local cm=_G["c"..m]
cm.name="永寂连接3"
function cm.initial_effect(c)
	--xyz summon  
	c:EnableReviveLimit()  
	aux.AddXyzProcedure(c,nil,7,4)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(cm.tgcon)
	e2:SetValue(cm.tgtg)
	c:RegisterEffect(e2)
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
function cm.tgcon(e)
	local g=e:GetHandler():GetOverlayGroup()
	return g:IsExists(cm.tgfilter,1,nil)
end
function cm.tgtg(e,c)
	return c~=e:GetHandler()
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