--馄饨剩汤 牛肉
function c95102003.initial_effect(c)
	-- 放置永续
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95102003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95102003)
	e1:SetTarget(c95102003.tg1)
	e1:SetOperation(c95102003.op1)
	c:RegisterEffect(e1)
	-- 共通效果
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95102003,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,95102014)
    e2:SetCondition(c95102003.con2)
    e2:SetTarget(c95102003.tg2)
    e2:SetOperation(c95102003.op2)
    c:RegisterEffect(e2)
end
-- 1
function c95102003.filter1(c,tp)
	return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS and c:IsSetCard(0xbbc) and c:IsSSetable()
end
function c95102003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95102003.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c95102003.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c95102003.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
-- 2
function c95102003.con2(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_FUSION and re:GetHandler():IsSetCard(0xbbc)
        and (e:GetHandler():IsLocation(LOCATION_GRAVE) or e:GetHandler():IsLocation(LOCATION_REMOVED))
end
function c95102003.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c95102003.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
        Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
        e1:SetDescription(aux.Stringid(95102003,7))
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
    end
end
