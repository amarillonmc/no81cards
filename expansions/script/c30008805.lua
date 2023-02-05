--空隙制压机 STE-M3
local m=30008805
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
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+m)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	aux.RegisterMergedDelayedEvent(c,m,EVENT_SPSUMMON_SUCCESS)
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_REMOVE)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCountLimit(1,m+m*2)
	e12:SetCondition(cm.grecon)
	e12:SetTarget(cm.gretg)
	e12:SetOperation(cm.greop)
	c:RegisterEffect(e12)
	cm.gap_machine_remove_effect=e12
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
function cm.rmfilter(c,tp,e)
	return  c:IsLocation(LOCATION_MZONE) and c:IsSummonPlayer(1-tp)
		and c:IsAbleToRemove() and (not e or c:IsCanBeEffectTarget(e))
end
function cm.costfilter(c,g,tp)
	return  g:FilterCount(aux.TRUE,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=eg:Filter(cm.rmfilter,nil,tp,e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return e:IsCostChecked() and #g>0
		and Duel.CheckReleaseGroup(tp,cm.costfilter,1,c,g,tp) end
	local rg=Duel.SelectReleaseGroup(tp,cm.costfilter,1,1,c,g,tp)
	Duel.Release(rg,REASON_COST)
	local tg=g:Clone()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tg=g:Select(tp,1,1,nil)
	end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,#tg,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
--Effect 3 
function cm.grecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)
end
function cm.thf(c)
	return c:GetBaseDefense()==3333 and c:IsAbleToHand() 
end
function cm.gretg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thf,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.greop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thf),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


