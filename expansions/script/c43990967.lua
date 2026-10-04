--浮梦预言
function c43990967.initial_effect(c)
	aux.AddCodeList(c,43990987)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(43990967,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c43990967.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990967,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43990967.target)
	e1:SetOperation(c43990967.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetDescription(aux.Stringid(43990967,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,43990967)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c43990967.drtg)
	e2:SetOperation(c43990967.drop)
	c:RegisterEffect(e2)
end
function c43990967.hcfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsFaceup()
end
function c43990967.cfilter(c)
	return c:IsCode(43990987) and c:IsFaceup()
end
function c43990967.handcon(e)
	return not Duel.IsExistingMatchingCard(c43990967.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) or Duel.IsExistingMatchingCard(c43990967.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c43990967.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,43990967,0,TYPES_NORMAL_TRAP_MONSTER,2000,2400,4,RACE_PSYCHO,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43990967.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.IsPlayerCanSpecialSummonMonster(tp,43990967,0,TYPES_NORMAL_TRAP_MONSTER,2000,2400,4,RACE_PSYCHO,ATTRIBUTE_WIND) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c43990967.drfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToDeck() and not c:IsPublic()
end
function c43990967.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c43990967.drfilter,tp,LOCATION_HAND,e:GetHandler(),1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c43990967.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c43990967.drfilter,p,LOCATION_HAND,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=aux.PlaceCardsOnDeckBottom(p,g)
		if ct==0 then return end
		Duel.BreakEffect()
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end
