--虫群主宰
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,s.ffilter1,s.ffilter2,1,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_COST):SetCountLimit(1,id)
	c:SetUniqueOnField(1,0,id)
	aux.AddCodeList(c,id,65814165,65814170)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(s.efilter)
	c:RegisterEffect(e0)
	--untargetable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function s.ffilter1(c,fc,sub,mg,sg)
	return c:IsFusionCode(65814165)
end
function s.ffilter2(c,fc,sub,mg,sg)
	return c:IsFusionCode(65814170)
end


function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(10) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_FUSION) and c:IsType(TYPE_FLIP) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,true,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	local pos=POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE
	if not tc:CheckUniqueOnField(tp) then pos=POS_FACEDOWN_DEFENSE end
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,true,pos)>0 then
		tc:CompleteProcedure()
		if tc:IsPosition(POS_FACEDOWN) then Duel.ConfirmCards(1-tp,tc) end
	end
end