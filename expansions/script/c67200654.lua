--拟态武装 格莱普尼
function c67200654.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x667b),2,2,c67200654.lcheck)
	c:EnableReviveLimit()   
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200654,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c67200654.atkcon1)
	e1:SetTarget(c67200654.atktg1)
	e1:SetOperation(c67200654.atkop1)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200654,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,67200654)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c67200654.cost)
	e3:SetOperation(c67200654.operation)
	c:RegisterEffect(e3)	
end
function c67200654.lcheck(g,lc)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_LIGHT)
end
--
function c67200654.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c67200654.atkval(e,c)
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
function c67200654.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end
	if chk==0 then return mg:IsExists(Card.IsLevelAbove,1,nil,1) end
end
function c67200654.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c67200654.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c67200654.filter(c,mc)
	return c:IsLevel(3) and c:IsSetCard(0x667b) and c:IsAbleToRemoveAsCost()
		and not c:IsAttribute(mc:GetAttribute()) 
end
function c67200654.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200654.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67200654.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c67200654.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local att=tc:GetAttribute()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end