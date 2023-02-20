--幻魔的继承者
function c98920351.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c98920351.ffilter,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE,0,Duel.Remove,POS_FACEUP,REASON_COST)
--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
 --effect gain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(c98920351.regop)
	c:RegisterEffect(e0)
--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c98920351.ffilter(c)
	return c:IsCode(6007213) or c:IsCode(32491822) or c:IsCode(69890967)
end
function c98920351.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,69890967) then
	  --immune spell
		 local e1=Effect.CreateEffect(c)
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_IMMUNE_EFFECT)
		 e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		 e1:SetRange(LOCATION_MZONE)
		 e1:SetValue(c98920351.efilter)
		 c:RegisterEffect(e1)
		 ---atkup
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCondition(c98920351.atkcon)
		e4:SetValue(4000)
		c:RegisterEffect(e4)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98920351,0))
	end
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,32491822) then
		--immune spell
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_IMMUNE_EFFECT)
	   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	   e1:SetRange(LOCATION_MZONE)
	   e1:SetValue(c98920351.efilter)
	   c:RegisterEffect(e1)
	 --atkup
	   local e4=Effect.CreateEffect(c)
	   e4:SetType(EFFECT_TYPE_SINGLE)
	   e4:SetCode(EFFECT_UPDATE_ATTACK)
	   e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	   e4:SetRange(LOCATION_MZONE)
	   e4:SetCondition(c98920351.atkcon)
	   e4:SetValue(4000)
	   c:RegisterEffect(e4)
	   c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98920351,1))
	end
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,6007213) then
	--atkup
		  local e3=Effect.CreateEffect(c)
		  e3:SetType(EFFECT_TYPE_SINGLE)
		  e3:SetCode(EFFECT_UPDATE_ATTACK)
		  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		  e3:SetRange(LOCATION_MZONE)
		  e3:SetValue(c98920351.atkval)
		  e3:SetCondition(c98920351.atkcon)
		  c:RegisterEffect(e3) 
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_IMMUNE_EFFECT)
		  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		  e1:SetRange(LOCATION_MZONE)
		  e1:SetValue(c98920351.efilter2)
		  c:RegisterEffect(e1)
		  c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98920351,2))
	end
end
function c98920351.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c98920351.atkcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c98920351.efilter1(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c98920351.atkval(e,c)
	return Duel.GetMatchingGroupCount(c98920351.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end
function c98920351.efilter2(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c98920351.atkfilter(c)
	return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end