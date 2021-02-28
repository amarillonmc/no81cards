--The Pale King
local m=115010
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,15000351,15000348)
	c:SetUniqueOnField(1,1,m)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsCode,15000351),nil,nil,cm.matfilter1,2,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.aclimit1)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon2)
	e2:SetOperation(cm.spop2)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCondition(cm.spcon3)
	e5:SetOperation(cm.spop3)
	c:RegisterEffect(e5)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(cm.sumtg)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetTarget(cm.immtg)
	c:RegisterEffect(e4)
end
function cm.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) 
end
function cm.sprfilter0(c,tp)
	return c:IsFaceup() and c:IsCode(15000351) 
		and Duel.IsExistingMatchingCard(cm.sprfilter1,tp,LOCATION_MZONE,0,1,c,tp,c:GetLevel()) 
end
function cm.sprfilter1(c,tp,lv)
	return c:IsFaceup() and c:IsSynchroType(TYPE_TUNER) 
		and Duel.IsExistingMatchingCard(cm.sprfilter2,tp,LOCATION_MZONE,0,1,c,lv+c:GetLevel()) 
end
function cm.sprfilter2(c,lv)
	return c:IsFaceup() and lv+1==12 
	and not c:IsLevelAbove(1) and c:IsRace(RACE_INSECT)
end
function cm.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(cm.sprfilter0,tp,LOCATION_MZONE,0,1,nil,tp)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,cm.sprfilter0,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,cm.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,g1:GetFirst():GetLevel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g3=Duel.SelectMatchingCard(tp,cm.sprfilter2,tp,LOCATION_MZONE,0,1,1,nil,g1:GetFirst():GetLevel()+g2:GetFirst():GetLevel())
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SendtoGrave(g1,REASON_COST)
	e:GetHandler():SetMaterial(g1)
end
----
function cm.sprfilter00(c,tp)
	return c:IsFaceup() and c:IsCode(15000351) and c:IsLevel(10)
		and Duel.IsExistingMatchingCard(cm.sprfilter11,tp,LOCATION_MZONE,0,2,c) 
end
function cm.sprfilter11(c)
	return c:IsFaceup()
	and not c:IsLevelAbove(1) and c:IsRace(RACE_INSECT)
end
function cm.spcon3(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(cm.sprfilter00,tp,LOCATION_MZONE,0,1,nil,tp)
end
function cm.spop3(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,cm.sprfilter00,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,cm.sprfilter11,tp,LOCATION_MZONE,0,2,2,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
	e:GetHandler():SetMaterial(g1)
end
----
function cm.aclimit1(e,re,tp)
	return re:GetHandler():IsCode(15000348) or re:GetHandler():IsCodeListed(15000348)
end
function cm.sumtg(e,c)
	return aux.IsCodeListed(c,15000348) or c:IsCode(15000348)
end
function cm.immtg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end