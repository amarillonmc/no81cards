--女神之威-斩
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：无效并破坏
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
end

-- 条件检查：对方发动怪兽效果
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end

-- cost：解放1只女神之令怪兽
function s.costfilter(c,tp)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end

-- 目标设置
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
-- 操作处理
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	-- 无效并除外
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)	
		end
		local cg=e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Destroy(cg,REASON_EFFECT)
		end
end
