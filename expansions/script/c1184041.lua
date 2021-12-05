--饮食艺术·儿童列车
function c1184041.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1184041.lfilter,2,2,c1184041.lcheck)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1184041,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c1184041.con2)
	e2:SetCost(c1184041.cost2)
	e2:SetTarget(c1184041.tg2)
	e2:SetOperation(c1184041.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1184041,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c1184041.tg2)
	e3:SetOperation(c1184041.op2)
	c:RegisterEffect(e3)
--
end
--
function c1184041.lfilter(c)
	return c:IsLevel(3)
end
function c1184041.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3e12)
end
--
function c1184041.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c1184041.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c1184041.tfilter2(c)
	return c:IsSetCard(0x3e12) and c:IsAbleToHand()
end
function c1184041.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(1184041)==0
	local b2=Duel.IsExistingMatchingCard(c1184041.tfilter2,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(1184042)==0
	if chk==0 then return b1 or b2 end
end
function c1184041.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(1184041)==0
	local b2=Duel.IsExistingMatchingCard(c1184041.tfilter2,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(1184042)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(1184041,1),aux.Stringid(1184041,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(1184041,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(1184041,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		c:RegisterFlagEffect(1184041,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1184041.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		c:RegisterFlagEffect(1184042,RESET_PHASE+PHASE_END,0,1)
	end
end
--