--罗德岛·近卫干员-刻刀·红移
function c79029473.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),4,2)
	c:EnableReviveLimit() 
	--to hand or grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029473,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79029473)
	e1:SetCost(c79029473.cost)
	e1:SetTarget(c79029473.target)
	e1:SetOperation(c79029473.operation)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029473,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19029473)
	e2:SetCondition(c79029473.xycon)
	e2:SetTarget(c79029473.xytg)
	e2:SetOperation(c79029473.xyop)
	c:RegisterEffect(e2)
end
function c79029473.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa900) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c79029473.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029473.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029473.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c79029473.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c79029473.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
	Debug.Message("我可以等待。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029473,0))
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
	Debug.Message("战场就是坟场。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029473,1))
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
function c79029473.xycon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	if not d then return false end
	if a:IsControler(1-tp) then a,d=d,a end
	e:SetLabelObject(d)
	return a:IsFaceup() and a:IsControler(tp) and a:IsSetCard(0xa900) and d:IsFaceup() and d:IsControler(1-tp)
end
function c79029473.xytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
end
function c79029473.xyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
	Debug.Message("或许总有一天，会出现我的刀斩不断的东西。但，看来不是现在，不是你们。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029473,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:Select(tp,1,1,nil) 
	Duel.Overlay(c,sg)
	end
end




