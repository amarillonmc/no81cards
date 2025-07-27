-- 超级防卫机器人·7斗士
local s,id=GetID()
function s.initial_effect(c)
	--xyzlv
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_XYZ_LEVEL)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(s.xyzlv)
	e0:SetLabel(8)
	c:RegisterEffect(e0)
    -- 效果①：召唤/特殊召唤成功时发动
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    
    -- 效果②：作为超量素材赋予效果
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
    e3:SetCondition(s.ovcon)
    e3:SetOperation(s.ovop)
    c:RegisterEffect(e3)
end

-- 效果①：特殊召唤目标过滤
function s.spfilter(c,e,tp)
    return (c:IsSetCard(0x85) or c:IsCode(71071546,68812773)) and not c:IsCode(10111234)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 效果①：目标处理
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) 
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end

-- 效果①：操作处理
function s.spop(e,tp,eg,ep,ev,re,r,rp)   
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
    -- 添加额外卡组特殊召唤限制
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end

-- 效果①：额外卡组特殊召唤限制
function s.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end

-- 效果②：成为超量素材的条件检查
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_XYZ 
        and e:GetHandler():GetReasonCard():IsRace(RACE_MACHINE)
        and e:GetHandler():GetReasonCard():IsAttribute(ATTRIBUTE_EARTH)
end

-- 效果②：赋予超量怪兽效果
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    
    -- 为超量怪兽附加效果
    local e1=Effect.CreateEffect(rc)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(s.xyzcon)
    e1:SetTarget(s.xyztg)
    e1:SetOperation(s.xyzop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
    if not rc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e2,true)
    end
end

-- 效果②：超量召唤成功条件
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

-- 效果②：通常召唤目标过滤
function s.xyzfilter(c)
    return c:IsRace(RACE_MACHINE) 
        and c:IsAttribute(ATTRIBUTE_EARTH) 
        and c:IsSummonable(true,nil)  -- 检查是否可以通常召唤
end

-- 效果②：目标处理
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        -- 检查是否有可召唤的怪兽和空位
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_HAND,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end

-- 效果②：操作处理
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil)  -- 进行通常召唤
    end
end

function s.xyzlv(e,c,rc)
	if rc:IsRace(RACE_MACHINE) then
		return c:GetLevel()+0x10000*e:GetLabel()
	else
		return c:GetLevel()
	end
end