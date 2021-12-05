local m=53711007
local cm=_G["c"..m]
cm.name="魔理沙役 MZ"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.hdcost)
	e1:SetTarget(cm.hdtg)
	e1:SetOperation(cm.hdop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function cm.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
end
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)*300
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)*300
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,val,REASON_EFFECT)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x3538) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil,e,tp)
	local g2=c:GetOverlayGroup():Filter(cm.filter,nil,e,tp)
	g:Merge(g2)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.timefilter(c,tp)
	return c:IsHasEffect(53711065,tp) and c:GetFlagEffect(53711015)<2
end
function cm.spfilter(c,e,tp,cd)
	local timeg=Duel.GetMatchingGroup(cm.timefilter,tp,LOCATION_MZONE,0,c,tp)
	if c:IsLocation(LOCATION_HAND) then
		if cd<3 then return c:IsType(TYPE_SPELL) and c:IsDiscardable()
		elseif cd==3 then return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
		else return c:IsDiscardable() end
	elseif c:IsLocation(LOCATION_GRAVE) then
		return c:IsAbleToRemove() and c:IsHasEffect(53711009,tp)
	else
		return c:IsSetCard(0x3538) and c:IsType(TYPE_SPELL) and #timeg>0
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil,e,tp)
	local g2=c:GetOverlayGroup():Filter(cm.filter,nil,e,tp)
	g:Merge(g2)
	if g:GetCount()>0 then
		local sg=g:Select(tp,1,1,nil)
		local cd=sg:GetFirst():GetOriginalCode()-53711000
		if not sg:GetFirst():IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,cd,nil,e,tp,cd) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and sg:GetFirst():IsLocation(LOCATION_HAND) then Duel.RaiseSingleEvent(sg:GetFirst(),EVENT_CUSTOM+53711005,e,0,0,0,0) end
		else Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
	end
end
