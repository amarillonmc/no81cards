--空隙制压机 原始型号
local m=30008800
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.gapcon)
	e1:SetTarget(cm.gaptg)
	e1:SetOperation(cm.gapop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+m)
	e3:SetOperation(cm.oop)
	c:RegisterEffect(e3)
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_REMOVE)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCountLimit(1,m+m*2)
	e12:SetCondition(cm.grecon)
	e12:SetTarget(cm.gretg)
	e12:SetOperation(cm.greop)
	c:RegisterEffect(e12)
	cm.gap_machine_remove_effect=e12
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.ctfilter(c)
	return not c:IsType(TYPE_TOKEN) 
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.ctfilter,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(0,30008800,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,30008800,RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
end 
--Effect 1
function cm.gapcon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler()~=e:GetHandler() 
			and te:GetActivateLocation()==LOCATION_REMOVED 
			and Duel.IsChainNegatable(i) then
			return true
		end
	end
	return false
end
function cm.gaptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local spsum=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if chk==0 then return spsum end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler()~=c 
			and te:GetActivateLocation()==LOCATION_REMOVED 
			and Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsRelateToEffect(te) and tc:IsAbleToDeck() then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,#ng,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,#dg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.gapop(e,tp,eg,ep,ev,re,r,rp)
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler()~=c 
			and te:GetActivateLocation()==LOCATION_REMOVED 
			and Duel.NegateActivation(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) and tc:IsAbleToDeck() then
				dg:AddCard(tc)
			end
		end
	end
	if #ng==0 or #dg==0 or Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	local kg=Duel.GetOperatedGroup()
	if kg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--Effect 2
function cm.oop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.filter(c)
	return c:GetBaseDefense()==3333 and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Effect 3 
function cm.grecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)
end
function cm.gretg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp,30008800) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if chk==0 then return ct>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function cm.greop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,30008800) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if ct==0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tag=g:Select(tp,1,ct,nil)
	if #tag==0 then return false end
	local dct=Duel.SendtoDeck(tag,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local kg=Duel.GetOperatedGroup()
	if dct>0 and kg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,dct,nil)
		if #tg==0 then return false end
		Duel.BreakEffect()
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
