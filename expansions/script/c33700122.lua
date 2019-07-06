--霓火街口
function c33700122.initial_effect(c)
c:EnableCounterPermit(0x5)
	  --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c33700122.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c33700122.ctcon)
	e2:SetOperation(c33700122.ctop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700122,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(c33700122.cost)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCountLimit(1)
	e3:SetTarget(c33700122.target)
	e3:SetOperation(c33700122.operation)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c33700122.tg)
	e4:SetOperation(c33700122.op)
	c:RegisterEffect(e4)
end
function c33700122.filter(c)
	return c:GetCounter(0x5)>0
end
function c33700122.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
   local g=Duel.GetMatchingGroup(c33700122.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
   if g:GetCount()>0 then
   local ct
	local tg=g:GetFirst()
	while tg do
	 if not tg:IsImmuneToEffect(e) then
	 ct=ct+tg:GetCounter(0x5)
	 Duel.RemoveCounter(tg,tp,0x5,tg:GetCounter(0x5),REASON_EFFECT)   
	 end
	 tg=g:GetNext()
end
   e:GetHandler():AddCounter(0x5,ct) 
end
end
function c33700122.cfilter(c)
	return c:IsSetCard(0x443) 
end
function c33700122.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return g:IsExists(c33700122.cfilter,1,nil) and bit.band(r,REASON_EFFECT)~=0 and ep==1-tp
end
function c33700122.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x5,1)
end
function c33700122.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x5)>0 end
	e:GetHandler():RemoveCounter(tp,0x5,1,REASON_COST)
end
function c33700122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700122.addfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local sg=Duel.GetMatchingGroup(c33700122.addfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sg:GetCount()*500)
end
function c33700122.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroupCount(c33700122.addfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Damage(1-tp,sg*500,REASON_EFFECT)
end
function c33700122.addfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x443)
end
function c33700122.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700122.addfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetCounter(0x5)>0 end
end
function c33700122.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c33700122.addfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
	   g:GetFirst():AddCounter(0x5,e:GetHandler():GetCounter(0x5))
	end
end