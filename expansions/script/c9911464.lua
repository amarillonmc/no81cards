--浮想联翩的闪蝶幻乐
function c9911464.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9911464.condition)
	e1:SetTarget(c9911464.target)
	e1:SetOperation(c9911464.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9911464.settg)
	e2:SetOperation(c9911464.setop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(9911464,ACTIVITY_CHAIN,c9911464.chainfilter)
	if not c9911464.global_check then
		c9911464.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c9911464.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911464.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_ONFIELD) then
			Duel.RegisterFlagEffect(tc:GetPreviousControler(),9911464,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c9911464.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and re:IsActiveType(TYPE_MONSTER))
end
function c9911464.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(9911464,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(9911464,1-tp,ACTIVITY_CHAIN)~=0
end
function c9911464.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9911464.spfilter(c,e,tp)
	return c:IsSetCard(0x3952) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911464.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) and tc:IsLocation(LOCATION_REMOVED) then
		Duel.AdjustAll()
		local p=tc:GetControler()
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9911464.spfilter),p,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,p)
		if Duel.GetLocationCount(p,LOCATION_MZONE)>0 and #g>0 and Duel.SelectYesNo(p,aux.Stringid(9911464,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			local sg=g:Select(p,1,1,nil)
			Duel.SpecialSummon(sg,0,p,p,false,false,POS_FACEUP)
		end
	end
end
function c9911464.setfilter(c,e,tp)
	if not c:IsType(TYPE_MONSTER) or not c:IsSetCard(0x3952) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1,true)
	local res=c:IsSSetable(true)
	e1:Reset()
	return res
end
function c9911464.filter(c,e,tp,b1,b2)
	if b1 then
		if not c9911464.setfilter(c,e,tp) then return false end
		return not b2 or Duel.IsExistingMatchingCard(c9911464.setfilter,tp,LOCATION_DECK,0,1,c,e,1-tp)
	else
		return c9911464.setfilter(c,e,1-tp)
	end
end
function c9911464.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,9911464)>0
	local b2=Duel.GetFlagEffect(1-tp,9911464)>0
	if chk==0 then return (b1 or b2) and Duel.IsExistingMatchingCard(c9911464.filter,tp,LOCATION_DECK,0,1,nil,e,tp,b1,b2) end
end
function c9911464.setop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetFlagEffect(tp,9911464)>0
	local b2=Duel.GetFlagEffect(1-tp,9911464)>0
	if not b1 and not b2 then return end
	if not Duel.IsExistingMatchingCard(c9911464.filter,tp,LOCATION_DECK,0,1,nil,e,tp,b1,b2) then return end
	local g=Group.CreateGroup()
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911464,1))
		local tc1=Duel.SelectMatchingCard(tp,c9911464.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,true,b2):GetFirst()
		Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		Duel.RaiseEvent(tc1,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc1:RegisterEffect(e1)
		g:AddCard(tc1)
	end
	if b2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911464,2))
		local tc2=Duel.SelectMatchingCard(tp,c9911464.setfilter,tp,LOCATION_DECK,0,1,1,nil,e,1-tp):GetFirst()
		Duel.MoveToField(tc2,tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
		Duel.RaiseEvent(tc2,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e2:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc2:RegisterEffect(e2)
		g:AddCard(tc2)
	end
	local sg=g:Filter(Card.IsOnField,nil)
	if #sg>0 then Duel.ConfirmCards(1-tp,sg) end
end
