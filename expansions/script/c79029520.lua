--CiNo.62 超银河眼光子龙皇
function c79029520.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,4)
	c:EnableReviveLimit() 
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c79029520.atkval)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetOperation(c79029520.op)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c79029520.sptg1)
	e3:SetOperation(c79029520.spop1)
	c:RegisterEffect(e3)
	--disable 
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetTarget(c79029520.target)
	e6:SetCondition(c79029520.condition)
	e6:SetOperation(c79029520.activate)
	e6:SetCountLimit(1)
	c:RegisterEffect(e6)
end
function c79029520.atkval(e,c)
	return c:GetOverlayCount()*500
end
function c79029520.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local tc=g:GetFirst()
	while tc do
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetRange(LOCATION_ONFIELD)
		  e1:SetCode(EFFECT_DISABLE) 
		  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		  tc:RegisterEffect(e1)
		  local e2=Effect.Clone(e1)
		  e2:SetCode(EFFECT_DISABLE_EFFECT)
		  tc:RegisterEffect(e2)
	 tc=g:GetNext() 
end
end
function c79029520.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return  not rc:IsLocation(LOCATION_ONFIELD) and Duel.IsChainNegatable(ev) and rc:GetControler()~=tp
end
function c79029520.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	end
end
function c79029520.fil(c)
	return not c:IsForbidden() and c:IsSetCard(0x7b)
end
function c79029520.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.IsExistingMatchingCard(c79029520.fil,tp,LOCATION_DECK,0,1,nil) then
	if Duel.SelectYesNo(tp,aux.Stringid(3298689,1)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c79029520.fil,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.Overlay(e:GetHandler(),g)
	end
end
end
function c79029520.fill(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x7b)
end
function c79029520.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc~=c and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c79029520.fill(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and Duel.IsExistingMatchingCard(c79029520.fill,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c79029520.fill,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029520.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_ONFIELD) then
		if Duel.SpecialSummon(e:GetHandler(),1,tp,tp,true,true,POS_FACEUP) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(c:GetAttack()*2)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
	end
end