--蚀异梦境-里梦足迹
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400034.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c71400034.cost1)
	e1:SetCondition(c71400034.con1)
	e1:SetTarget(c71400034.tg1)
	e1:SetOperation(c71400034.op1)
	c:RegisterEffect(e1)
	--self to deck & field activation
	yume.AddYumeFieldGlobal(c,71400034,2)
end
function c71400034.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400034.filter1c,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c71400034.filter1c,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c71400034.filter1c(c)
	return c:IsSetCard(0x7714) and c:IsType(TYPE_FIELD) and c:IsDiscardable()
end
function c71400034.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and (re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c71400034.filter1(c)
	return c:IsSetCard(0x716) and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c71400034.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	if Duel.IsExistingMatchingCard(c71400034.filter1,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK+CATEGORY_REMOVE,eg,1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c71400034.op1(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():IsRelateToEffect(e) and re:GetHandler():IsRelateToEffect(re)) then return end
	if Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)==1 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,tp)
		if Duel.IsExistingMatchingCard(c71400034.filter1,tp,LOCATION_ONFIELD,0,1,nil) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400034,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			Duel.SetLP(tp,Duel.GetLP(tp)-1000)
		end
	end
end