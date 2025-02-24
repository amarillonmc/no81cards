function c10111170.initial_effect(c)
	aux.AddCodeList(c,10111169)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10111170.val)
	c:RegisterEffect(e1)
	--defup
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10111170,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10111170)
	e3:SetCost(c10111170.spcost)
	e3:SetTarget(c10111170.sptg)
	e3:SetOperation(c10111170.spop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10111170,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,101111700)
	e4:SetCondition(c10111170.spcon2)
	e4:SetTarget(c10111170.sptg2)
	e4:SetOperation(c10111170.spop2)
	c:RegisterEffect(e4)
end
function c10111170.val(e,c)
	return Duel.GetMatchingGroupCount(c10111170.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())*100
end
function c10111170.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c10111170.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10111170.spfilter(c,e,tp)
	return c:IsCode(10111169) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c10111170.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10111170.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10111170.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10111170.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
-- 效果③：墓地特殊召唤
function c10111170.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c10111170.cfilter, 1, nil, tp, rp) 
        and not eg:IsContains(e:GetHandler())
        and Duel.IsExistingMatchingCard(c10111170.tgfilter, tp, LOCATION_GRAVE, 0, 1, nil)
end

function c10111170.cfilter(c,tp,rp)
    return c:IsPreviousControler(tp) 
        and c:IsPreviousLocation(LOCATION_MZONE) 
        and c:IsPreviousPosition(POS_FACEUP) 
        and c:IsCode(10111169) 
        and (c:IsReason(REASON_BATTLE) or (rp == 1-tp and c:IsReason(REASON_EFFECT)))
end

function c10111170.tgfilter(c)
    return c:IsRace(RACE_MACHINE) 
        and not c:IsCode(10111170) -- 假设「完美机械猎兵」卡号为10111170
        and c:IsAbleToDeck()
end

function c10111170.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 
            and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
            and Duel.IsExistingMatchingCard(c10111170.tgfilter, tp, LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_GRAVE)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function c10111170.spop2(e,tp,eg,ep,ev,re,r,rp)
    -- 选择并返回卡组
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g = Duel.SelectMatchingCard(tp, c10111170.tgfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    if g:GetCount() == 0 then return end
    if Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT) > 0 then
        -- 特殊召唤自身
        local c = e:GetHandler()
        if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
            Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
        end
    end
end