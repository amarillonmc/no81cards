--星海航线 启灵元神
function c11560706.initial_effect(c)
	c:SetUniqueOnField(1,0,11560706)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2) 
	c:EnableReviveLimit()  
	--damage 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11560706.dacon)
	e1:SetOperation(c11560706.daop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	local e3=e1:Clone() 
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
	--sequence 
	--local e4=Effect.CreateEffect(c) 
	--e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	--e4:SetCode(EVENT_PHASE+PHASE_STANDBY) 
	--e4:SetRange(LOCATION_MZONE) 
	--e4:SetCountLimit(1,11560706) 
	--e4:SetCost(c11560706.seqcost) 
	--e4:SetTarget(c11560706.seqtg) 
	--e4:SetOperation(c11560706.seqop)
	--c:RegisterEffect(e4) 
	--deck 
	--local e5=Effect.CreateEffect(c) 
	--e5:SetType(EFFECT_TYPE_IGNITION) 
	--e5:SetRange(LOCATION_MZONE) 
	--e5:SetCountLimit(1) 
	--e5:SetTarget(c11560706.dktg) 
	--e5:SetOperation(c11560706.dkop) 
	--c:RegisterEffect(e5) 
	--remove
	local e4=Effect.CreateEffect(c)  
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(1,11560706) 
	e4:SetTarget(c11560706.rmtg) 
	e4:SetOperation(c11560706.rmop) 
	c:RegisterEffect(e4) 
	--xx 
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PREDRAW)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,21560706) 
	e5:SetCondition(function(e) 
	return e:GetHandler():GetOverlayCount()>0 end) 
	e5:SetTarget(c11560706.xxtg)
	e5:SetOperation(c11560706.xxop)
	c:RegisterEffect(e5)
end
c11560706.SetCard_SR_Saier=true  
function c11560706.dacon(e,tp,eg,ep,ev,re,r,rp) 
	local x=0 
	local tc=eg:Filter(Card.IsSummonPlayer,nil,1-tp):GetFirst() 
	while tc do 
	if tc:IsLevelAbove(1) then 
	x=x+tc:GetLevel() 
	end  
	if tc:IsRankAbove(1) then 
	x=x+tc:GetRank()
	end  
	if tc:IsLinkAbove(1) then 
	x=x+tc:GetLink() 
	end 
	tc=eg:GetNext() 
	end 
	return x>0 
end 
function c11560706.daop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local x=0 
	local tc=eg:Filter(Card.IsSummonPlayer,nil,1-tp):GetFirst() 
	while tc do 
	if tc:IsLevelAbove(1) then 
	x=x+tc:GetLevel() 
	end  
	if tc:IsRankAbove(1) then 
	x=x+tc:GetRank()
	end  
	if tc:IsLinkAbove(1) then 
	x=x+tc:GetLink() 
	end 
	tc=eg:GetNext() 
	end  
	Duel.Hint(HINT_CARD,0,11560706) 
	Duel.Damage(1-tp,x*100,REASON_EFFECT) 
end 
function c11560706.seqcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end  
function c11560706.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local x=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND) 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_DECK,nil)
	if chk==0 then return g:GetCount()>=x end  
end 
function c11560706.seqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND) 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_DECK,nil) 
	if g:GetCount()>=x then 
	local dg=Duel.GetDecktopGroup(1-tp,x) 
		Duel.SortDecktop(1-tp,1-tp,x)
		for i=1,x do 
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end 
	end 
end 
function c11560706.dktg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,5,nil) end 
	Duel.SetChainLimit(c11560706.chlimit)
end
function c11560706.chlimit(e,ep,tp)
	return tp==ep
end 
function c11560706.dkop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	if not Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,5,nil) then return end 
	local dg=Duel.GetDecktopGroup(1-tp,5)
	Duel.ConfirmDecktop(1-tp,5) 
	local x=0 
	if dg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then x=x+1 end 
	if dg:IsExists(Card.IsType,1,nil,TYPE_SPELL) then x=x+1 end 
	if dg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then x=x+1 end 
	if x>=1 then  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(x-1) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	end 
	if x>=2 then 
		if Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) then 
		local dg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,x,nil) 
		local tc=dg:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Destroy(tc,REASON_EFFECT)
		tc=dg:GetNext()  
		end 
		end 
	end 
	if x>=3 then 
		Duel.DiscardHand(1-tp,Card.IsDiscardable,x,x,REASON_EFFECT,nil) 
	end 
end 
function c11560706.rmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)  
	if chk==0 then return x>=2 and Duel.IsPlayerCanRemove(tp) end 
	local z=2
	if x>=13 then z=3 end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,z,1-tp,LOCATION_EXTRA) 
end 
function c11560706.rmop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil,POS_FACEDOWN) 
	local x=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)  
	local z=2
	if x>=13 then z=3 end 
	if g:GetCount()>=z then 
		local rg=g:RandomSelect(tp,z) 
		if Duel.Remove(rg,0,REASON_EFFECT+REASON_TEMPORARY)>0 and rg:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED) 
			for tc in aux.Next(og) do
				tc:RegisterFlagEffect(11560706,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(og)
			e1:SetCountLimit(1)
			e1:SetCondition(c11560706.retcon)
			e1:SetOperation(c11560706.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end  
end 
function c11560706.retfilter(c)
	return c:GetFlagEffect(11560706)~=0
end
function c11560706.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(c11560706.retfilter,1,nil)
end
function c11560706.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c11560706.retfilter,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)  
end
function c11560706.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c11560706.xxop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local lp=Duel.GetLP(tp) 
	if lp>4000 then 
		if c:IsRelateToEffect(e) then 
			--cannot target
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(aux.tgoval) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			--indes
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
			e2:SetRange(LOCATION_MZONE)
			e2:SetValue(aux.indoval)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2) 
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
			e2:SetRange(LOCATION_MZONE)
			e2:SetValue(1) 
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2) 
		end 
	elseif lp<4000 then 
		Duel.Recover(tp,3000,REASON_EFFECT)  
	end 
end 



