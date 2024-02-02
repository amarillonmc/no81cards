--战车道装甲·谢尔曼
dofile("expansions/script/c9910100.lua")
function c9910129.initial_effect(c)
	--xyz summon
	QutryZcd.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4,2,c9910129.xyzfilter,99)
	c:EnableReviveLimit()
	--spsummon from ex
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910129,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9910129.spcost)
	e1:SetTarget(c9910129.sptg)
	e1:SetOperation(c9910129.spop)
	c:RegisterEffect(e1)
end
function c9910129.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9958) and c:IsFaceup()))
		and c:IsRace(RACE_MACHINE)
end
function c9910129.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910129.spfilter(c,e,tp)
	return c:IsRankBelow(4) and c:IsSetCard(0x9958) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910129.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910129.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910129.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910129.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9910129.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c9910129.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x9958)
end
