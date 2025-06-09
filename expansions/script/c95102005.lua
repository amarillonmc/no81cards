--馄饨剩汤 玉米
function c95102005.initial_effect(c)
	-- 加入手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95102005,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,95102005)
    e1:SetCost(c95102005.cost1)
	e1:SetTarget(c95102005.tg1)
	e1:SetOperation(c95102005.op1)
	c:RegisterEffect(e1)
	-- 共通效果
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95102005,1))
    e2:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,95102016)
    e2:SetCondition(c95102005.con2)
    e2:SetTarget(c95102005.tg2)
    e2:SetOperation(c95102005.op2)
    c:RegisterEffect(e2)
end
-- 1
function c95102005.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c95102005.filter1(c)
	return c:IsSetCard(0xbbc) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95102005.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95102005.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c95102005.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c95102005.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) and Duel.GetFlagEffect(tp,95102005)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(95102005,7))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xbbc))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,95102005,RESET_PHASE+PHASE_END,0,1)
	end
end
-- 2
function c95102005.con2(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_FUSION and re:GetHandler():IsSetCard(0xbbc)
        and (e:GetHandler():IsLocation(LOCATION_GRAVE) or e:GetHandler():IsLocation(LOCATION_REMOVED))
end
function c95102005.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDraw(tp,1)
    end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c95102005.op2(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
    Duel.Draw(tp,1,REASON_EFFECT)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOZONE)
        local sel=1-tp
        local loc=Duel.SpecialSummon(e:GetHandler(),0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UNRELEASABLE_SUM)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
        e1:SetDescription(aux.Stringid(95102005,2))
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1,true)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
        c:RegisterEffect(e2,true)
        local e3=e1:Clone()
        e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
        e3:SetDescription(aux.Stringid(95102005,3))
        c:RegisterEffect(e3,true)
        local e4=e1:Clone()
        e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
        e4:SetDescription(aux.Stringid(95102005,4))
        c:RegisterEffect(e4,true)
        local e5=e1:Clone()
        e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL) 
        e5:SetDescription(aux.Stringid(95102005,5))
        c:RegisterEffect(e5,true)
        local e6=e1:Clone()
        e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e6:SetDescription(aux.Stringid(95102005,6))
        c:RegisterEffect(e6,true)
    end
end
function c95102005.lim(e,c,st)
    return st==SUMMON_TYPE_FUSION
end
