--馄饨剩汤 菜肉混陷
function c95102006.initial_effect(c)
    c:SetUniqueOnField(1,0,95102006)
	-- 融合素材
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xbbc),2,true)
	-- 效果抗性
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95102006,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c95102006.con1)
	e1:SetValue(c95102006.filter1)
	c:RegisterEffect(e1)
    -- 解场除外
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
    e2:SetCost(c95102006.cost2)
	e2:SetTarget(c95102006.tg2)
	e2:SetOperation(c95102006.op2)
	c:RegisterEffect(e2)
	-- 攻击上升
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95102006,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c95102006.tg3)
	e3:SetOperation(c95102006.op3)
	c:RegisterEffect(e3)
end
-- 1
function c95102006.con1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c95102006.filter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
-- 2
function c95102006.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c95102006.filter2(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToRemove()
end
function c95102006.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c95102006.filter2,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c95102006.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
end
function c95102006.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
-- 3
function c95102006.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))>0 end
end
function c95102006.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
