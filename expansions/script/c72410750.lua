--丹紫抵御者 安涅儿
function c72410750.initial_effect(c)
	aux.AddCodeList(c,72410700,72411010)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--ml
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72410750,1))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c72410750.condition1)
	e1:SetTarget(c72410750.target1)
	e1:SetOperation(c72410750.operation1)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72410750,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c72410750.condition2)
	e2:SetTarget(c72410750.target2)
	e2:SetOperation(c72410750.operation2)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72410750,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,72410750)
	e3:SetCost(c72410750.cost3)
	e3:SetCondition(c72410750.condition3)
	e3:SetTarget(c72410750.target3)
	e3:SetOperation(c72410750.operation3)
	c:RegisterEffect(e3)
end
function c72410750.condition1(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return  not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and c:GetMaterial():IsExists(Card.IsCode,1,nil,72410700) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)  and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)  
end
function c72410750.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c72410750.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c72410750.condition2(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return   c:GetMaterial():IsExists(Card.IsCode,1,nil,72410710) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)   
end
function c72410750.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c72410750.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c72410750.filter2(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c72410750.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c72410750.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c72410750.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c72410750.filter3(c)
	return c:IsRace(RACE_MACHINE) and (not c:IsOnField() or c:IsFaceup())
end
function c72410750.condition3(e,c)
	return Duel.GetMatchingGroupCount(c72410750.filter3,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)>=9 
end
function c72410750.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c72410750.filter4(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c72410750.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72410750.filter4,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c72410750.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>=4 then ft=4 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>0 then
	local g=Duel.GetMatchingGroup(c72410750.filter4,tp,LOCATION_DECK,0,nil,e,tp)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if sg and #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
			Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
   end
end
