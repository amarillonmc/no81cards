local m=53738011
local cm=_G["c"..m]
cm.name="歼世暴突轮"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(cm.actcost)
	e1:SetTarget(cm.acttg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(cm.descost)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e4)
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsStatus(STATUS_SET_TURN) then return true end
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,2,nil,0x5532) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,2,2,nil,0x5532)
	Duel.Release(g,REASON_COST)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if cm.descost(e,tp,eg,ep,ev,re,r,rp,0)
		and cm.destg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetOperation(cm.desop)
		cm.descost(e,tp,eg,ep,ev,re,r,rp,1)
		cm.destg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,6000) end
	Duel.PayLPCost(tp,6000)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5532)
end
function cm.fselect(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD)==g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ac==0 or ct==0 then return end
	if ac>ct then ac=ct end
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	local sg=g:Filter(Card.IsSetCard,nil,0x5532)
	local ct=#sg
	local fg=Duel.GetMatchingGroup(cm.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	if ct>0 and #fg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		sg:Merge(fg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local og=sg:SelectSubGroup(tp,cm.fselect,false,1,math.min(ct,#fg)*2)
		Duel.DisableShuffleCheck()
		if Duel.Destroy(og,REASON_EFFECT+REASON_REVEAL)~=0 then
			local sct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
			Duel.SortDecktop(tp,tp,sct)
			for i=1,sct do
				local mg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(mg:GetFirst(),1)
			end
		else Duel.ShuffleDeck(tp) end
	else Duel.ShuffleDeck(tp) end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and e:GetHandler():IsReason(REASON_DESTROY)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToHand),1-tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
