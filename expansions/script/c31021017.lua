--Antonymph Cheery Grave
function c31021017.initial_effect(c)
	--send
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c31021017.target)
	e1:SetOperation(c31021017.activate)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--reset
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,31021017)
	e2:SetCondition(c31021017.setcon)
	e2:SetTarget(c31021017.settg)
	e2:SetOperation(c31021017.setop)
	c:RegisterEffect(e2)
end
function c31021017.filter(c)
	return c:IsSetCard(0x893) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c31021017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31021017.filter,tp,LOCATION_GRAVE,0,1,nil) and
			Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil) > 0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c31021017.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c31021017.filter,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local max=2
	if g2:GetCount() < max then max=g2:GetCount() end
	if max > 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,max,nil)
		local ct=Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
		if ct > 0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg2=g2:Select(tp,ct,ct,nil)
			Duel.SendtoGrave(sg2,REASON_EFFECT)
		end
	end
end

function c31021017.exfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(tp) and c:IsSetCard(0x893) and c:IsFaceup()
end
function c31021017.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c31021017.exfilter,1,nil,tp) and aux.exccon(e)
end
function c31021017.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c31021017.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end