local m=31423007
local cm=_G["c"..m]
cm.name="摇荡之星鱼-波星鱼"
if not pcall(function() require("expansions/script/c31423000") end) then require("expansions/script/c31423000") end
function cm.initial_effect(c)
	Seine_space_ghoti.add_sp_proc(c,LOCATION_HAND+LOCATION_REMOVED)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e1:SetCondition(cm.con)
	e1:SetCost(Seine_space_ghoti.to_deck_cost())
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler())==0
end
function cm.filter(c)
	return c:IsAbleToDeck() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end