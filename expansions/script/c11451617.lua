--幽玄龙象※艮依行止
--21.09.21
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	cm.hand_effect=cm.hand_effect or {}
	cm.hand_effect[c]=e1
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3978) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if Duel.IsPlayerCanDiscardDeck(tp,1) and dc>0 then
		local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if dc>ct then dc=ct end
		Duel.ConfirmDecktop(tp,dc)
		local g=Duel.GetDecktopGroup(tp,dc)
		if #g>0 then
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
			end
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #cg>0 end
end
local _IsCanChangePosition=Card.IsCanChangePosition
function Card.IsCanChangePosition(c)
	return _IsCanChangePosition(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.ChangePosition(cg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	if ct>0 and c:IsRelateToEffect(e) and c:GetColumnGroupCount()==0 and Duel.IsPlayerCanDraw(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local ct2=Duel.Draw(tp,ct,REASON_EFFECT)
		if ct2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,ct2,ct2,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end