--指挥官
function c25800010.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x211),2,63,false)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c25800010.hspcon)
	e1:SetOperation(c25800010.hspop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c25800010.descon)
	e2:SetOperation(c25800010.sucop)
	c:RegisterEffect(e2)

   local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25800010,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,25800010)
	e3:SetTarget(c25800010.sumtg)
	e3:SetOperation(c25800010.sumop)
	c:RegisterEffect(e3)
end 
function c25800010.hspfilter(c,tp,sc)
	return  c:IsSetCard(0x211) and c:IsControler(tp)  and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:  IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c25800010.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c25800010.hspfilter,2,nil,c:GetControler(),c)
end
function c25800010.hspop(e,tp,eg,ep,ev,re,r,rp,c)

	local g=Duel.SelectReleaseGroup(tp,c25800010.hspfilter,2,2,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
	
end
function c25800010.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c25800010.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(c:GetMaterialCount()*2-1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c25800010.filter(c,e,sp)

	return c:IsLevelBelow(e:GetHandler():GetLevel()) and c:IsCanBeSpecialSummoned(e,0,sp,false,false) and c:IsSetCard(0x211)
end
function c25800010.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25800010.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c25800010.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c25800010.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c25800010.splimit)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end
function c25800010.splimit(e,c)
	return not c:IsSetCard(0x211)
end

