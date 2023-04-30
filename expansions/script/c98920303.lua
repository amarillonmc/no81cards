--智天之神星骑
function c98920303.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),3,99,c98920303.lcheck)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920303,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c98920303.settg)
	e1:SetOperation(c98920303.setop)
	c:RegisterEffect(e1)
  --search
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(98920303,1))
	e13:SetCategory(CATEGORY_ATKCHANGE)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1)
	e13:SetCondition(c98920303.thcon)
	e13:SetOperation(c98920303.thop)
	c:RegisterEffect(e13)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920303,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c98920303.negcon)
	e2:SetCost(c98920303.cost)
	e2:SetTarget(c98920303.negtg)
	e2:SetOperation(c98920303.negop)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920303,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(c98920303.discon)
	e3:SetCost(c98920303.cost)
	e3:SetTarget(c98920303.distg)
	e3:SetOperation(c98920303.disop)
	c:RegisterEffect(e3) 
	local e7=e3:Clone()
	e3:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e3)
end
function c98920303.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,2,nil,0xc4)
end
function c98920303.cfilter(c,ec)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_PENDULUM) and ec:GetLinkedGroup():IsContains(c) and c:IsSetCard(0xc4)
end
function c98920303.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920303.cfilter,1,nil,e:GetHandler())
end
function c98920303.thop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local g=eg:Filter(c98920303.cfilter,nil,e:GetHandler())
	 local num=g:GetSum(Card.GetAttack)
	 local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	 if mg:GetCount()>0 then
		local sc=mg:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-num)
			sc:RegisterEffect(e1)
			sc=mg:GetNext()
		end
	end
end
function c98920303.setfilter(c,tp)
	return c:IsSetCard(0xc4) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup()
end
function c98920303.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c98920303.setfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c98920303.setop(e,tp,eg,ep,ev,re,r,rp) 
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.GetMatchingGroup(c98920303.setfilter,tp,LOCATION_EXTRA,0,nil)
	if ct>0 and g:GetCount()>0 then
	   local sg=g:Select(tp,1,ct,nil)
	   local sc=sg:GetFirst()
	   while sc do
			Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			sc=sg:GetNext()
	   end
	end
end
function c98920303.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c98920303.cfilter1(c,lg)
	return lg:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsSetCard(0xc4)
end
function c98920303.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98920303.cfilter1,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c98920303.cfilter1,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c98920303.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920303.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c98920303.filter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c98920303.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c98920303.filter,1,nil,1-tp)
end
function c98920303.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c98920303.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98920303.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c98920303.filter,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end