--also sprach zarathusnya
--21.12.25
local m=11451652
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	--[[local t=debug.getregistry()
	for _,v in pairs(t) do
		if aux.GetValueType(v)=="Effect" and v:GetHandler():IsOriginalCodeRule(ac) and v:GetType()&EFFECT_TYPE_IGNITION>0 and v:GetHandler():GetOriginalType()&TYPE_MONSTER>0 then
			v:SetType(EFFECT_TYPE_QUICK_O)
			v:SetCode(EVENT_FREE_CHAIN)
			local pro,pro2=v:GetProperty()
			pro=pro|EFFECT_FLAG_CANNOT_DISABLE
			pro=pro|EFFECT_FLAG_CANNOT_INACTIVATE
			v:SetProperty(pro,pro2)
		end
	end--]]
	local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,ac)
	local reg=Card.RegisterEffect
	Card.RegisterEffect=function(sc,se,bool)
							if se:GetType()&EFFECT_TYPE_IGNITION>0 and sc:GetOriginalType()&TYPE_MONSTER>0 then
								se:SetType(EFFECT_TYPE_QUICK_O)
								se:SetCode(EVENT_FREE_CHAIN)
								local pro,pro2=se:GetProperty()
								pro=pro|EFFECT_FLAG_CANNOT_DISABLE
								pro=pro|EFFECT_FLAG_CANNOT_INACTIVATE
								se:SetProperty(pro,pro2)
							end
							reg(sc,se,bool)
						end
	for tc in aux.Next(g) do
		if tc.initial_effect and tc:GetOriginalType()&TYPE_NORMAL==0 then
			tc:ReplaceEffect(tc:GetOriginalCode(),0)
		elseif tc.initial_effect then
			local ini=cm.initial_effect
			cm.initial_effect=function() end
			tc:ReplaceEffect(m,0)
			cm.initial_effect=ini
			tc.initial_effect(tc)
		end
	end
	Card.RegisterEffect=reg
end