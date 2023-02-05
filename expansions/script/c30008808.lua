--空隙追猎
local m=30008808
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetLabel(0)
	e1:SetCountLimit(1)   
	e1:SetCondition(cm.descon)
	e1:SetCost(cm.descost)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--recycle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.ccon)
	e2:SetTarget(cm.ttg)
	e2:SetOperation(cm.oop)
	c:RegisterEffect(e2)
	--Effect 3  
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e12:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetCountLimit(1)
	e12:SetTarget(cm.thtg)
	e12:SetOperation(cm.thop)
	c:RegisterEffect(e12)  
end
--destroy
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.cfilter(c,tp)
	local trchk=c:IsControler(tp) or c:IsFaceup()
	local rechk=c:IsLevelAbove(9) or c:IsRankAbove(9)
	local mtchk=c:IsRace(RACE_MACHINE)
	return trchk and rechk and mtchk and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField()end
	local l=e:GetLabel()==1
	if chk==0 then
		e:SetLabel(0)
		return l and Duel.CheckReleaseGroupEx(tp,cm.cfilter,1,nil,tp)
	end
	if l then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectReleaseGroupEx(tp,cm.cfilter,1,1,nil,tp)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if not tc:IsReleasableByEffect() or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==1 then
		Duel.Destroy(tc,REASON_EFFECT)
	else
		Duel.Release(tc,REASON_EFFECT)
	end
end
--recycle
function cm.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function cm.pf(c,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local tychk=(c:IsType(TYPE_CONTINUOUS) and ft>0) or c:IsType(TYPE_FIELD)
	local code=c:IsCode(30008807,30008808,30008809)
	return not c:IsForbidden() and tychk and code and c:CheckUniqueOnField(tp)
end
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.pf(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.pf,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,cm.pf,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function cm.oop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_FIELD) then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
--Effect 3 
function cm.tdfilter(c)
	local b1=c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
	return c:GetBaseDefense()==3333 and b1 and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) and c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetActivateLocation()==LOCATION_GRAVE and c:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then	  
		local g=Group.FromCards(c,tc)
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 or g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==0 then return false end
		Duel.BreakEffect()
		Duel.Draw(e:GetHandlerPlayer(),1,REASON_EFFECT)
	end
end 
