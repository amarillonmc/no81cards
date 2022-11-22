local m=53707016
local cm=_G["c"..m]
cm.name="清响 抄染扉"
cm.main_peacecho=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.Peacecho(c,TYPE_MONSTER)
	SNNM.AllGlobalCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCost(cm.negcost)
	e4:SetOperation(cm.negop)
	c:RegisterEffect(e4)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=math.min(Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_DECK,0,nil),6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0))
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,ct)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=math.min(Duel.GetMatchingGroupCount(Card.IsFaceup,p,LOCATION_DECK,0,nil),6-Duel.GetFieldGroupCount(p,LOCATION_HAND,0))
	if ct>0 and Duel.Draw(p,ct,REASON_EFFECT)==ct then
		local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if tg:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=tg:Select(p,ct,ct,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function cm.dcfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.dcfilter,tp,LOCATION_DECK,0,1,nil) end
	SNNM.UpConfirm(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.dcfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
