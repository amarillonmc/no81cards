--神威骑士皇（未解限）
function c24501070.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x501),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
    --cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
    -- 战吼抗性（非发动式）
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c24501070.regcon)
    e1:SetOperation(c24501070.regop)
    c:RegisterEffect(e1)
    -- 无效并破坏
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24501070,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,24501070)
	e2:SetCondition(c24501070.con2)
	e2:SetTarget(c24501070.tg2)
	e2:SetOperation(c24501070.op2)
	c:RegisterEffect(e2)
    -- 遗言炸场
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24501070,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,24501071)
	e3:SetCondition(c24501070.con3)
	e3:SetTarget(c24501070.tg3)
	e3:SetOperation(c24501070.op3)
	c:RegisterEffect(e3)
end
-- 1
function c24501070.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c24501070.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_INACTIVATE)
    e1:SetValue(c24501070.efilter1)
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_DISABLE)
    e2:SetValue(c24501070.efilter2)
    e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
    Duel.RegisterEffect(e2,tp)
end
function c24501070.efilter1(e,ct)
    local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
    return te:GetHandler()==e:GetHandler()
end
function c24501070.efilter2(e,c)
    return c==e:GetHandler()
end
-- 2
function c24501070.con2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c24501070.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c24501070.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
-- 3
function c24501070.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)
end
function c24501070.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c24501070.op3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
