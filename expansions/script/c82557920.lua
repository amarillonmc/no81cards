--反旗钢战-ΞGUNDAM
function c82557920.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c82557920.psplimit)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82557920,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c82557920.ntcon)
	c:RegisterEffect(e2)
	--special summon2
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(82557920,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,82557920)
	e4:SetCondition(c82557920.pcon)
	e4:SetOperation(c82557920.pcop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(82557920,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,82557920)
	e3:SetTarget(c82557920.sptg)
	e3:SetOperation(c82557920.spop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c82557920.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_MACHINE) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82557920.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5)
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c82557920.filter2(c,e,tp)
	return c:IsRace(RACE_MACHINE)
		and c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_DECK))
end
function c82557920.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82557920.filter2,tp,LOCATION_DECK,0,1,nil) 
	   and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function c82557920.pcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c82557920.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
  end
end
function c82557920.filter(c,e,tp)
	return c:IsRace(RACE_MACHINE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsLocation(LOCATION_PZONE)
end
function c82557920.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82557920.filter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c82557920.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82557920.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end