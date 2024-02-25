--散华
function c11561016.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_HAND) 
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,11561016)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD) end) 
	e1:SetTarget(c11561016.xxtg) 
	e1:SetOperation(c11561016.xxop) 
	c:RegisterEffect(e1)
	if c11561016.counter==nil then
		c11561016.counter=true
		c11561016[0]=0
		c11561016[1]=0
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetOperation(c11561016.resetcount)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_CHAINING)
		e4:SetOperation(c11561016.checkop)
		Duel.RegisterEffect(e4,0)
	end  
end 
function c11561016.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c11561016[0]=0
	c11561016[1]=0
end
function c11561016.checkop(e,tp,eg,ep,ev,re,r,rp)
	c11561016[rp]=c11561016[rp]+1
end
function c11561016.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c11561016.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_PHASE+PHASE_END)  
	e2:SetCountLimit(1) 
	e2:SetOperation(c11561016.hxop) 
	e2:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e2,tp) 
end 
function c11561016.hxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local x=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) 
	local ct=c11561016[1-tp]
	if x==0 or ct<1 then return end
		Duel.Hint(HINT_CARD,0,11561016)
		if ct>x then ct=x end  
		local g=Duel.GetDecktopGroup(tp,ct)  
		Duel.ConfirmCards(tp,g) 
		if ct>4 then 
			local d=math.floor(ct/4)  
			local chk=0 
			local a=0 
			local msg=Group.CreateGroup()
			for i=1,d do 
				if chk==0 and g:IsExists(Card.IsAbleToHand,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11561016,0)) then  
					local sg=g:Filter(Card.IsAbleToHand,nil):Select(tp,1,1,nil)
					g:Sub(sg) 
					msg:Merge(sg) 
					a=a+1 
				else 
					chk=1 
				end 
			end 
			Duel.SendtoHand(msg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,msg)   
			if a>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,a,nil) then 
				Duel.BreakEffect() 
				local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,a,a,nil)
				local a1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
				local tc=g:GetFirst()
				while tc do
				Duel.MoveSequence(tc,SEQ_DECKTOP)
				tc=g:GetNext()
				end
				Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
				Duel.SortDecktop(tp,tp,ct)

				local g2=Duel.GetOperatedGroup()
				local a2=Group.GetCount(g2) 
				if not (a2<math.floor(a1/2)) then 
					Duel.Draw(tp,1,REASON_EFFECT) end
			end 
		end 
end 
 









