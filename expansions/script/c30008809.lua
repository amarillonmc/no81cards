--空隙机航母 裁定号
local m=30008809
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e1)
	--Effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(cm.ycon)
	e2:SetTarget(cm.ytg)
	e2:SetOperation(cm.yop)
	c:RegisterEffect(e2)  
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,4))
	e12:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetRange(LOCATION_FZONE)
	e12:SetCode(EVENT_REMOVE)
	e12:SetCountLimit(3)
	e12:SetCondition(cm.yrcon)
	e12:SetTarget(cm.yrtg)
	e12:SetOperation(cm.yrop)
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
function cm.rf(c)
	return not c:IsType(TYPE_TOKEN)
end
function cm.ycon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and eg:IsExists(cm.rf,1,nil)
end
function cm.ytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local ct=ec:GetFlagEffect(m)
	if chk==0 then return ct==0 and Duel.IsPlayerCanDraw(tp,1) end
	ec:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.yop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.yrcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(cm.rf,1,nil)
end
function cm.yrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local ct=ec:GetFlagEffect(m+100)
	if chk==0 then return ct<3 end
	ec:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
end
function cm.pf(c,tp)
	return c:GetPreviousControler()==tp
end
function cm.shf(c)
	return c:GetBaseDefense()==3333 and c:IsAbleToHand()
end
function cm.yrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tag=eg:Filter(cm.rf,nil)
	local rg=tag:Filter(cm.pf,nil,tp)
	local thg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.shf),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local rmg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
	if #tag==0 then return end
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1000)
	if #rg>0 and #thg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		local tg=thg:Select(tp,1,1,nil)
		if #tg==0 then return false end
		Duel.BreakEffect()
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	if rg:FilterCount(Card.IsFacedown,nil)>0 and #rmg>0 
		and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
		local mg=rmg:Select(tp,1,1,nil)
		if #mg==0 then return false end
		Duel.BreakEffect()
		Duel.HintSelection(mg)
		Duel.Remove(mg,POS_FACEDOWN,REASON_EFFECT)
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

