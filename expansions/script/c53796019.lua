local m=53796019
local cm=_G["c"..m]
cm.name="恶魔的低语"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsPlayerCanDraw(tp,2)) or (Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(1-tp,2)) end
	Duel.SetTargetPlayer(Duel.GetTurnPlayer())
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,Duel.GetTurnPlayer(),2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local b1,b2=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)>0 and Duel.IsPlayerCanDraw(p,2),Duel.GetFieldGroupCount(p,0,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(1-p,2)
	if not b1 and not b2 then return end
	if b2 and (not b1 or Duel.SelectYesNo(p,aux.Stringid(m,0))) then p=1-p end
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	Duel.ConfirmCards(1-p,g)
	Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_ATOHAND)
	local sg=g:Select(1-p,1,1,nil)
	if Duel.SendtoHand(sg,1-p,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
