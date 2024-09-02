function c10111118.initial_effect(c)
	c:SetUniqueOnField(1,0,10111118)
	c:EnableReviveLimit()
	--fusion summon
	aux.AddFusionProcFunRep(c,c10111118.ffilter,2,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10111118.splimit)
	c:RegisterEffect(e1)
     --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111118,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10111118)
	e2:SetCondition(c10111118.spcon)
	e2:SetTarget(c10111118.sptg2)
	e2:SetOperation(c10111118.spop2)
	c:RegisterEffect(e2)
     --攻守变化
   	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c10111118.indcon)
	e3:SetValue(700)
	c:RegisterEffect(e3)
    local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function c10111118.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x2b) and (not sg or not sg:IsExists(Card.IsRace,1,c,c:GetRace()))
end
function c10111118.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c10111118.spcfilter(c)
	return c:IsCode(10111119) and c:IsFaceup()
end
function c10111118.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c10111118.spcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10111118.spfilter1(c,e,tp,sc)
	return c:IsCode(10111119) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0
end
function c10111118.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and (e:IsCostChecked() or Duel.IsExistingMatchingCard(c10111118.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10111118.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10111118.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil):GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
function c10111118.indcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end