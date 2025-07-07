--神威骑士指挥官（未解限）
function c24501050.initial_effect(c)
    -- 手卡起跳
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(24501050,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,24501050)
	e1:SetCondition(c24501050.con1)
	e1:SetTarget(c24501050.tg1)
	e1:SetOperation(c24501050.op1)
	c:RegisterEffect(e1)
    -- 双召检索
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24501050,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,24501051)
	e2:SetTarget(c24501050.tg2)
	e2:SetOperation(c24501050.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
    -- 回收回收
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(24501050,2))
    e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1,24501052)
    e4:SetTarget(c24501050.tg3)
    e4:SetOperation(c24501050.op3)
    c:RegisterEffect(e4)
end
-- 1
function c24501050.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x501)
end
function c24501050.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24501050.filter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c24501050.con11(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c24501050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24501050.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
-- 2
function c24501050.filter2(c)
	return c:IsSetCard(0x501) and c:IsAbleToHand()
end
function c24501050.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501050.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c24501050.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c24501050.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c24501050.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c24501050.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_MACHINE)
end
-- 3
function c24501050.filter3(c)
    return c:IsSetCard(0x501) and c:IsAbleToDeck()
end
function c24501050.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(c24501050.filter3,tp,LOCATION_GRAVE,0,1,e:GetHandler())
            and Duel.GetMatchingGroupCount(c24501050.filter3,tp,LOCATION_GRAVE,0,e:GetHandler())>=3
    end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c24501050.op3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c24501050.filter3,tp,LOCATION_GRAVE,0,3,3,c)
    if g:GetCount()==3 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end
