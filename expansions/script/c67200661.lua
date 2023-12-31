--拟态武装 不灭之翼
function c67200661.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x667b),2,2,c67200661.lcheck)
	c:EnableReviveLimit()   
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200661,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c67200661.atkcon1)
	e1:SetTarget(c67200661.atktg1)
	e1:SetOperation(c67200661.atkop1)
	c:RegisterEffect(e1)
	--Gains Effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCountLimit(1,67200661)
	e2:SetCondition(c67200661.efcon)
	e2:SetOperation(c67200661.efop)
	c:RegisterEffect(e2)	
end
function c67200661.lcheck(g,lc)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_WATER)
end
--
function c67200661.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c67200661.atkval(e,c)
	local g=e:GetHandler():GetMaterial()
	local ag=Group.Filter(g,Card.IsLevelAbove,nil,1)
	local x=0
	local y=0
	local tc=ag:GetFirst()
	while tc do
		y=tc:GetLevel()
		x=x+y
		tc=ag:GetNext()
	end
	return x*500
end
function c67200661.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end
	if chk==0 then return mg:IsExists(Card.IsLevelAbove,1,nil,1) end
end
function c67200661.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c67200661.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
--
function c67200661.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReasonCard():IsSetCard(0x667b) 
end
function c67200661.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(67200661,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c:GetBaseAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
end
