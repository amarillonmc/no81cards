--超古代的巨人
function c98930016.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c98930016.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0xad0),true)
	--cannot spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(c98930016.splimit)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
   --act 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98930016,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98930016)
	e2:SetCost(c98930016.cost)
	e2:SetOperation(c98930016.operation)
	c:RegisterEffect(e2)
  --Act 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98930016,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98940016)
	e3:SetCost(c98930016.cost2)
	e3:SetCondition(c98930016.damcon)
	e3:SetTarget(c98930016.damtg)
	e3:SetOperation(c98930016.damop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--show dark for atk/def down
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98930016,2))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,98960016)
	e5:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCondition(aux.dscon)
	e5:SetCost(c98930016.adcost)
	e5:SetTarget(c98930016.adtg)
	e5:SetOperation(c98930016.adop)
	c:RegisterEffect(e5)
end
function c98930016.matfilter(c)
	return c:IsFusionType(TYPE_FUSION) and c:IsFusionSetCard(0xad0)
end
function c98930016.cfilter(c)
	return c:IsSetCard(0xad0) and c:IsAbleToRemoveAsCost()
end
function c98930016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(98930016)==0
		and Duel.IsExistingMatchingCard(c98930016.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98930016.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(98930016,RESET_CHAIN,0,1)
end
function c98930016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(400)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function c98930016.filter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c98930016.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(98930016)==0
		and Duel.IsExistingMatchingCard(c98930016.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98930016.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(98930016,RESET_CHAIN,0,1)
end
function c98930016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c98930016.filter,1,nil,tp) and Duel.IsPlayerCanDraw(tp,1) end
	local g=eg:Filter(c98930016.filter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98930016.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsSummonPlayer(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c98930016.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c98930016.filter2,nil,e,tp)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c98930016.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c98930016.dfilter(c,e,sp)
	return c:IsSummonPlayer(sp) and (not e or c:IsRelateToEffect(e))
end
function c98930016.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c98930016.dfilter,1,nil,nil,1-tp) end
	local g=eg:Filter(c98930016.dfilter,nil,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c98930016.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c98930016.dfilter,nil,e,1-tp)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()~=0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c98930016.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(98930016)==0
		and Duel.IsExistingMatchingCard(c98930016.cfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98930016.cfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(98930016,RESET_CHAIN,0,1)
end
function c98930016.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98930016.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end