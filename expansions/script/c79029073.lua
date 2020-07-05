--喀兰贸易·行动-谢拉格の荣光
function c79029073.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029073+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c79029073.con)
	e1:SetTarget(c79029073.target)
	e1:SetCost(c79029073.cost)
	e1:SetOperation(c79029073.activate)
	c:RegisterEffect(e1) 
	--disable 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(73594093,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c79029073.tdtg)
	e2:SetOperation(c79029073.tdop)
	e2:SetCost(c79029073.tdcost)
	c:RegisterEffect(e2)   
end
function c79029073.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c79029073.filter2(c,e,tp)
	return c:IsType(TYPE_FUSION+TYPE_XYZ+TYPE_SYNCHRO+TYPE_LINK)
end
function c79029073.filter3(c,e,tp)
	return c:IsSetCard(0x1906)
end
function c79029073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=Duel.GetLinkedZone(tp)
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		return ct>0 and Duel.IsExistingMatchingCard(c79029073.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029073.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79029073.filter3,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function c79029073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	x=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(x,REASON_COST+REASON_DISCARD)
end
function c79029073.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=Duel.GetLinkedZone(tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if ct<=0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c79029073.filter),tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e5)
	end
end
function c79029073.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c79029073.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c79029073.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79029073.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,tp,LOCATION_MZONE)
end
function c79029073.tdop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)   
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(-1000)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
end
end