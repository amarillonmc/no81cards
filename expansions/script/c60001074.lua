--莜莱妮卡 守望之人
local m=60001074
local cm=_G["c"..m]

function cm.initial_effect(c)
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.splimit)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.con)
	e2:SetValue(cm.activeturnlimit)
	c:RegisterEffect(e2)
	--op
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCondition(cm.con)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCondition(cm.con)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)
	--end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.thcon)
	e5:SetOperation(cm.thop)
	c:RegisterEffect(e5)
end

function cm.con(e)
	return e:GetHandler():IsFaceup() and Duel.GetTurnPlayer()==1-e:GetHandlerPlayer()
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x62d)
end

function cm.activeturnlimit(e,re,tp)
	local rc=re:GetHandler()
	return not rc:IsSetCard(0x62d)
end

function cm.opnfilter(c)
	return c:IsDiscardable() and c:IsCode(24094653)
end

function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(ev) and rp==1-tp and Duel.IsExistingMatchingCard(cm.opnfilter,tp,LOCATION_HAND,0,1,nil)
	and e:GetHandler():GetFlagEffect(m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.DiscardHand(tp,cm.opnfilter,1,1,REASON_COST)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+EVENT_CHAIN_SOLVED,0,1)
	end
end

function cm.optfilter(c)
	return c:IsAbleToHand() and c:IsCode(24094653)
end

function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSummonLocation(LOCATION_DECK+LOCATION_HAND) and tc:GetSummonPlayer()==1-e:GetHandlerPlayer() and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil)
		and e:GetHandler():GetFlagEffect(600010740)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,nil)
			if g then 
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
			end
			e:GetHandler():RegisterFlagEffect(600010740,RESET_EVENT+EVENT_CHAIN_SOLVED,0,1)
		elseif tc:IsSummonLocation(LOCATION_GRAVE+LOCATION_REMOVED) and tc:GetSummonPlayer()==1-e:GetHandlerPlayer() and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil)
		and e:GetHandler():GetFlagEffect(600010741)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
			if g then 
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)  
			end
			e:GetHandler():RegisterFlagEffect(600010741,RESET_EVENT+EVENT_CHAIN_SOLVED,0,1)
		elseif tc:IsSummonLocation(LOCATION_EXTRA) and tc:GetSummonPlayer()==1-e:GetHandlerPlayer() and 
		Duel.IsExistingMatchingCard(cm.optfilter,tp,LOCATION_DECK,0,1,nil)
		and e:GetHandler():GetFlagEffect(600010742)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.optfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g then 
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-e:GetHandlerPlayer(),g)
			end
			e:GetHandler():RegisterFlagEffect(600010742,RESET_EVENT+EVENT_CHAIN_SOLVED,0,1)
		end
		tc=eg:GetNext()
	end
end

function cm.opdfilter(c)
	return c:IsDiscardable() and c:IsSetCard(0x62d)
end

function cm.optgfilter(c)
	return c:IsAbleToGrave() and c:IsSummonLocation(LOCATION_EXTRA) and c:IsSetCard(0x62d)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():GetFlagEffect(600010743)==0
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	local off=1
	local ops={}
	local opval={}
	if c:IsAbleToHand() then
		ops[off]=aux.Stringid(m,4)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.opdfilter,tp,LOCATION_HAND,0,3,nil) then
		ops[off]=aux.Stringid(m,5)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.optgfilter,tp,LOCATION_MZONE,0,1,nil) then
		ops[off]=aux.Stringid(m,6)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	c:RegisterFlagEffect(600010743,RESET_PHASE+PHASE_END,0,1)
	if opval[op]==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	elseif opval[op]==2 then
		Duel.DiscardHand(tp,cm.opdfilter,3,3,REASON_EFFECT,nil)
	elseif opval[op]==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.optgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end