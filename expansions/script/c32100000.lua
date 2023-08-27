--驾驭贩卖号机械贩卖机模式
function c32100000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,32100000)
	e1:SetOperation(c32100000.activate)
	c:RegisterEffect(e1) 
	--xxx 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(32100000,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_FZONE)   
	e2:SetCost(c32100000.cost)
	e2:SetTarget(c32100000.xxtg1) 
	e2:SetOperation(c32100000.xxop1) 
	c:RegisterEffect(e2) 
	--
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(32100000,2)) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetCost(c32100000.cost)
	e2:SetTarget(c32100000.xxtg2) 
	e2:SetOperation(c32100000.xxop2) 
	c:RegisterEffect(e2) 
	--
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(32100000,3)) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetCost(c32100000.cost)
	e2:SetTarget(c32100000.xxtg3) 
	e2:SetOperation(c32100000.xxop3) 
	c:RegisterEffect(e2)   
	--to hand  
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING) 
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c32100000.hdcon)
	e3:SetTarget(c32100000.hdtg)
	e3:SetOperation(c32100000.hdop)
	c:RegisterEffect(e3)
end
function c32100000.thfilter(c)
	return c:IsCode(32100001) and c:IsAbleToHand()
end
function c32100000.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c32100000.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(32100000,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c32100000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsCode(32100001) and c:IsAbleToGraveAsCost() end,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(32100001) and c:IsAbleToGraveAsCost() end,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end  
function c32100000.xxtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,3,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end
function c32100000.xxop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,3,nil) then 
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,3,3,nil) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then 
			Duel.BreakEffect() 
			Duel.Draw(tp,1,REASON_EFFECT) 
		end 
	end 
end
function c32100000.pbfil(c) 
	if c:IsLocation(LOCATION_HAND) then 
	return not c:IsPublic() 
	else return c:IsFacedown() end 
end 
function c32100000.xxtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c32100000.pbfil,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)>0 end 
end
function c32100000.xxop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local hg=Duel.GetMatchingGroup(c32100000.pbfil,tp,0,LOCATION_HAND,nil)
	local fg=Duel.GetMatchingGroup(c32100000.pbfil,tp,0,LOCATION_ONFIELD,nil)
	local g
	if #hg>0 and (#fg==0 or Duel.SelectOption(tp,aux.Stringid(32100000,4),aux.Stringid(32100000,5))==0) then
		g=hg:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	if g:GetCount()~=0 then 
		Duel.ConfirmCards(tp,g) 
		if g:GetFirst():IsLocation(LOCATION_HAND) then 
			Duel.ShuffleHand(1-tp) 
		end 
	end
end
function c32100000.xxtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end  
end
function c32100000.xxop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(500) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1) 
		tc=g:GetNext() 
		end 
	end 
end
function c32100000.hdcon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=eg:GetFirst()
	return tc and tc:IsControler(tp) and eg:GetFirst():IsStatus(STATUS_OPPO_BATTLE) 
end
function c32100000.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32100000.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c32100000.hdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(c32100000.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then 
		local sg=Duel.SelectMatchingCard(tp,c32100000.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end 
end



