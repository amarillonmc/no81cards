--亵渎永恒的国度
function c98930407.initial_effect(c)
	aux.AddCodeList(c,98930401)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98930407+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c98930407.cost)
	e1:SetOperation(c98930407.activate)
	c:RegisterEffect(e1)	
	local e3=e1:Clone()
	e3:SetCondition(c98930407.con1)
	e3:SetRange(LOCATION_DECK)
	c:RegisterEffect(e3)
	--eat
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98930507)
	e2:SetCost(c98930407.negcost)
	e2:SetCondition(c98930407.discon)
	e2:SetTarget(c98930407.distg)
	e2:SetOperation(c98930407.disop)
	c:RegisterEffect(e2)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,98930607)
	e4:SetCondition(c98930407.discon2)
	e4:SetCost(c98930407.spcost1)
	e4:SetTarget(c98930407.distg2)
	e4:SetOperation(c98930407.disop2)
	c:RegisterEffect(e4)
end
function c98930407.spfilter(c,e,tp)
	return c:IsCode(98930401) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98930407.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>0 or e:GetHandler():IsLocation(LOCATION_SZONE) end
	if e:GetHandler():IsLocation(LOCATION_DECK) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local tc=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
		local te=tc:IsHasEffect(98930403,tp)
		te:UseCountLimit(tp)
	end
end
function c98930407.con1(e)
	local tp=e:GetHandlerPlayer()
	local tc=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	return tc and tc:IsHasEffect(98930403,tp)
end
function c98930407.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98930407.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(98930407,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98930407.actcfilter(c)
	return c:IsCode(98930401) and c:IsFaceup()
end
function c98930407.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98930407.actcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98930407.kfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsFaceup()
end
function c98930407.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1 and #g>0 end
end
function c98930407.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_EXTRA,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)~=0 and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetCode(EFFECT_CHANGE_TYPE)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		   e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		   tc:RegisterEffect(e1)
		end
	end
end
function c98930407.disfilter(c)
	return c:IsCode(98930401) and c:IsLevel(11) and c:IsFaceup()
end
function c98930407.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98930407.disfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98930407.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #g>0 end
end
function c98930407.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98930407.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98930407.cfilter,tp,LOCATION_SZONE-LOCATION_FZONE,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c98930407.cfilter1(c,tp)
	return c:IsAbleToRemoveAsCost()
end
function c98930407.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c98930407.cfilter1,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98930407.cfilter1,tp,LOCATION_SZONE,0,1,1,nil,tp)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98930407.disop2(e,tp,eg,ep,ev,re,r,rp)
   	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=g:FilterSelect(tp,aux.TRUE,1,1,nil)
		if tg:GetCount()>0 then
		   local tc=tg:GetFirst()
		   if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetCode(EFFECT_CHANGE_TYPE)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			  tc:RegisterEffect(e1)
			end
			Duel.ShuffleExtra(1-tp)
		end
	end
end