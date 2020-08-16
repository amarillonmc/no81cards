--深海色之恋
local m=33330076
local cm=_G["c"..m]
function c33330076.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33330076,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.cost)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.filter(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPDEFENSE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		  Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		  local e1=Effect.CreateEffect(c)
		  e1:SetCode(EFFECT_CHANGE_TYPE)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		  e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		  tc:RegisterEffect(e1)		
	end
end

function cm.sfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.setfilter(c)
	return c:IsCode(33330076) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		if Duel.SSet(tp,tc)>0 then
			Duel.BreakEffect()
		end
	end
end