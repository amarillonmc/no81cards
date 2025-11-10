--真红眼流星钢龙
local s,id=GetID()
function s.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.hspcon)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,id+1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.has_text_type=TYPE_DUAL 
function s.hspfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3b) and c:IsAbleToRemoveAsCost()
		and Duel.GetMZoneCount(tp,c)>0
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.hspfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.hspfilter,tp,LOCATION_MZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b)
end
function s.spfilter(c,e,tp,chk)
	if not c:IsSetCard(0x3b) and not (chk and c:IsRace(RACE_DRAGON)) then return false end 
	return (c:IsType(TYPE_NORMAL) or c:IsType(TYPE_DUAL)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local check=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,c)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,0x13,0,1,nil,e,tp,check) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local check=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,0x13,0,1,1,nil,e,tp,check)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
