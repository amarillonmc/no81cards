local m=53729016
local cm=_G["c"..m]
cm.name="晶栖秘所"
cm.upside_code=m
cm.downside_code=m+1
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PYRO))
	e2:SetValue(cm.sumval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(cm.con)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.sumval(e,c)
	local tp=e:GetHandler():GetControler()
	local sumzone=Duel.GetLinkedZone(tp)
	local s=0
	local g=Duel.GetMatchingGroup(function(c,tp)return c:GetLinkedZone(tp)~=0 end,tp,LOCATION_ONFIELD,0,nil,tp)
	for tc in aux.Next(g) do s=s|tc:GetSequence() end
	local relzone=-bit.lshift(1,s)
	return 0,sumzone,relzone
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalCode()==m and Duel.IsExistingMatchingCard(function(c)return c:IsSetCard(0x5533) and c:IsType(TYPE_FUSION)end,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.downside_code
	Duel.Hint(HINT_CARD,0,m)	
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	Duel.Hint(HINT_CARD,0,tcode)
	Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
end
