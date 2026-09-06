-- 写意借过
local s,id,o=GetID()
function s.initial_effect(c)
	--①效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)

	--②效果：墓地盖放
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.cond2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end

--判断自己手卡·场上是否存在可用怪兽
function s.showfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and Duel.IsExistingMatchingCard(s.gravefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack())
end

--判断对方场上是否存在攻击力<=指定值的可送墓怪兽
function s.gravefilter(c,atk)
	return c:IsAttackBelow(atk) and c:IsAbleToGrave() and c:IsFaceup()
end

--①效果发动检测
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.showfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end

--①效果处理
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	--选择自己手卡或场上1只怪兽展示
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc=Duel.SelectMatchingCard(tp,s.showfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if not sc then return end
	Duel.ConfirmCards(1-tp,sc)
	local atk=sc:GetAttack()
	--选择对方场上攻击力<=atk的怪兽送去墓地
	local g=Duel.GetMatchingGroup(s.gravefilter,tp,LOCATION_MZONE,LOCATION_MZONE,sc,atk)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,#g,nil)
		if #sg>0 then
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end

--②效果条件：自己场上有攻击力最高的怪兽（全场最高）
function s.cond2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:IsExists(Card.IsControler,1,nil,tp)
end

--②效果目标：可盖放到魔陷区
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
end

--②效果处理：从墓地盖放
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end