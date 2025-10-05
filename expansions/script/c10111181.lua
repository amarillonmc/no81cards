function c10111181.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,c10111181.f1filter,c10111181.f2filter,1,true)
	aux.AddContactFusionProcedure(c,c10111181.cfilter,LOCATION_MZONE+LOCATION_GRAVE,0,aux.tdcfop(c))
  	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
      --negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10111181,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,10111181)
    e1:SetCondition(c10111181.condition)
    e1:SetTarget(c10111181.target)
    e1:SetOperation(c10111181.operation)
    c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111181,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,101111810)
	e2:SetCondition(c10111181.spcon)
	e2:SetTarget(c10111181.sptg)
	e2:SetOperation(c10111181.spop)
	c:RegisterEffect(e2)
end
function c10111181.f1filter(c)
	return c:IsSetCard(0x1185) and c:IsLevel(5)
end
function c10111181.f2filter(c)
	return c:IsSetCard(0x1185) and c:IsLevel(8)
end
-- 新增涂鸦兽字段检查函数
function c10111181.fieldfilter(c)
    return c:IsSetCard(0x1185) and c:IsFaceup() and not c:IsCode(10111181)
end

-- 修改后的发动条件
function c10111181.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return rp==1-tp 
        and re:IsActiveType(TYPE_MONSTER)
        and Duel.IsExistingMatchingCard(c10111181.fieldfilter,tp,LOCATION_MZONE,0,1,nil) -- 新增字段检查
        and not c:IsStatus(STATUS_BATTLE_DESTROYED)
        and Duel.IsChainNegatable(ev)
end
function c10111181.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10111181.operation(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
        if Duel.Destroy(rc,REASON_EFFECT)>0 then  -- 检测破坏是否成功
            local atk=rc:GetBaseAttack()
            if atk>0 then  -- 确保攻击力为正数
                Duel.Recover(tp,atk,REASON_EFFECT)
            end
        end
    end
end
function c10111181.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():IsPreviousControler(tp)
end
function c10111181.spfilter2(c,e,tp)
	return c:IsRace(RACE_DINOSAUR) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10111181.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10111181.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c10111181.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10111181.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end