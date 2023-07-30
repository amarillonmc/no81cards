--拟态武装 骈臻
function c67200659.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c67200659.mfilter,c67200659.xyzcheck,2,2)  
	c:EnableReviveLimit() 
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200659,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c67200659.atkcon1)
	e1:SetTarget(c67200659.atktg1)
	e1:SetOperation(c67200659.atkop1)
	c:RegisterEffect(e1)	
	--negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200659,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67200659)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c67200659.negcon)
	e2:SetCost(c67200659.negcost)
	e2:SetTarget(c67200659.negtg)
	e2:SetOperation(c67200659.negop)
	c:RegisterEffect(e2)  
end
--
function c67200659.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsSetCard(0x667b) 
end
function c67200659.xyzcheck(g)
	return g:GetClassCount(c67200659.getlvrklk)==1
end
function c67200659.getlvrklk(c)
	if c:IsLevelAbove(0) then return c:GetLevel() end
	if c:IsLinkAbove(0) then return c:GetLink() end
	--return c:GetLink()
end
function c67200659.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c67200659.atkval(e,c)
	local g=e:GetHandler():GetMaterial()
	local ag=Group.Filter(g,Card.IsType,nil,TYPE_MONSTER)
	local x=0
	local y=0
	local tc=ag:GetFirst()
	while tc do
		y=tc:GetLink()
		x=x+y
		tc=ag:GetNext()
	end
	return x*1000
end
function c67200659.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end
	if chk==0 then return mg:IsExists(Card.IsType,1,nil,TYPE_LINK) end
end
function c67200659.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c67200659.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
--
function c67200659.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c67200659.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function c67200659.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c67200659.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and e:GetLabelObject():IsType(TYPE_LINK) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)		
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ATTACK_ALL)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e4)
	end
end