--蒸汽朋克·诺缇希
local s,id,o=GetID()
function s.initial_effect(c)

    -- 自己的场上有念动力族怪兽存在的场合，对方把墓地的怪兽的效果发动时，把墓地的这张卡除外，支付300基本分才能发动，那个效果无效
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	
	-- 把自己场上的这张卡作为同调素材的场合，可以把这张卡当作调整以外的怪兽使用
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(s.tnval)
	c:RegisterEffect(e2)
end

-- 自己的场上有念动力族怪兽存在的场合，对方把墓地的怪兽的效果发动时，把墓地的这张卡除外，支付300基本分才能发动，那个效果无效
function s.checkfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsFaceup()
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return Duel.IsExistingMatchingCard(s.checkfilter,tp,LOCATION_MZONE,0,1,nil) and ep~=tp and (LOCATION_GRAVE)&loc~=0
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.CheckLPCost(tp,300) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.PayLPCost(tp,300)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

-- 把自己场上的这张卡作为同调素材的场合，可以把这张卡当作调整以外的怪兽使用
function s.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
