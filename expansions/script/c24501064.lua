--神威骑士团先锋部队（未解限）
function c24501064.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
    -- 战吼特招
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(24501064,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,24501064)
	e1:SetTarget(c24501064.tg1)
	e1:SetOperation(c24501064.op1)
	c:RegisterEffect(e1)
    -- 发动无效
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(24501064,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,24501065)
	e2:SetCondition(c24501064.con2)
	e2:SetTarget(c24501064.tg2)
	e2:SetOperation(c24501064.op2)
	c:RegisterEffect(e2)
    -- 遗言特招
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24501064,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,24501066)
	e3:SetCondition(c24501064.con3)
	e3:SetTarget(c24501064.tg3)
	e3:SetOperation(c24501064.op3)
	c:RegisterEffect(e3)
end
-- 1
function c24501064.filter1(c,e,tp)
	return c:IsSetCard(0x501) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24501064.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c24501064.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c24501064.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c24501064.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 2
function c24501064.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x501) and c:IsType(TYPE_MONSTER)
end
function c24501064.con2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
    and Duel.IsExistingMatchingCard(c24501064.filter2,tp,LOCATION_MZONE,0,2,nil)
end
function c24501064.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c24501064.op2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) then
    end
end
-- 3
function c24501064.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c24501064.filter3(c,e,tp,lv)
    return c:IsSetCard(0x501) and not c:IsType(TYPE_SYNCHRO)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and (lv==nil or c:GetLevel()~=lv)
end
function c24501064.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c24501064.filter3,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c24501064.op3(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    local g=Duel.GetMatchingGroup(c24501064.filter3,tp,LOCATION_GRAVE,0,nil,e,tp)
    if #g<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg1=g:Select(tp,1,1,nil)
    local lv1=sg1:GetFirst():GetLevel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg2=g:FilterSelect(tp,c24501064.filter3,1,1,sg1:GetFirst(),e,tp,lv1)
    sg1:Merge(sg2)
    if #sg1==2 then
        Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
    end
end
