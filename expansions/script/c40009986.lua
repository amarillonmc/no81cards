--兽神争斗
local m=40009986
local cm=_G["c"..m]
cm.named_with_BeastDeity=1
function cm.BeastDeity(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BeastDeity
end

function cm.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--overlay
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.ovltg)
	e4:SetOperation(cm.ovlop)
	c:RegisterEffect(e4)
	
end
function cm.tdfilter(c)
	return cm.BeastDeity(c) and c:IsType(TYPE_MONSTER) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) 
end
function cm.ovltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil)and Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.ovlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.IsPlayerCanDiscardDeck(tp,1) then
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local gc=g:GetFirst()
		if cm.BeastDeity(gc) then
			Duel.DisableShuffleCheck()
			Duel.Overlay(tc,Group.FromCards(gc))
			Duel.RaiseEvent(gc,EVENT_CUSTOM+40009964,e,REASON_REVEAL,0,tp,0)
		else
			Duel.MoveSequence(gc,1)
		end
	end
end
