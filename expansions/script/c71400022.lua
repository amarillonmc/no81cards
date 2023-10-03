--异梦眼药商人
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400022.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,yume.YumeLMGFilterFunction(c))
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,71400022)
	e1:SetCondition(c71400022.con1)
	e1:SetTarget(c71400022.tg1)
	e1:SetOperation(c71400022.op1)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400022,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c71400022.con2)
	e2:SetOperation(c71400022.op2)
	c:RegisterEffect(e2)
end
function c71400022.filter1c(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c71400022.filter1(c,e,tp,zone)
	return c:IsSetCard(0x714) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c71400022.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c71400022.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return Duel.IsExistingMatchingCard(c71400022.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c71400022.op1(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400022.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c71400022.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY)
		and (c:IsReason(REASON_BATTLE) and Duel.GetAttacker()~=c or c:IsReason(REASON_EFFECT))
end
function c71400022.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,rp)
end