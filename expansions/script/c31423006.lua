local m=31423006
local cm=_G["c"..m]
cm.name="世界之星鱼-新星鱼"
if not pcall(function() require("expansions/script/c31423000") end) then require("expansions/script/c31423000") end
function cm.initial_effect(c)
	Seine_space_ghoti.add_sp_proc(c,LOCATION_HAND+LOCATION_REMOVED)
	local e1=Effect.CreateEffect(c)
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
	return c:IsCode(Seine_space_ghoti.sfcode) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and not c:IsOriginalCodeRule(m)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if c then
		Duel.HintSelection(Group.FromCards(c))
		_G["c"..c:GetOriginalCodeRule()].op(e,tp,eg,ep,ev,re,r,rp)
	end
end