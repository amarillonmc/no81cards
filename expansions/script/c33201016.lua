--冥界的判官 阿努比斯
local s,id,o=GetID()
Duel.LoadScript("c33201010.lua")
function s.initial_effect(c)
	aux.AddCodeList(c,33201009)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),aux.NonTuner(Card.IsRace,RACE_ZOMBIE),1)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.sprcon)
	e0:SetOperation(s.sprop)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--MJspsm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(MJ_VHisc.sptg)
	e2:SetOperation(MJ_VHisc.spop)
	c:RegisterEffect(e2)
end

--special summon rule
function s.mnfilter(c,g)
	return g:IsExists(s.mnfilter2,1,c,c)
end
function s.mnfilter2(c,mc)
	return c:GetLevel()+mc:GetLevel()>=8
end
function s.fselect(g,tp,sc)
	return ((g:GetCount()==1 and g:GetFirst():GetLevel()>=8) or g:IsExists(s.mnfilter,1,nil,g)) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(MJ_VHisc.refilter1,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(s.fselect,1,99,tp,c)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(MJ_VHisc.refilter1,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tg=g:SelectSubGroup(tp,s.fselect,false,1,99,tp,c)
	Duel.Release(tg,REASON_COST)
end

function s.atkval(e,c)
	local rg=Duel.GetMatchingGroup(MJ_VHisc.refilter1,c:GetControler(),LOCATION_ONFIELD,0,nil)
	local lv=0
	for tc in aux.Next(rg) do
		lv=lv+tc:GetLevel()
	end
	return lv*100
end