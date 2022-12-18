local m=53750015
local cm=_G["c"..m]
cm.name="奏响异律之森"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end
function cm.filter(c,tp)
	return c:IsPreviousControler(tp) and c:IsSetCard(0x9532) and c:GetType() and c:IsReason(REASON_COST) and c:GetActivateEffect() and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(cm.filter,nil,tp)
	local cd,ch=0,Duel.GetCurrentChain()
	if #g==0 or ch==0 then return end
	if c:GetFlagEffect(m)==0 then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) end
	for tc in aux.Next(g) do
		local le={tc:GetActivateEffect()}
		local ct=#le
		for i,te in pairs(le) do
			local e1=Effect.CreateEffect(c)
			if ct==1 then e1:SetDescription(aux.Stringid(m,0)) else e1:SetDescription(te:GetDescription()) end
			e1:SetCategory(te:GetCategory())
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_SZONE)
			e1:SetProperty(te:GetProperty())
			e1:SetLabel((1<<ch)|(1<<(cd+16)))
			e1:SetLabelObject(tc)
			e1:SetValue(i)
			e1:SetTarget(cm.spelltg)
			e1:SetOperation(cm.spellop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			c:RegisterEffect(e1)
		end
		cd=cd+1
	end
end
function cm.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local ftg=ae:GetTarget()
	local flag=e:GetHandler():GetFlagEffectLabel(m)
	if chk==0 then
		e:SetCostCheck(false)
		return (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)) and bit.band(flag,e:GetLabel())~=e:GetLabel()
	end
	e:GetHandler():SetFlagEffectLabel(m,flag|e:GetLabel())
	if ftg then
		e:SetCostCheck(false)
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.tdfilter(c)
	return (c:IsRace(RACE_REPTILE) and c:IsLevel(8)) or (c:IsType(TYPE_SPELL) and c:IsSetCard(0x9532))
end
function cm.spellop(e,tp,eg,ep,ev,re,r,rp)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	ops[off]=aux.Stringid(m,2)
	opval[off-1]=0
	off=off+1
	if Duel.IsPlayerCanDraw(tp,1) then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsPlayerCanDiscardDeck(tp,2) then
		ops[off]=aux.Stringid(m,4)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 then
		ops[off]=aux.Stringid(m,5)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif opval[op]==2 then
		Duel.BreakEffect()
		Duel.DiscardDeck(p,d,REASON_EFFECT)
	elseif opval[op]==3 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,6))
		local tc=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:IsPreviousControler(c:GetOwner()) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end
function cm.filter1(c)
	return c:IsRace(RACE_REPTILE) and c:IsAbleToHand()
end
function cm.filter2(c)
	return c:IsSetCard(0x9532) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
	g:Merge(g2)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
