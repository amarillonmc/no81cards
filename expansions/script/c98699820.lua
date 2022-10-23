local m=98699820
local cm=_G["c"..m]
cm.name="标志灵的街道"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.rmcon)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,1,REASON_EFFECT)==1 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsSetCard(0x876) and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp) and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,0,1,c,c:GetOriginalCodeRule())
end
function cm.thfilter(c,code)
	return not c:IsOriginalCodeRule(code) and c:IsAbleToHand()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,e,tp)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and cm.filter(chkc,e,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=eg:FilterSelect(tp,cm.filter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,1,nil,tc:GetOriginalCodeRule())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return false end
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:GetFirst():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_DECK)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=0 then return end
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_REMOVED) then return end
	if not tc:IsSetCard(0x876) and tc:IsType(TYPE_SPELL+TYPE_TRAP) then return end
	local te=tc:CheckActivateEffect(false,false,false)
	if not te or not te:IsActivatable(tp) or not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
	local cost=te:GetCost()
	local target=te:GetTarget()
	local operation=te:GetOperation()
	Duel.ClearTargetCard()
	Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
	tc:CreateEffectRelation(te)
	if not tc:IsType(TYPE_FIELD+TYPE_CONTINUOUS+TYPE_EQUIP) and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then tc:CancelToGrave(false) end
	if cost then cost(te,tp,eg,ep,ev,re,r,rp,1) end
	if target then target(te,tp,eg,ep,ev,re,r,rp,1) end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then for tg in aux.Next(g) do tg:CreateEffectRelation(te) end end
	tc:SetStatus(STATUS_ACTIVATED,true)
	if operation then operation(te,tp,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	if g then for tg in aux.Next(g) do tg:ReleaseEffectRelation(te) end end
	Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
	if tc:IsType(TYPE_FIELD) then Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain()) end
end
