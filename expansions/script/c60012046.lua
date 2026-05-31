-- 土之法则·伽莱翁
--Duel.LoadScript("c.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--change name
	--aux.EnableChangeCode(c,60012048,LOCATION_SZONE)
  --aux.AddCodeList(c,60012048)

	c:EnableReviveLimit()
	--c:EnableCounterPermit(0x624)
	aux.AddLinkProcedure(c,cm.matfilter,1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_INITIAL)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(0xff)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.con2)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

end
function cm.matfilter(c)
	return c:GetCounter(0x624)>0 
end
function cm.con2(e,c)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)==0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,m,0,0,1)
	--Debug.Message("1")
	local allg=Duel.GetMatchingGroup(Card.IsType,tp,0x1ff,0x1ff,nil,TYPE_MONSTER)
	local allc=allg:GetFirst()
	--Debug.Message(#allg)
	for i=1,#allg do
		--special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(cm.spcon)
		e1:SetValue(cm.spval)
		allc:RegisterEffect(e1)
		allc=allg:GetNext()
	end
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)   
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsPlayerAffectedByEffect(tp,m) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(4)
end
function cm.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end