--幻想所有者
function c49811514.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetDescription(aux.Stringid(49811514,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,49811514)
	e1:SetCost(c49811514.cost)
	e1:SetTarget(c49811514.target)
	e1:SetOperation(c49811514.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811514,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811514+1)
	e2:SetCondition(c49811514.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c49811514.sptg)
	e2:SetOperation(c49811514.spop)
	c:RegisterEffect(e2)
end
function c49811514.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c49811514.cfilter(c,p)
	return c:GetOwner()==p and c:IsFaceup() and c:IsAbleToRemove()
end
function c49811514.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c49811514.cfilter,tp,LOCATION_ONFIELD,0,nil,1-tp)
	if chk==0 then return sg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c49811514.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c49811514.cfilter,tp,LOCATION_ONFIELD,0,nil,1-tp)
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	for tc in aux.Next(og) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c49811514.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c49811514.discon)
		e2:SetOperation(c49811514.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if og:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) and tg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c49811514.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c49811514.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c49811514.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c49811514.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c49811514.spfilter(c,e,tp)
	return (Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) or Duel.GetMZoneCount(1-tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)) and c:IsFaceup()
end
function c49811514.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811514.spfilter,tp,0,LOCATION_REMOVED,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_REMOVED)
end
function c49811514.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectTarget(tp,c49811514.spfilter,tp,0,LOCATION_REMOVED,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local s1=Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local s2=Duel.GetMZoneCount(1-tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
	local toplayer=aux.SelectFromOptions(tp,
		{s1,aux.Stringid(49811514,0),tp},
		{s2,aux.Stringid(49811514,1),1-tp})
	if toplayer~=nil then
		Duel.SpecialSummon(tc,0,tp,toplayer,false,false,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
