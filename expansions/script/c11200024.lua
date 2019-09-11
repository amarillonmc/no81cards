--『月面弹跳』
function c11200024.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200024)
	e1:SetTarget(c11200024.tg1)
	e1:SetOperation(c11200024.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11200124)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c11200024.cost2)
	e2:SetTarget(c11200024.tg2)
	e2:SetOperation(c11200024.op2)
	c:RegisterEffect(e2)
--
end
--
c11200024.xig_ihs_0x132=1
--
function c11200024.tfilter1(c)
	return c:IsCode(11200019)
		or (c.xig_ihs_0x132 and c:IsAbleToHand())
end
function c11200024.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200024.tfilter1,tp,LOCATION_DECK,0,1,nil) end
end
--
function c11200024.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c11200024.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
--
function c11200024.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	local g=Group.CreateGroup()
	g:AddCard(c)
	Duel.HintSelection(g)
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
--
function c11200024.tfilter2(c,e,tp)
	return c.xig_ihs_0x132 and c:IsType(TYPE_SPELL)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT)
end
function c11200024.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c11200024.tfilter2,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
--
function c11200024.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c11200024.tfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	sc:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_LIGHT,RACE_BEAST,4,1100,1100)
	Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
	Duel.Draw(tp,1,REASON_EFFECT)
end
--
