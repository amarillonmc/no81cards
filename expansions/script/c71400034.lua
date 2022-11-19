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
	e1:SetDescription(aux.Stringid(71400034,0))
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
	return c:IsSetCard(0x714) and c:IsAbleToDeckOrExtraAsCost()
end
function c71400034.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400034.filter1c,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c71400034.filter1c,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
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
	if chk==0 then return Duel.IsExistingMatchingCard(c71400034.filter2c,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.DiscardHand(tp,c71400034.filter2c,1,1,REASON_COST,nil)
end
function c71400034.filter2c(c)
	return c:IsSetCard(0x7714) and c:IsType(TYPE_FIELD) and c:IsAbleToDeckAsCost()
end
function c71400034.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c71400034.filter2(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c71400034.filter2b(c,tp)
	return c:IsAbleToRemove(tp) and not c71400034.filter2(c)
end
function c71400034.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,rc,1,0,0)
end
function c71400034.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)==1 then
		local g=Duel.GetMatchingGroup(c71400034.filter2b,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),tp)
		local lg=Duel.GetMatchingGroup(c71400034.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if lg:GetCount()>0 and lg:GetSum(Card.GetLink)>=4 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400034,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			Duel.SetLP(tp,Duel.GetLP(tp)-1000)
		end
	end
end