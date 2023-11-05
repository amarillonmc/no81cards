--终墟逐退
local m=30015070
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=ors.redraw(c)
	--all
	local ge1=ors.allop2(c)
end
c30015070.isoveruins=true
--all
--Effect 1
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED 
	if chkc then return chkc:IsLocation(loc) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,loc,loc,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,loc,loc,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local res=0
	local tg=Duel.GetTargetsRelateToChain()
	if #tg==0 then return false end
	for tc in aux.Next(tg) do 
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))  
	end 
	tg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(tg)
	e1:SetCondition(cm.thcon)
	e1:SetOperation(cm.thop)
	Duel.RegisterEffect(e1,tp)
end
function cm.thf(c)
	return c:GetFlagEffect(m)>0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:FilterCount(cm.thf,nil)==0 then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.thf,nil)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	local res=1
	Duel.BreakEffect()
	cm.exrmop(e,tp,res,tg)
end
function cm.exrmop(e,tp,res,exg)
	if res==0 then return false end
	local ec=e:GetHandler()
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(ors.rf),tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD,0,exg,1-tp) 
	if #rg>0 and Duel.SelectYesNo(1-tp,aux.Stringid(30015500,4)) and Duel.IsPlayerCanRemove(1-tp) then
		Duel.Hint(HINT_CARD,0,ec:GetOriginalCodeRule())
		Duel.ConfirmCards(1-tp,rg)
		local sg=Group.CreateGroup()
		local g1=rg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
		local g2=rg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		local g3=rg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		local g4=rg:Filter(Card.IsLocation,nil,LOCATION_DECK)
		local ct=3
		if #g1>0 and ct>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(30015500,0))
			local sg1=g1:FilterSelect(1-tp,aux.NecroValleyFilter(ors.rf),0,ct,exg,1-tp)
			ct=ct-#sg1
			sg:Merge(sg1)
		end
		if #g2>0 and ct>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(30015500,1))
			local sg2=g2:FilterSelect(1-tp,aux.NecroValleyFilter(ors.rf),0,ct,exg,1-tp)
			ct=ct-#sg2
			sg:Merge(sg2)
		end 
		if #g3>0 and ct>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(30015500,2))
			local sg3=g3:FilterSelect(1-tp,aux.NecroValleyFilter(ors.rf),0,ct,exg,1-tp)
			ct=ct-#sg3
			sg:Merge(sg3)
		end
		if #g4>0 and ct>0 then
			local nt=0
			if ct==3 then nt=1 end
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(30015500,3))
			local sg4=g4:FilterSelect(1-tp,aux.NecroValleyFilter(ors.rf),nt,ct,exg,1-tp)
			ct=ct-#sg4
			sg:Merge(sg4)
		end
		if #sg==0 then return false end
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_DECK)>0 then
			Duel.ShuffleDeck(tp)
		end
		if og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_EXTRA)>0 then
			Duel.ShuffleExtra(tp)
		end
	end
end