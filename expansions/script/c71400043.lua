--异梦之海的潜水员
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400043.initial_effect(c)
	c:SetSPSummonOnce(71400043)
	--link summon
	aux.AddLinkProcedure(c,c71400043.matfilter,1,1,yume.YumeCheck(c))
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400043,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,71400043+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c71400043.con1)
	e1:SetTarget(c71400043.tg1)
	e1:SetOperation(c71400043.op1)
	c:RegisterEffect(e1)
	--field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400043,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c71400043.con2)
	e2:SetOperation(c71400043.op2)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400043,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTarget(c71400043.tg3)
	e3:SetOperation(c71400043.op3)
	c:RegisterEffect(e3)
end
function c71400043.matfilter(c)
	return c:IsLinkType(TYPE_EFFECT) and not c:IsLinkType(TYPE_LINK)
end
function c71400043.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c71400043.filter1(c)
	return c:IsSetCard(0x5714) and c:IsAbleToHand()
end
function c71400043.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400043.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c71400043.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71400043.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71400043.filter2(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c71400043.filter2a(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c71400043.con2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71400043.filter2,tp,LOCATION_MZONE,0,nil)
	return Duel.GetTurnPlayer()~=tp and g:GetCount()>0 and g:FilterCount(c71400043.filter2a,nil)==g:GetCount()
end
function c71400043.op2(e,tp,eg,ep,ev,re,r,rp)
	yume.FieldActivation(tp,nil,2)
end
function c71400043.filter3a(c)
	return c:IsSetCard(0x5714) and c:IsAbleToDeck() and not c:IsPublic()
end
function c71400043.filter3(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c71400043.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400043.filter3,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c71400043.filter3a,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71400043.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c71400043.filter3a,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,c71400043.filter3,tp,LOCATION_DECK,0,1,1,nil)
			if g2:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	end
end