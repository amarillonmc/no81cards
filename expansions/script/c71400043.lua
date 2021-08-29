--异梦海底的潜水员-橘黄子
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
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
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
	e2:SetTarget(c71400043.tg2)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400043,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c71400043.con3)
	e3:SetOperation(c71400043.op3)
	e3:SetCost(c71400043.cost3)
	e3:SetTarget(c71400043.tg3)
	c:RegisterEffect(e3)
	--[[
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
	--]]
end
function c71400043.matfilter(c)
	return c:IsSetCard(0x714) and not c:IsLinkType(TYPE_LINK)
end
function c71400043.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c71400043.filter1(c)
	return c:IsSetCard(0xd714) and c:IsAbleToHand()
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
function c71400043.con2(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.GetFlagEffect(tp,71400038)>0 or e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN))
end
function c71400043.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		local id=0
		if fc and fc:IsFaceup() then id=fc:GetCode() end
		return yume.YumeFieldCheck(tp,id,2,LOCATION_GRAVE+LOCATION_DECK)
	end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c71400043.op2(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local id=0
	if fc and fc:IsFaceup() then id=fc:GetCode() end
	yume.ActivateYumeField(tp,id,2,LOCATION_GRAVE+LOCATION_DECK)
end
function c71400043.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,71400038)>0
end
function c71400043.filter3(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN) and not(c:IsLocation(LOCATION_FZONE) and c:IsType(TYPE_FIELD) and c:IsSetCard(0x3714) and c:IsFaceup() and c:IsControler(tp))
end
function c71400043.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost(POS_FACEDOWN) end
	Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_COST)
end
function c71400043.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400043.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c71400043.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c71400043.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71400043.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
--[[
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
--]]