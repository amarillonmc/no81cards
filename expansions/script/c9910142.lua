--战车道计策·盲点侦察
function c9910142.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910142.target)
	e1:SetOperation(c9910142.activate)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910142)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c9910142.negop)
	c:RegisterEffect(e2)
end
function c9910142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c9910142.thfilter(c,cardtype)
	return c:IsSetCard(0x9958) and c:IsType(cardtype) and c:IsAbleToHand()
end
function c9910142.gcheck(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c9910142.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct==0 then return end
	local ac=1
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910142,0))
		ac=Duel.AnnounceNumber(tp,1,2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,ac)
	Duel.ConfirmCards(tp,g)
	local cardtype=0
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then cardtype=cardtype+TYPE_MONSTER end
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then cardtype=cardtype+TYPE_SPELL end
	if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then cardtype=cardtype+TYPE_TRAP end
	local tg=Duel.GetMatchingGroup(c9910142.thfilter,tp,LOCATION_DECK,0,nil,cardtype)
	if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910142,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=tg:SelectSubGroup(tp,c9910142.gcheck,false,1,3)
		if sg then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ShuffleHand(1-tp)
end
function c9910142.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
