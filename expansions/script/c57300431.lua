--pvz bt z 黑暗骑士僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetTarget(s.sprtg)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc520))
	e3:SetValue(300)
	c:RegisterEffect(e3)
	Zombie_Characteristics_X(c)
end
function s.sprfilter(c)
	return c:IsFaceupEx() and c:IsAbleToRemoveAsCost()
end
function s.filter1(c,g)
	return c:IsCode(57300403) and g:IsExists(s.filter2,1,c,g,c)
end
function s.filter2(c,g,ec)
	return c:IsSetCard(0x5521) and g:IsExists(s.filter3,1,Group.FromCards(c,ec),g,c:GetCode())
end
function s.filter3(c,g,code)
	return c:IsSetCard(0x5521) and not c:IsCode(code)
end
function s.fselect(g,tp,sc)
	return g:IsExists(s.filter1,1,nil,g) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:CheckSubGroup(s.fselect,3,3,tp,c)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,s.fselect,true,3,3,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON+REASON_COST)
	g:DeleteGroup()
end