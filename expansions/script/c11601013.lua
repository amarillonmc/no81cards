--星界灵的一击
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate(effect)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id+EFFECT_FLAG_COUNT_LIMIT)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Activate(summon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCountLimit(1,id+EFFECT_FLAG_COUNT_LIMIT)
	e2:SetCondition(s.condition1)
	e2:SetTarget(s.target1)
	e2:SetOperation(s.activate1)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_SPELL))) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function s.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x48)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return aux.NegateSummonCondition(e,tp,eg,ep,ev,re,r,rp)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	local desg=eg:Clone()
	if eg:IsExists(Card.IsType,1,nil,TYPE_XYZ) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local g=eg:Filter(Card.IsType,nil,TYPE_XYZ)
		local tmpg=Group.CreateGroup()
		for tc in aux.Next(g) do
			if tc:IsAbleToExtra() then
				tc:CancelToGrave()
				tmpg:AddCard(tc)
				local code=tc:GetOriginalCodeRule()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_ADD_SETCODE)
				e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
				e1:SetTargetRange(0xff,0xff)
				e1:SetLabel(code)
				e1:SetTarget(s.code_tg)
				e1:SetValue(0x48)
				Duel.RegisterEffect(e1,tp)
			end
		end
		if #tmpg>0 then
			desg:Sub(tmpg)
			Duel.SendtoDeck(tmpg,tp,2,REASON_EFFECT)
		end
	end
	if #desg>0 then
		Duel.Destroy(desg,REASON_EFFECT)
	end
end
function s.code_tg(e,c)
	return c:GetOriginalCodeRule()==e:GetLabel()
end
