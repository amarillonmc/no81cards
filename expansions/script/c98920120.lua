--古代的机械改造士兵
function c98920120.initial_effect(c)
		--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()   
 --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetCondition(c98920120.adcon)
	e1:SetValue(c98920120.atkval)
	c:RegisterEffect(e1)	
--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetCondition(c98920120.adcon)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)  
  --actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c98920120.aclimit)
	e2:SetCondition(c98920120.actcon)
	c:RegisterEffect(e2)   
 --pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
end
function c98920120.adcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetHandler():GetMaterial():IsExists(Card.IsRace,1,nil,RACE_MACHINE)
end
function c98920120.atkval(e,c)
	return c:GetBaseAttack()*2
end
function c98920120.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c98920120.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end