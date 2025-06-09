--馄饨剩汤 猪肉
function c95102004.initial_effect(c)
	-- 放置永续
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95102004)
	e1:SetTarget(c95102004.tg1)
	e1:SetOperation(c95102004.op1)
	c:RegisterEffect(e1)
	-- 共通效果
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95102004,1))
    e2:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,95102015)
    e2:SetCondition(c95102004.con2)
    e2:SetTarget(c95102004.tg2)
    e2:SetOperation(c95102004.op2)
    c:RegisterEffect(e2)
end
-- 1
function c95102004.filter1(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSetCard(0xbbc) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c95102004.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c95102004.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
end
function c95102004.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c95102004.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
-- 2
function c95102004.con2(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_FUSION and re:GetHandler():IsSetCard(0xbbc)
        and (e:GetHandler():IsLocation(LOCATION_GRAVE) or e:GetHandler():IsLocation(LOCATION_REMOVED))
end
function c95102004.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDraw(tp,1)
    end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c95102004.op2(e,tp,eg,ep,ev,re,r,rp)
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
        e1:SetDescription(aux.Stringid(95102004,2))
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1,true)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
        c:RegisterEffect(e2,true)
        local e3=e1:Clone()
        e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
        e3:SetDescription(aux.Stringid(95102004,3))
        c:RegisterEffect(e3,true)
        local e4=e1:Clone()
        e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
        e4:SetDescription(aux.Stringid(95102004,4))
        c:RegisterEffect(e4,true)
        local e5=e1:Clone()
        e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL) 
        e5:SetDescription(aux.Stringid(95102004,5))
        c:RegisterEffect(e5,true)
        local e6=e1:Clone()
        e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e6:SetDescription(aux.Stringid(95102004,6))
        c:RegisterEffect(e6,true)
    end
end
function c95102004.lim(e,c,st)
    return st==SUMMON_TYPE_FUSION
end
