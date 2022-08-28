--混沌破坏龙 甘多拉
function c9981625.initial_effect(c)
	 c:EnableReviveLimit()
  	--spsummon
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e0)
  --spsummon proc
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCondition(c9981625.spcon)
	e3:SetOperation(c9981625.spop)
	c:RegisterEffect(e3)
--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c9981625.destg)
	e3:SetOperation(c9981625.desop)
	c:RegisterEffect(e3)
--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9981625.atkval)
	c:RegisterEffect(e1)
    local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e4)
    --damage
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9981625,0))
	e11:SetCategory(CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,9981625)
    e11:SetTarget(c9981625.damtg)
	e11:SetOperation(c9981625.damop)
	c:RegisterEffect(e11)
end
function c9981625.chlimit(e,ep,tp)
    return tp==ep
end
function c9981625.cfilter(c)
	return c:IsSetCard(0xf5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and not c:IsCode(9981625)
end
function c9981625.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9981625.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c9981625.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9981625.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9981625.desfilter(c)
	return not c:IsCode(9981625)
end
function c9981625.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981625.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c9981625.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetChainLimit(c9981625.chlimit)
end
function c9981625.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9981625.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_RULE)
	end
end
function c9981625.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,TYPE_MONSTER)*600
end
function c9981625.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,TYPE_MONSTER)*300
	Duel.SetTargetParam(dam)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
    Duel.SetChainLimit(c9981625.chlimit)
end
function c9981625.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,TYPE_MONSTER)*300
	Duel.Damage(p,dam,REASON_EFFECT)
end