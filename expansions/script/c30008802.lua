--空隙制压机 STE-M2
local m=30008802
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
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+m)
	e3:SetTarget(cm.ttg)
	e3:SetOperation(cm.oop)
	c:RegisterEffect(e3)
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_DRAW)
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
function cm.filter(c)
	local b1=c:GetBaseDefense()==3333 and c:IsType(TYPE_MONSTER)
	local b2=c:IsCode(30008807,30008808,30008809)
	return c:IsAbleToGrave() and (b1 or b2)
end
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.oop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--Effect 3 
function cm.grecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)
end
function cm.gretg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.greop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

