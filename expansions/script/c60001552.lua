--超越次元
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
cm.isSpellboost=true
function cm.initial_effect(c)
	byd.Spellboost(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffect(60001538)
	if chk==0 then return ct>=18 and Duel.IsPlayerCanDraw(tp,5) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetHandler():GetFlagEffect(60001538)
	if ct<18 then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
	if #g>0 then Duel.SendtoDeck(g,nil,2,REASON_EFFECT) end
	if Duel.Draw(tp,5,REASON_EFFECT)>4 then
		--extra summon
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,0))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_EXTRA_SET_COUNT)
		Duel.RegisterEffect(e3)
	end
end