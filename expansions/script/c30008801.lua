--空隙制压机 STE-M1
local m=30008801
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
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m+m)
	e3:SetCondition(cm.ccon)
	e3:SetTarget(cm.ttg)
	e3:SetOperation(cm.oop)
	c:RegisterEffect(e3)
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
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
		Duel.RegisterFlagEffect(0,30008801,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,30008801,RESET_PHASE+PHASE_END,0,1)
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
function cm.ccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.oop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
--Effect 3 
function cm.grecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)
end
function cm.gretg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp,30008801) 
	local tg=Duel.GetDecktopGroup(1-tp,ct)
	if chk==0 then return ct>0 and tg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function cm.greop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,30008801)
	if ct>Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) then
		ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	end
	local tg=Duel.GetDecktopGroup(1-tp,ct)
	if ct==0 or tg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==0 then return end
	local num=ct
	local t={}
	for i=1,num do
		t[i]=i
	end
	local nct=Duel.AnnounceNumber(tp,table.unpack(t))
	local rg=Duel.GetDecktopGroup(1-tp,nct):Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
	if #rg==0 then return false end
	Duel.DisableShuffleCheck()
	if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND):Filter(Card.IsAbleToDeck,nil)
	if #hg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,hg)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local kg=hg:Select(tp,1,1,nil)
		Duel.SendtoDeck(kg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end

