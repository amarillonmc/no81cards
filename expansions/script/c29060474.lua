--无夜之城的月光
local cm,m,o=GetID()
cm.light_ark_chk=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
cm.kinkuaoi_Lightakm=true
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x87af) and p==tp and rp==1-tp
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainDisablable(i) then
			ng:AddCard(te:GetHandler())
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
end
function cm.opf1(c)
	return c:IsSetCard(0x87af) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) then
			Duel.NegateEffect(i)
		end
	end
	local g=Duel.GetMatchingGroup(cm.opf1,tp,LOCATION_DECK,0,nil)
	if #g==0 then return end 
	local op={aux.Stringid(m,0),aux.Stringid(m,1),g:IsExists(Card.IsAbleToHand,1,nil) and 1190 or nil}
	op=Duel.SelectOption(tp,table.unpack(op))
	if op==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	g=g:FilterSelect(tp,op==2 and Card.IsAbleToHand or aux.TRUE,1,1,nil):GetFirst()
	Duel.BreakEffect()
	if op==1 then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(g,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	else
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end