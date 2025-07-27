--超机龙兵 深渊嘶吼
local m=21196520
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.cost2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.cost(e,te_or_c,tp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(Card.IsReleasable,nil)
	return #g>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(Card.IsReleasable,nil)
	Duel.Hint(3,1-tp,HINTMSG_TOGRAVE)
	local sg=g:Select(1-tp,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
end
function cm.atlimit(e,c)
	return not c:IsSetCard(0x6919)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then return end
	Duel.RegisterFlagEffect(tp,m,0,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTarget(cm.atlimit)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	Duel.RegisterEffect(e1,tp)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() and Duel.GetLocationCount(tp,4)>0 and Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,TYPE_MONSTER)>0 and Duel.GetLocationCount(tp,8)>0 end
	if c:IsLocation(LOCATION_GRAVE) then
	e:SetCategory(CATEGORY_LEAVE_GRAVE)
	end
end
function cm.op3_con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()<=0
end
function cm.op3_op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsForbidden() and Duel.GetLocationCount(tp,4)>0 and Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true) then
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_ADJUST)
		ce1:SetRange(LOCATION_MZONE)
		ce1:SetCondition(cm.op3_con1)
		ce1:SetOperation(cm.op3_op1)
		ce1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(ce1,true)
		local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,TYPE_MONSTER)
		if #g<=0 or Duel.GetLocationCount(tp,8)<=0 then return end
		local x=Duel.GetLocationCount(tp,8)
		x=math.min(x,3)
		local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK+LOCATION_EXTRA,LOCATION_DECK+LOCATION_EXTRA,nil,TYPE_MONSTER)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(3,tp,HINTMSG_EQUIP)
		local tg=sg:Select(tp,1,x,nil)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
		for tc in aux.Next(tg) do
			if Duel.Equip(tp,tc,c) then 
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetLabelObject(c)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.eqlimit)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				e2:SetValue(3000)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end