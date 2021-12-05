--饮食艺术·黑猫蛋糕
function c1184051.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,1184051)
	e1:SetCondition(c1184051.con1)
	e1:SetOperation(c1184051.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1184051,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,1184051+100)
	e2:SetTarget(c1184051.tg2)
	e2:SetOperation(c1184051.op2)
	c:RegisterEffect(e2)
--
end
--
function c1184051.cfilter1(c)
	return c:IsSetCard(0x3e12) and c:IsAbleToExtraAsCost()
end
function c1184051.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(c1184051.cfilter1,tp,LOCATION_GRAVE,0,2,nil)
end
function c1184051.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,c1184051.cfilter1,tp,LOCATION_GRAVE,0,2,Duel.GetMatchingGroup(c1184051.cfilter1,tp,LOCATION_GRAVE,0,nil):GetCount(),nil)
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
--
function c1184051.tfilter2(c)
	return c:IsSetCard(0x3e12) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c1184051.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(c1184051.tfilter2,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1184051.ofilter2(c)
	return c:IsSetCard(0x3e12) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c1184051.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c1184051.tfilter2,tp,LOCATION_GRAVE,0,nil)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1184051.ofilter2,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
--
