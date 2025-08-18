--元素奇美拉
local s,id,o=GetID()
function c98921104.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c98921104.ffilter,2,true)	
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	e4:SetCondition(c98921104.ctlcon)
	c:RegisterEffect(e4)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e1:SetCondition(c98921104.ctlcon)
	c:RegisterEffect(e1)
	--double attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetCondition(c98921104.ctlcon1)
	c:RegisterEffect(e1)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98921104.ctlcon3)
	e3:SetValue(c98921104.atkval)
	c:RegisterEffect(e3)
	--Disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98921104.ctlcon2)
	e1:SetOperation(c98921104.operation)
	c:RegisterEffect(e1)
end
function c98921104.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or (not sg:IsExists(Card.IsRace,1,c,c:GetRace())
			and not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function s.indtg(e,c)
	local tc=e:GetHandler()
	return c==tc or c==tc:GetBattleTarget()
end
function c98921104.filter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c98921104.ctlcon(e)
	return Duel.IsExistingMatchingCard(c98921104.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_WATER)
end
function c98921104.ctlcon1(e)
	return Duel.IsExistingMatchingCard(c98921104.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_WIND)
end
function c98921104.ctlcon2(e)
	return Duel.IsExistingMatchingCard(c98921104.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_EARTH)
end
function c98921104.ctlcon3(e)
	return Duel.IsExistingMatchingCard(c98921104.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_FIRE)
end
function c98921104.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:GetClassCount(Card.GetAttribute)*500
end
function c98921104.operation(e,tp,eg,ep,ev,re,r,rp)
	local sf=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	if sf then 
	   local tc=sf:GetFirst()
	   while tc do 
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_DISABLE)
			 e1:SetReset(RESET_EVENT+0x17a0000)
			 tc:RegisterEffect(e1)
			 local e2=Effect.CreateEffect(e:GetHandler())
			 e2:SetType(EFFECT_TYPE_SINGLE)
			 e2:SetCode(EFFECT_DISABLE_EFFECT)
			 e2:SetReset(RESET_EVENT+0x17a0000)
			 tc:RegisterEffect(e2)
			 tc=sf:GetNext()
	   end
	end
end