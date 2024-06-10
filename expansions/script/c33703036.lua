--期待
local m=33703036
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1010)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.acttarget)
	e1:SetOperation(cm.actop)
	c:RegisterEffect(e1)
	--special counter permit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_COUNTER_PERMIT+0x1010)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(cm.ctpermit)
	c:RegisterEffect(e2)
	--remove counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.addc)
	c:RegisterEffect(e3)
	--to grave and tohand 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+m)
	--e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.tghcon)
	e4:SetTarget(cm.tghtg) 
	e4:SetOperation(cm.tghop)
	c:RegisterEffect(e4)
	
end


function cm.tghfilter(c)
	return c:IsLocation(LOCATION_DECKBOT)
end
function cm.tghcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tghfilter,tp,LOCATION_DECK,0,nil)
	local sc=g:GetFirst()
	return (e:GetHandler():GetCounter(0x1010)==0) and sc:IsAbleToHand()
end
function cm.tghtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.tghfilter,tp,LOCATION_DECK,0,nil)
	local sc=g:GetFirst()
	if chk ==0 then return Card.IsAbleToHand(sc) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.tghop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tghfilter,tp,LOCATION_DECK,0,nil)
	local sg=Duel.GetMatchingGroup(cm.tghfilter,1-tp,LOCATION_DECK,0,nil)
	local sc=g:GetFirst() 
	local kc=sg:GetFirst()
	if sc:IsAbleToHand() then
		
		 if sc:IsAbleToHand() then
		 Duel.SendtoHand(sc,tp,REASON_EFFECT)
		 Duel.SendtoHand(kc,1-tp,REASON_EFFECT)
		 end
		  Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
function cm.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetCounter(0x1010) == 0  then
		return
	end
	Duel.RemoveCounter(tp,1,0,0x1010,1,REASON_EFFECT)
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) and Duel.CheckLPCost(tp,1000,true)  then 
		local ct=math.floor(Duel.GetLP(tp)/1000)
		local temp=nil
		if ct>e:GetHandler():GetCounter(0x1010) then
			ct =e:GetHandler():GetCounter(0x1010)
		else
			ct =ct-1
		end
		local t={}
		for i=1,ct do
			t[i]=i*1000
		end
		local cost=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.PayLPCost(tp,cost,true)
		local k =math.floor(cost/1000)
		e:GetHandler():RemoveCounter(tp,0x1010,k,REASON_EFFECT)
		
	end
end
function cm.acttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x1010,5,c) end
	c:AddCounter(0x1010,5)
end
function cm.actfilter(c)
	return c:IsAbleToDeck()
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		local c=g:GetFirst()
		if g:GetCount()~=0 and  c:IsAbleToDeck() then
			Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		end
	end
		if not cm.global_check then
		cm.global_check=true
 	   local e1=Effect.CreateEffect(e:GetHandler())
  	 	 e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  	 	 e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_SZONE)
 	  	 e1:SetOperation(cm.adjustop)
	e:GetHandler():RegisterEffect(e1)
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	if e:GetHandler():GetCounter(0x1010)==0 then
		Duel.RaiseEvent(g,EVENT_CUSTOM+m,re,r,rp,ep,e:GetLabel())

	end
end
function cm.ctpermit(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:IsStatus(STATUS_CHAINING)
end