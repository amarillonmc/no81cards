--腐坏的异梦怪物
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400030.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,yume.YumeCheck(c))
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e1a)
	--[[
	local e1b=e1:Clone()
	e1b:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e1b)
	--]]
	--negate spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetDescription(aux.Stringid(71400030,0))
	e2:SetCondition(c71400030.condition)
	e2:SetCost(c71400030.cost)
	e2:SetTarget(c71400030.target)
	e2:SetOperation(c71400030.operation)
	c:RegisterEffect(e2)
end
function c71400030.filter2(c)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK) and c:IsAbleToRemove()
end
function c71400030.cfilter2(c,g)
	return g:IsContains(c)
end
function c71400030.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c71400030.filter2,1,nil)
end
function c71400030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c71400030.cfilter2,tp,LOCATION_ONFIELD,0,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71400030.cfilter2,tp,LOCATION_ONFIELD,0,1,1,nil,lg)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c71400030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c71400030.filter2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c71400030.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c71400030.filter2,nil)
	if g:GetCount()>0 then
		Duel.NegateSummon(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:GetCount()>0 then
			Duel.BreakEffect()
			local tc=og:GetFirst()
			local atk=0
			while tc do
				local tatk=tc:GetTextAttack()
				if tatk>0 then atk=atk+tatk end
				tc=og:GetNext()
			end
			Duel.SetLP(tp,Duel.GetLP(tp)-atk)
		end
	end
end