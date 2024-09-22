--植物娘·玉米投手
function c65830015.initial_effect(c)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65830015+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65830015.spcon)
	c:RegisterEffect(e1)
	--无效
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,65830016)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65830015.discon)
	e2:SetCost(c65830015.discost)
	e2:SetTarget(c65830015.distg)
	e2:SetOperation(c65830015.disop)
	c:RegisterEffect(e2)
end



function c65830015.filter(c)
	return c:IsSetCard(0xa33) and c:IsFaceup()
end
function c65830015.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65830015.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end


function c65830015.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c65830015.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c65830015.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c65830015.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.NegateEffect(ev)
end
