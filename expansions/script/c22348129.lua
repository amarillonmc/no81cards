--剑 圣 青 朝
local m=22348129
local cm=_G["c"..m]
function cm.initial_effect(c)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348129,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22348129.aucon)
	e1:SetCost(c22348129.aucost)
	e1:SetOperation(c22348129.auop)
	c:RegisterEffect(e1)
	--disable when attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348129,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c22348129.dacon1)
	e2:SetTarget(c22348129.datg1)
	e2:SetOperation(c22348129.daop1)
	c:RegisterEffect(e2)
	--disable when Remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348129,2))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c22348129.dacon2)
	e3:SetTarget(c22348129.datg2)
	e3:SetOperation(c22348129.daop2)
	c:RegisterEffect(e3)
end
function c22348129.aucon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c22348129.aucost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c22348129.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22348129.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c22348129.auop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,22348129))
	e1:SetValue(500)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,22348129))
	Duel.RegisterEffect(e2,tp)
end
function c22348129.dacon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==nil
end
function c22348129.disfilter(c,g)
	return g:IsContains(c) and not c:IsAttack(0)
end
function c22348129.datg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c22348129.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,cg) end
	local g=Duel.GetMatchingGroup(c22348129.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,cg)
end
function c22348129.daop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c22348129.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,cg)
		if g:GetCount()>0 then
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
		end
	end
end
function c22348129.dacon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c22348129.disfilter1(c,e,tp)
	local se=e:GetHandler():GetPreviousSequence()
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then seq=aux.MZoneSequence(c:GetSequence()) end
	return seq<5 and math.abs(se-math.abs(seq-4))==0
end
function c22348129.disfilter2(c,e,tp)
	local se=e:GetHandler():GetPreviousSequence()
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then seq=aux.MZoneSequence(c:GetSequence()) end
	return seq<5 and math.abs(se-seq)==0
end
function c22348129.datg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348129.disfilter1,tp,0,LOCATION_MZONE,1,nil,e,tp) or Duel.IsExistingMatchingCard(c22348129.disfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp) end
end
function c22348129.daop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g1=Duel.GetMatchingGroup(c22348129.disfilter1,tp,0,LOCATION_MZONE,nil,e,tp)
		local g2=Duel.GetMatchingGroup(c22348129.disfilter2,tp,LOCATION_MZONE,0,nil,e,tp)
		local g=Group.__add(g1,g2)
		if g:GetCount()>0 then
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
		end
	end
end
