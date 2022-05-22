local m=15004006
local cm=_G["c"..m]
cm.name="恐吓爪牙族·深海恐惧兽"
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.hspcon)
	e1:SetValue(cm.hspval)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.deftg)
	e2:SetValue(cm.defval)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsSetCard(0x17a) and c:IsFaceup()
end
function cm.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		if seq==5 or seq==6 then
			zone=zone|(1<<aux.MZoneSequence(seq))
		else
			if seq>0 then zone=zone|(1<<(seq-1)) end
			if seq<4 then zone=zone|(1<<(seq+1)) end
		end
	end
	return zone
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=cm.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function cm.hspval(e,c)
	local tp=c:GetControler()
	return 0,cm.getzone(tp)
end
function cm.deftg(e,c)
	return c:IsSetCard(0x17a) and c:GetSequence()<5 and c:IsDefensePos()
end
function cm.defval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsDefensePos,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*300
end