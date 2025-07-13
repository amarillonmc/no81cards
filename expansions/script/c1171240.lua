--魔血皇 吸血鬼
function c1171240.initial_effect(c)
    -- 特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1171240,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,1171240)
	e1:SetCost(c1171240.cost1)
	e1:SetTarget(c1171240.tg1)
	e1:SetOperation(c1171240.op1)
	c:RegisterEffect(e1)
    -- 等级变化
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1171240,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,1171241)
    e2:SetCost(c1171240.cost2)
	e2:SetTarget(c1171240.tg2)
	e2:SetOperation(c1171240.op2)
	c:RegisterEffect(e2)
	-- 特殊召唤
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1171240,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,1171246+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c1171240.con3)
	e3:SetTarget(c1171240.tg3)
	e3:SetOperation(c1171240.op3)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(1171240,ACTIVITY_SUMMON,c1171240.counterfilter)
	Duel.AddCustomActivityCounter(1171240,ACTIVITY_SPSUMMON,c1171240.counterfilter)
end
-- 自肃
function c1171240.counterfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
-- 1
function c1171240.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c1171240.filter1(c)
	return c:IsSetCard(0x8e) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c1171240.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c1171240.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c1171240.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c1171240.filter1,tp,LOCATION_DECK,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE)
		and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 2
function c1171240.filter2(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGraveAsCost()
end
function c1171240.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1171240.filter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c1171240.filter2,1,1,REASON_COST)
end
function c1171240.filter22(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and not c:IsLevel(10) and c:IsLevelAbove(1)
end
function c1171240.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc~=c and c1171240.filter22(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1171240.filter22,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1171240.filter22,tp,LOCATION_MZONE,0,1,1,c)
end
function c1171240.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(10)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
-- 3
function c1171240.filter3(c,e,tp)
    return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_XYZ)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1171240.filter33(c)
    return c:IsFaceup() and not (c:GetOriginalRace()==RACE_ZOMBIE)
end
function c1171240.con3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE)
        and eg:IsExists(c1171240.cfilter3,1,nil,tp,re)
end
function c1171240.cfilter3(c,tp,re)
    return c:IsPreviousLocation(LOCATION_MZONE)
        and c:IsPreviousControler(tp)
        and c:IsSetCard(0x8e)
        and c:IsReason(REASON_EFFECT)
end
function c1171240.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c1171240.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c1171240.op3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c1171240.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        local tc=g:GetFirst()
        if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
            Duel.Overlay(tc,Group.FromCards(c))
            local sg=Duel.GetMatchingGroup(c1171240.filter33,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
            if sg:GetCount()>0 then
                Duel.BreakEffect()
                Duel.SendtoGrave(sg,REASON_EFFECT)
            end
        end
    end
end
