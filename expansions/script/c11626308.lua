--隐匿虫堆积的角落
function c11626308.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11626308)
	e1:SetOperation(c11626308.activate)
	c:RegisterEffect(e1) 
	--to deck 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)  
	e2:SetCountLimit(1,21626308) 
	e2:SetCondition(c11626308.tdcon)
	e2:SetTarget(c11626308.tdtg) 
	e2:SetOperation(c11626308.tdop) 
	c:RegisterEffect(e2) 
	--damage
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TODECK) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c11626308.drcon) 
	e3:SetTarget(c11626308.drtg) 
	e3:SetOperation(c11626308.drop) 
	c:RegisterEffect(e3)
	if not c11626308.global_check then
		c11626308.global_check=true
		local ge1=Effect.CreateEffect(c)
		c11626308[0]=0
		c11626308[1]=0
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(c11626308.addcount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c11626308.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end  
function c11626308.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x3220) then
			local p=tc:GetReasonPlayer()
			c11626308[p]=c11626308[p]+1
		end
		tc=eg:GetNext()
	end
end
function c11626308.clearop(e,tp,eg,ep,ev,re,r,rp)
	c11626308[0]=0
	c11626308[1]=0
end
--
function c11626308.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3220) and c:IsAbleToHand()
end
function c11626308.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11626308.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11626308,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end 
function c11626308.tdcon(e,tp,eg,ep,ev,re,r,rp) 
	local rc=re:GetHandler()
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and rc and rc:IsSetCard(0x3220)
end 
function c11626308.tdfil(c,rc) 
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3220) and not c:IsCode(rc:GetCode())  
end 
function c11626308.tdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local rc=re:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11626308.tdfil,tp,LOCATION_DECK,0,1,nil,rc) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK)
end 
function c11626308.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(c11626308.tdfil,tp,LOCATION_DECK,0,nil,rc) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,2,nil) 
	Duel.SendtoDeck(sg,1-tp,2,REASON_EFFECT)	 
	if sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)~=sg:GetCount() then return end 
		Duel.ShuffleDeck(1-tp) 
		local tc=sg:GetFirst()  
		while tc do 
		tc:ReverseInDeck()  
		tc=sg:GetNext()
		end   
	end 
end 
--
function c11626308.dackfil(c) 
	local re=c:GetReasonEffect() 
	return c:IsSetCard(0x3220) and c:IsReason(REASON_EFFECT) and re:IsActiveType(TYPE_MONSTER) 
end 

function c11626308.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c11626308[tp]>0
end

function c11626308.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return true end
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,nil,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c11626308.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,c11626308[tp],nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end