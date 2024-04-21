local m=15005372
local cm=_G["c"..m]
cm.name="迷忆渊裔C729-归途的冻雨"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),3,2)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(cm.dircon)
	c:RegisterEffect(e1)
	--adjust
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(cm.adjustop)
	c:RegisterEffect(e5)
end
function cm.dircon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function cm.adfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()>1
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local sg=Group.CreateGroup()
	for p=0,1 do
		local g=Duel.GetMatchingGroup(cm.adfilter,p,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			if tc:GetOverlayCount()>1 then
				Duel.HintSelection(Group.FromCards(tc))
				sg:AddCard(tc)
			end
			while tc:GetOverlayCount()>1 do
				tc:RemoveOverlayCard(p,1,1,REASON_RULE)
			end
			tc=g:GetNext()
		end
	end
	if sg:GetCount()~=0 then
		Duel.Readjust()
	end
end