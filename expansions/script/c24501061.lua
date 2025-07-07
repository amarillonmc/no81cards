--神威骑士团增援部队（未解限）
function c24501061.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(24501061,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c24501061.con0)
	e0:SetTarget(c24501061.tg0)
	e0:SetOperation(c24501061.op0)
	c:RegisterEffect(e0)
    -- 战吼检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24501061,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,24501061)
	e1:SetTarget(c24501061.tg1)
	e1:SetOperation(c24501061.op1)
	c:RegisterEffect(e1)
    -- 特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24501061,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,24501062)
	e2:SetCondition(c24501061.con2)
	e2:SetCost(c24501061.cost2)
	e2:SetTarget(c24501061.tg2)
	e2:SetOperation(c24501061.op2)
	c:RegisterEffect(e2)
    -- 遗言特招
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24501061,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,24501063)
	e3:SetCondition(c24501061.con3)
	e3:SetTarget(c24501061.tg3)
	e3:SetOperation(c24501061.op3)
	c:RegisterEffect(e3)
end
-- 特殊召唤条件
function c24501061.filter0(c)
    return c:IsFaceup() and c:IsSetCard(0x501) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c24501061.fselect(g,c,tp)
    return g:GetClassCount(Card.GetLevel)==1 and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function c24501061.con0(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c24501061.filter0,tp,LOCATION_MZONE,0,nil)
    return g:CheckSubGroup(c24501061.fselect,2,2,c,tp)
end
function c24501061.tg0(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local g=Duel.GetMatchingGroup(c24501061.filter0,tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local sg=g:SelectSubGroup(tp,c24501061.fselect,true,2,2,c,tp)
    if sg then
        sg:KeepAlive()
        e:SetLabelObject(sg)
        return true
    else return false end
end
function c24501061.op0(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    Duel.SendtoGrave(g,REASON_SPSUMMON)
    g:DeleteGroup()
end
-- 1
function c24501061.filter1(c)
	return c:IsSetCard(0x501) and c:IsAbleToHand()
end
function c24501061.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501061.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c24501061.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c24501061.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- 2
function c24501061.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c24501061.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c24501061.filter2(c,e,tp)
    return c:IsSetCard(0x501) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c24501061.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c24501061.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c24501061.gcheck(g)
    local codes={}
    for c in aux.Next(g) do
        if codes[c:GetCode()] then return false end
        codes[c:GetCode()]=true
    end
    return true
end
function c24501061.op2(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    local ct=math.min(ft,2)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c24501061.filter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=g:SelectSubGroup(tp,c24501061.gcheck,false,1,ct)
    if sg and sg:GetCount()>0 then
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
end
-- 3
function c24501061.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c24501061.filter3(c,e,tp)
	return c:IsSetCard(0x501) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c24501061.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501061.filter3,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c24501061.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c24501061.filter3,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
