--人理之基 卑弥呼
function c22022580.initial_effect(c)
	c:EnableReviveLimit()
	--Activate(effect)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022580,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,22022580)
	e1:SetCondition(c22022580.condition2)
	e1:SetCost(c22022580.cost)
	e1:SetTarget(c22022580.target2)
	e1:SetOperation(c22022580.activate2)
	c:RegisterEffect(e1)
	--card set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022580,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,22022581)
	e2:SetCondition(c22022580.spcon)
	e2:SetTarget(c22022580.pentg)
	e2:SetOperation(c22022580.penop)
	c:RegisterEffect(e2)
	--card set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022580,2))
	e3:SetCategory(CATEGORY_SSET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,22022581)
	e3:SetCondition(c22022580.spcon1)
	e3:SetCost(c22022580.erecost)
	e3:SetTarget(c22022580.pentg)
	e3:SetOperation(c22022580.penop)
	c:RegisterEffect(e3)
end
function c22022580.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.CheckLPCost(tp,2500) end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.PayLPCost(tp,2500)
end
function c22022580.condition2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and ep~=tp
end
function c22022580.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c22022580.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c22022580.cfilter(c,tp)
	return (c:GetSummonLocation()==LOCATION_DECK or c:GetSummonLocation()==LOCATION_EXTRA) and c:GetPreviousControler()==1-tp
end
function c22022580.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22022580.cfilter,1,nil,tp)
end
function c22022580.penfilter(c,chk)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsSSetable(chk)
end
function c22022580.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022580.penfilter,tp,LOCATION_DECK,0,1,nil,true) end
end
function c22022580.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c22022580.penfilter,tp,LOCATION_DECK,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c22022580.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22022580.cfilter,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22022580.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end