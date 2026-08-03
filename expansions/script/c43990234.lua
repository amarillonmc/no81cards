--红露梦
function c43990234.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(43990234,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetCondition(c43990234.condition)
	e1:SetTarget(c43990234.target)
	e1:SetOperation(c43990234.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990234,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,43990234)
	e2:SetCost(c43990234.spcost)
	e2:SetTarget(c43990234.sptg)
	e2:SetOperation(c43990234.spop)
	c:RegisterEffect(e2)
	if not c43990234.global_check then
		c43990234.global_check=true
		c43990234.code_list={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c43990234.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_REMOVE)
		Duel.RegisterEffect(ge2,0)
	end
end
function c43990234.ctfilter(c)
	return c:IsSetCard(0x6510) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
end
function c43990234.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c43990234.ctfilter,nil)
	for tc in aux.Next(g) do
		local code=tc:GetCode()
		local res=true
		for _,v in pairs(c43990234.code_list) do
			if v==code then res=false end
		end
		if res then table.insert(c43990234.code_list,code) end
	end
end
function c43990234.condition(e,tp,eg,ep,ev,re,r,rp)
	return #c43990234.code_list>=12
end
function c43990234.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,43990234)==0 end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c43990234.chainlm)
	end
end
function c43990234.chainlm(e,rp,tp)
	return tp==rp
end
function c43990234.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,43990234,RESET_PHASE+PHASE_END,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6510))
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c43990234.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	if c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,c)
	else
		Duel.HintSelection(Group.FromCards(c))
	end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c43990234.spfilter(c,e,tp,chk)
	return c:IsSetCard(0x6510) and c:IsFaceupEx() and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsReason(REASON_TEMPORARY) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_REMOVED)) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsType(TYPE_MONSTER)
end
function c43990234.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c43990234.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,0)
	end--Duel.IsPlayerAffectedByEffect(tp,59822133)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c43990234.rmfilter(c,code)
	return c:IsSetCard(0x6510) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToRemove()
end
function c43990234.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	--local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sc=Duel.SelectMatchingCard(tp,c43990234.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,1):GetFirst()
	if not sc then return end
	if (sc:IsReason(REASON_TEMPORARY) and sc:IsPreviousLocation(LOCATION_MZONE) and sc:IsLocation(LOCATION_REMOVED)) and (not sc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectOption(tp,aux.Stringid(43990234,3),1152)==0) then
		local rc=sc:GetReasonEffect():GetOwner() or sc
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CUSTOM+43990234)
		e1:SetLabelObject(sc)
		e1:SetOperation(c43990234.rtop)
		Duel.RegisterEffect(e1,0)
		Duel.RaiseEvent(sc,EVENT_CUSTOM+43990234,e,0,0,0,0)
	else
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.IsExistingMatchingCard(c43990234.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,sc:GetCode()) and Duel.SelectYesNo(tp,aux.Stringid(43990234,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c43990234.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,sc:GetCode())
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
function c43990234.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end
