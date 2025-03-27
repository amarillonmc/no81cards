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
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029520,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c79029520.negcon)
	e1:SetCost(c79029520.negcost)
	e1:SetTarget(c79029520.negtg)
	e1:SetOperation(c79029520.negop)
	c:RegisterEffect(e1)
	--disable 
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCountLimit(1,79029520)
	e6:SetTarget(c79029520.target)
	e6:SetCondition(c79029520.condition)
	e6:SetOperation(c79029520.activate)
	c:RegisterEffect(e6)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCost(c79029520.spcost1)
	e3:SetTarget(c79029520.sptg1)
	e3:SetOperation(c79029520.spop1)
	c:RegisterEffect(e3)
end
aux.xyz_number[79029520]=62
function c79029520.atkval(e,c)
	return c:GetOverlayCount()*500
end
function c79029520.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c79029520.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029520.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c79029520.negop(e,tp,eg,ep,ev,re,r,rp)
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
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
end
function c79029520.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.IsChainNegatable(ev) and rp~=tp
end
function c79029520.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	end
end
function c79029520.fil(c)
	return not c:IsForbidden() and c:IsSetCard(0x7b,0x55)
end
function c79029520.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c79029520.fil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029520,1)) then 
	local g=Duel.SelectMatchingCard(tp,c79029520.fil,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.Overlay(e:GetHandler(),g)
	end
	end
end
function c79029520.fill(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x7b) and c:IsAbleToRemoveAsCost()
end
function c79029520.spcost1(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029520.fill,tp,LOCATION_GRAVE,0,1,c) end 
	local g=Duel.SelectMatchingCard(tp,c79029520.fill,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c79029520.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029520.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
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
