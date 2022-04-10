--筒曲视界
local m=33330173
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	c:RegisterEffect(e3)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
end
function cm.discheck(i,j)
	return Duel.CheckLocation(j,LOCATION_MZONE,i)
end
function cm.condition(e,tp)
	local flag=false
	for i=0,4 do
		for j=0,1 do
			if cm.discheck(i,j) then
				flag=true
			end
		end
	end
	return flag
end
function cm.get(c,e)
	return not c:IsImmuneToEffect(e) and c:GetSequence()<=4
end
function cm.op(e,tp)
	local g=Duel.GetMatchingGroup(cm.get,tp,LOCATION_MZONE,0,nil,e)
	local num1=g:GetCount()
	local g2=Duel.GetMatchingGroup(cm.get,1-tp,LOCATION_MZONE,0,nil,e)
	local num2=g2:GetCount()
	local rsg=Group.CreateGroup()
	for i=1,num1 do
		local sg=g:Clone()
		for tc in aux.Next(sg) do
			local seq=tc:GetSequence()
			if seq==4 and Duel.CheckLocation(tp,LOCATION_MZONE,0) then
				Duel.MoveSequence(tc,0)
				g:RemoveCard(tc)
			elseif seq~=4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then
				Duel.MoveSequence(tc,seq+1)
				g:RemoveCard(tc)
			end
		end
	end
	for i=1,num2 do
		local sg2=g2:Clone()
		for tc in aux.Next(sg2) do
			local seq=tc:GetSequence()
			if seq==4 and Duel.CheckLocation(1-tp,LOCATION_MZONE,0) then
				Duel.MoveSequence(tc,0)
				g2:RemoveCard(tc)
			elseif seq~=4 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq+1) then
				Duel.MoveSequence(tc,seq+1)
				g2:RemoveCard(tc)
			end
		end
	end
end