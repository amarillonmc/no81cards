--女神之威-斩
local s,id=GetID()
function s.initial_effect(c)
	--①：发动无效并除外，之后可选炸纵列
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

--①：发动条件（对方怪兽效果）
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end

--①：Cost（除外墓地1只「女神之令」怪兽）
function s.cfilter(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--①：Target
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end

--①：Operation
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	--1. 发动无效并除外
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
	
	--2. 相同纵列破坏
	local c=e:GetHandler()
	--这张卡必须还在场上（S/Z区域）才能判断纵列
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_SZONE) then
		--获取这张卡相同纵列的、对方场上的、怪兽区域的卡
		local g=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
		
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then --"要破坏相同纵列的怪兽吗？"
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end