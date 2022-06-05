--蚀异梦境-里梦足迹
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400034.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetDescription(aux.Stringid(71400034,0))
	e1:SetCountLimit(1)
	e1:SetTarget(c71400034.tg1)
	e1:SetOperation(c71400034.op1)
	e1:SetCost(c71400034.cost1)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetDescription(aux.Stringid(71400034,1))
	e2:SetCost(c71400034.cost2)
	e2:SetCondition(c71400034.con2)
	e2:SetTarget(c71400034.tg2)
	e2:SetOperation(c71400034.op2)
	c:RegisterEffect(e2)
	--self to deck & activate field
	yume.AddYumeFieldGlobal(c,71400034,2)
end
function c71400034.filter1c(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c71400034.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400034.filter1c,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71400034.filter1c,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c71400034.filter1(c)
	return c:IsSetCard(0x714) and c:IsLinkSummonable(nil)
end
function c71400034.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400034.filter1,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400034.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400034.filter1,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
end
function c71400034.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400034.filter2c,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c71400034.filter2c,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c71400034.filter2c(c)
	return c:IsSetCard(0x7714) and c:IsType(TYPE_FIELD) and c:IsDiscardable()
end
function c71400034.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and (re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c71400034.filter2(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c71400034.filter2b(c,tp)
	return c:IsAbleToRemove(tp) and not c71400034.filter2(c)
end
function c71400034.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
end
function c71400034.op2(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) and Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)==1 then
		local g=Duel.GetMatchingGroup(c71400034.filter2b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
		if Duel.IsExistingMatchingCard(c71400034.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400034,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			Duel.SetLP(tp,Duel.GetLP(tp)-1000)
		end
	end
end