--绝望沉沦
local m=30005310
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.negcon)
	e4:SetOperation(cm.negop)
	c:RegisterEffect(e4)
	--Effect 2  
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(m,2))
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_CHAIN_SOLVING)
	e14:SetRange(LOCATION_SZONE)
	e14:SetCondition(cm.ngcon)
	e14:SetOperation(cm.ngop)
	c:RegisterEffect(e14)
	--Effect 3 
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e1:SetRange(LOCATION_SZONE)
	--e1:SetCode(EFFECT_SELF_DESTROY)
	--e1:SetCondition(cm.sdcon)
	--c:RegisterEffect(e1)
	--Effect 4  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.dctg)
	e2:SetOperation(cm.dcop)
	c:RegisterEffect(e2) 
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(cm.leop)
		Duel.RegisterEffect(ge1,0)
		local ge11=Effect.CreateEffect(c)
		ge11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge11:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge11:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge11,0)
	end
end
--all
function cm.leop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetPreviousLocation()==LOCATION_ONFIELD and (c:GetPreviousTypeOnField()&TYPE_SPELL~=0 or c:GetPreviousTypeOnField()&TYPE_TRAP~=0) and tc:GetLocation()~=LOCATION_SZONE then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
		end
		tc=eg:GetNext()
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m+200,RESET_PHASE+PHASE_END,0,2)
		tc=eg:GetNext()
	end
end
--Effect 1
function cm.nbcon(tp,re,ze)
	local rc=re:GetHandler()
	return Duel.IsPlayerCanRemove(tp)
		and (ze~=rc:GetLocation() or rc:IsAbleToRemove(tp,POS_FACEDOWN))
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ze=re:GetActivateLocation()
	local b1= (ze==LOCATION_GRAVE or ze==LOCATION_REMOVED) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
	local b2= rc:GetFlagEffect(m)>0 and ze~=LOCATION_DECK 
	return (b1 or b2) and Duel.IsChainDisablable(ev) 
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev,true) and rc:IsRelateToEffect(re) and rc:IsAbleToRemove(tp,POS_FACEDOWN) then
		Duel.BreakEffect()
		if Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if #og==0 then return false end
		for tc in aux.Next(og) do  
			tc:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		end  
	end
end
--Effect 2
function cm.ttf(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.rsf(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.ngcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and #tg>0 and tg:IsExists(cm.ttf,1,nil) 
end
function cm.ngop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(cm.rsf,nil,tp)
	if #rg==0 then return end
	if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	if #og==0 then return false end
	for tc in aux.Next(og) do  
		tc:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end  
end
--Effect 3 
function cm.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(e:GetHandlerPlayer(),m+200)
	return ct>3
end
--Effect 4 
function cm.kf(c) 
	local se=c:GetReasonEffect()
	local b1=c:GetFlagEffect(m+100)>0
	return b1 or (se and se~=nil and se:GetHandler():GetCode()==m)
end 
function cm.df(c) 
	return cm.kf(c) and c:IsAbleToDeck()
end 
function cm.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.kf,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function cm.dcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.df,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if #g==0 then return end
	local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if ct==0 then return false end
	local cct=math.floor(ct/3)
	if cct==0 or not Duel.IsPlayerCanDraw(tp,cct) or not Duel.IsPlayerCanDraw(1-tp,cct) then return false end
	Duel.BreakEffect()
	Duel.Draw(tp,cct,REASON_EFFECT)
	Duel.Draw(1-tp,cct,REASON_EFFECT)
end
 