local m=31423003
local cm=_G["c"..m]
cm.name="虹鳞之星鱼-彗星鱼"
if not pcall(function() require("expansions/script/c31423000") end) then require("expansions/script/c31423000") end
function cm.initial_effect(c)
	Seine_space_ghoti.add_sp_proc(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(Seine_space_ghoti.to_deck_cost())
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(e,c)
	return c:IsCode(Seine_space_ghoti.sfcode) or aux.IsCodeListed(c,Seine_space_ghoti.sfcode) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0)
	e1:SetTarget(cm.filter)
	e1:SetValue(cm.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end