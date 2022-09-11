local m=31423005
local cm=_G["c"..m]
cm.name="远星之星鱼-恒星鱼"
if not pcall(function() require("expansions/script/c31423000") end) then require("expansions/script/c31423000") end
function cm.initial_effect(c)
	Seine_space_ghoti.add_sp_proc(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCondition(cm.con)
	e1:SetCost(Seine_space_ghoti.to_deck_cost())
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler())==0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	local count=1
	if num>=20 then count=count+1 end
	if num>=40 then count=count+1 end
	if num>=80 then count=count+1 end
	local dam=num*count*10
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local num=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	local count=1
	if num>=20 then count=count+1 end
	if num>=40 then count=count+1 end
	if num>=80 then count=count+1 end
	local dam=num*count*10
	Duel.Damage(p,dam,REASON_EFFECT)
end