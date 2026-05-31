-- 大地之魔片
--Duel.LoadScript("c.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x62c,LOCATION_SZONE)
  aux.AddCodeList(c,60012048)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
end
function cm.afil(c)
	return c:IsCode(60012048) and c:IsFaceup()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cnum={}
	local dg=Duel.GetMatchingGroup(cm.afil,tp,LOCATION_SZONE,0,nil)
	for tc in aux.Next(dg) do
		local num=tc:GetCounter(0x62c)
		if num and num>0 then cnum[tc]=num else cnum[tc]=0 end
	end
	if Duel.SendtoGrave(dg,REASON_EFFECT)~=0 then
		local ug=Duel.GetOperatedGroup()
		if ug and #ug>0 then
			c:AddCounter(0x62c,#ug)
			local anum=0
			for tc in aux.Next(ug) do
				if cnum[tc]~=0 then anum=anum+cnum[tc] end
			end
			c:AddCounter(0x62c,anum)
		end
	end
end

