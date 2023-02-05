--空隙维系
local m=30008810
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	aux.EnableChangeCode(c,30008808,LOCATION_HAND+LOCATION_DECK+LOCATION_SZONE+LOCATION_GRAVE)
	--Effect 2  
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e02:SetRange(LOCATION_SZONE)
	e02:SetCode(EVENT_REMOVE)
	e02:SetCondition(cm.gcon)
	e02:SetOperation(cm.gop)
	c:RegisterEffect(e02)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(cm.mscon)
	e2:SetOperation(cm.msop)
	c:RegisterEffect(e2)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCode(EFFECT_SEND_REPLACE)
	e12:SetTarget(cm.reptg)
	e12:SetValue(cm.repval)
	c:RegisterEffect(e12)
	--Effect 3 
	local e15=Effect.CreateEffect(c)
	e15:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e15:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e15:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e15:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e15:SetCountLimit(1)
	e15:SetTarget(cm.thtg)
	e15:SetOperation(cm.thop)
	c:RegisterEffect(e15) 
end
--Effect 2
--
function cm.gf(c,tp)
	return c:IsControler(tp) and c:GetReasonPlayer()==1-tp and c:IsLocation(LOCATION_REMOVED) and c:IsAbleToGrave() 
end
function cm.gcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	return eg:IsExists(cm.gf,1,nil,tp)
end
function cm.gop(e,tp,eg,ep,ev,re,r,rp)
	local tag=eg:Filter(cm.gf,nil,tp)
	if #tag>0 then 
		Duel.SendtoGrave(tag,REASON_EFFECT+REASON_RETURN)
	end
end
--
function cm.msf(c)
	if c:IsFacedown() then return false end
	return c:IsReason(REASON_REDIRECT) and c:IsLocation(LOCATION_REMOVED) 
end
function cm.mscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.msf,1,nil)
end
function cm.msop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(cm.msf,nil):Filter(Card.IsAbleToGrave,nil)
	if #tg>0 then 
		Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)
	end
end
--
function cm.rpf(c,tp)
	return c:IsControler(1-tp) and c:GetReasonPlayer()==1-tp and c:GetDestination()==LOCATION_REMOVED and not c:IsReason(REASON_REDIRECT) 
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local pc=e:GetHandlerPlayer()
	if chk==0 then return eg:IsExists(cm.rpf,1,nil,pc) end
	local rg=eg:Filter(cm.rpf,nil,pc)
	Duel.Remove(rg,POS_FACEDOWN,REASON_REDIRECT+REASON_EFFECT)
	return true
end
function cm.repval(e,c)
	return false
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
