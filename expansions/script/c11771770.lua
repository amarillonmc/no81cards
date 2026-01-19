--承继之灵契
-- c12345691.lua
local s,id,o=GetID()
function s.initial_effect(c)
	-- Effect 1: Search or Place & Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	-- Effect 2: Recycle & Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.drcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	
	-- Turn check for e2
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

-- Turn Check
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(id) then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
	end
end

-- Effect 1
function s.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() 
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,2,nil,c:GetAttribute())
end
function s.thfilter(c,att)
	return c:IsSetCard(0x6c74) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetAttribute()~=att
end
function s.pfilter(c)
	return c:IsSetCard(0x6c74) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,tp)
	local b2=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK,0,1,nil)
	
	if chk==0 then return b1 or b2 end
	
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)})
	e:SetLabel(op)
	
	if op==1 then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_DESTROY)
		-- Optional destroy, so no mandatory info here, maybe just generic
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
			local att=tc:GetAttribute()
			local sg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,att)
			if sg:GetCount()>=2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g1=sg:Select(tp,1,1,nil)
				sg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g2=sg:Select(tp,1,1,nil)
				g1:Merge(g2)
				Duel.SendtoHand(g1,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g1)
			end
		end
	else
		if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			local dg1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
			local dg2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
			if dg1:GetCount()>0 and dg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg1=dg1:Select(tp,1,1,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg2=dg2:Select(tp,1,1,nil)
				sg1:Merge(sg2)
				Duel.HintSelection(sg1)
				Duel.Destroy(sg1,REASON_EFFECT)
			end
		end
	end
end

-- Effect 2
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)==0
end
function s.drfilter(c)
	return (c:IsLevel(9) or c:IsRank(9)) and (c:IsAbleToDeck() or c:IsAbleToExtra()) and c:IsFaceupEx()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.drfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) 
		and Duel.IsExistingTarget(s.drfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.drfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then 
			if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
			Duel.BreakEffect()
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end
