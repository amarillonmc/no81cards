--星移斗转
--23.03.05
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ac=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		local bc=Duel.GetFieldCard(1-tp,LOCATION_FZONE,0)
		return (ac and (ac:IsStatus(STATUS_EFFECT_ENABLED) or ac:IsFacedown())) or (bc and (bc:IsStatus(STATUS_EFFECT_ENABLED) or bc:IsFacedown()))
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local bc=Duel.GetFieldCard(1-tp,LOCATION_FZONE,0)
	if (ac and not bc) or (bc and not ac) then
		if bc then ac=bc end
		if ac:IsStatus(STATUS_EFFECT_ENABLED) or ac:IsFacedown() then Duel.MoveToField(ac,tp,1-ac:GetControler(),LOCATION_FZONE,POS_FACEUP,true) end
	elseif ac and bc then
		local acs=ac:IsStatus(STATUS_EFFECT_ENABLED) or ac:IsFacedown()
		local bcs=bc:IsStatus(STATUS_EFFECT_ENABLED) or bc:IsFacedown()
		if (acs and not bcs) or (bcs and not acs) then
			if bcs then
				local tc=ac
				ac=bc
				bc=tc
			end
			Duel.SendtoGrave(bc,REASON_RULE)
			Duel.BreakEffect()
			Duel.MoveToField(ac,tp,1-ac:GetControler(),LOCATION_FZONE,ac:GetPosition(),true)
		elseif acs and bcs then
			local acpos=ac:GetPosition()
			local bcpos=ac:GetPosition()
			Duel.Overlay(ac,bc)
			Duel.MoveToField(ac,tp,1-ac:GetControler(),LOCATION_FZONE,acpos,true)
			Duel.MoveToField(bc,tp,1-ac:GetControler(),LOCATION_FZONE,bcpos,true)
		end
	end
end