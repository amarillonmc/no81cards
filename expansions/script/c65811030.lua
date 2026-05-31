--狂野伯吉斯异兽·伊尔东钵
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--特招
	local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,2))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_CHAINING)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
  e2:SetCondition(s.spcon)
  e2:SetTarget(s.sptg)
  e2:SetOperation(s.spop)
  c:RegisterEffect(e2)
	---不能盖放
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(0xff)
	e3:SetTargetRange(1,1)
	e3:SetTarget(s.atarget)
	c:RegisterEffect(e3)
	--手发
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
end

function s.atarget(e,c)
	return c==e:GetHandler()
end
function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (rc:IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.atktg(e,c)
	return c:IsFaceup()
end
function s.damval(e,re,val,r,rp,rc)
	return val*2
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.atktg)
	e2:SetValue(2000)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e3,tp)
end


function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    -- 遍历当前连锁（从第1环到当前最新的一环ev）
    for i=1,ev do
        local re=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
        -- 只要这个连锁中，存在陷阱卡的发动，就满足条件
        if re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
            return true
        end
    end
    return false
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0xd4,TYPES_NORMAL_TRAP_MONSTER,1200,0,2,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

-- 这里使用你提供的参考代码，通过穷举常用召唤类别，寻找“可以用自身方法特殊召唤”的怪兽
function s.rule_spfilter(c)
    for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
        if c:IsSpecialSummonable(sumtype) then return true end
    end
    return false
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not (c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0xd4,TYPES_NORMAL_TRAP_MONSTER,1200,0,2,RACE_AQUA,ATTRIBUTE_WATER)) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    c:AddMonsterAttribute(TYPE_NORMAL)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2,true)
    Duel.SpecialSummonComplete()
    -- “那之后，可以用自身的方法进行1只怪兽的特殊召唤”
    -- 0xff 代表搜索全区域(LOCATION_ALL)，系统底层会在判断 IsSpecialSummonable 时自动过滤合理区域
    local sg=Duel.GetMatchingGroup(s.rule_spfilter,tp,0xff,0,nil)
    if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.BreakEffect() -- 插入时点
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=sg:Select(tp,1,1,nil):GetFirst()
        if tc then
            -- 调用系统底层判定具体是通过哪种方式召唤，然后执行规则特召
            for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
                if tc:IsSpecialSummonable(sumtype) then
                    Duel.SpecialSummonRule(tp,tc,sumtype)
                    break
                end
            end
        end
    end
end

-- 判定“不受怪兽效果影响”
function s.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER)
end