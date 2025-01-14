--预设剧本
local m=13255408
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.filter(c,eg,ep,ev,re,r,rp)
	local te=tama.getTargetTable(c,"theme_effect")
	return PCe and cm.canActivate(c,te,eg,ep,ev,re,r,rp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return tama.getTheme(tp)==0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,eg,ep,ev,re,r,rp) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if tama.getTheme(tp)~=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te=tama.getTargetTable(tc,"theme_effect")
	if te and cm.canActivate(tc,te,eg,ep,ev,re,r,rp) then
		local target=te:GetTarget()
		local operation=te:GetOperation()
		e:SetProperty(te:GetProperty())
		tc:CreateEffectRelation(te)
		if target then target(te,tp,eg,ep,ev,re,r,rp,1) end
		if operation then operation(te,tp,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
	end
end
