function c10105590.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLevel,12),1)
    	  	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105590,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10105590)
	e1:SetCondition(c10105590.thcon1)
	e1:SetTarget(c10105590.thtg1)
	e1:SetOperation(c10105590.thop1)
	c:RegisterEffect(e1)
    -- 快速效果（对方效果发动时连锁）
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101055900)
    e2:SetCondition(c10105590.condition)
    e2:SetCost(c10105590.cost)
    e2:SetTarget(c10105590.target)
    e2:SetOperation(c10105590.activate)
    c:RegisterEffect(e2)
end
function c10105590.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10105590.thfilter1(c)
	return c:IsCode(10105587) and c:IsAbleToHand()
end
function c10105590.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105590.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105590.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105590.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- 条件：对方发动效果时
function c10105590.condition(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandlerPlayer()==1-tp
end

-- 代价：自身除外
function c10105590.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemoveAsCost() end
    Duel.Remove(c,POS_FACEUP,REASON_COST)
end

-- 目标筛选
function c10105590.filter(c)
    return c:IsSetCard(0x7cca) and c:IsLevel(12) and c:IsFaceup()
end

function c10105590.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(c10105590.filter,tp,LOCATION_REMOVED,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end

-- 特殊召唤操作
function c10105590.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c10105590.filter,tp,LOCATION_REMOVED,0,1,1,nil)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end