--远古造物大灭绝
require("expansions/script/c9910106")
function c9910717.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910717,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910717+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910717.target)
	e1:SetOperation(c9910717.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910717,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9910717+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c9910717.cost)
	e2:SetTarget(c9910717.target2)
	e2:SetOperation(c9910717.activate2)
	c:RegisterEffect(e2)
end
function c9910717.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Zcd.SetFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e)
	end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c9910717.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 or Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)==0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 then return end
	if ft>3 then ft=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,Zcd.SetFilter,tp,LOCATION_MZONE,LOCATION_MZONE,ft,ft,nil,e)
	if sg:GetCount()==0 then return end
	local sc=sg:GetFirst()
	local sg2=Group.CreateGroup()
	while sc do
		if not sc:IsImmuneToEffect(e) and Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) then
			sg2:AddCard(sc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			sc:RegisterEffect(e1)
		end
		sc=sg:GetNext()
	end
	Duel.RaiseEvent(sg2,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
function c9910717.cfilter(c,tp)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function c9910717.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910717.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910717.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if g:GetFirst():IsSetCard(0xc950) then e:SetLabel(1) end
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910717.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Zcd.SetFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e)
	end
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c9910717.chlimit)
end
function c9910717.chlimit(e,ep,tp)
	return tp==ep
end
function c9910717.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 or Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)==0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 then return end
	if ft>3 then ft=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,Zcd.SetFilter,tp,LOCATION_MZONE,LOCATION_MZONE,ft,ft,nil,e)
	if sg:GetCount()==0 then return end
	local sc=sg:GetFirst()
	local sg2=Group.CreateGroup()
	local b1=e:GetLabel()==1
	local b2=true
	while sc do
		Duel.HintSelection(Group.FromCards(sc))
		if b1 and sc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(9910717,2)) then
			b1=false
			b2=false
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
		end
		if b1 and Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)>0
			and Duel.SelectYesNo(tp,aux.Stringid(9910717,3)) then
			b1=false
			b2=false
			if not sc:IsImmuneToEffect(e) and Duel.MoveToField(sc,tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true) then
				sg2:AddCard(sc)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				sc:RegisterEffect(e1)
			end
		end
		if b2 and not sc:IsImmuneToEffect(e) and Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) then
			sg2:AddCard(sc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			sc:RegisterEffect(e1)
		end
		b2=true
		sc=sg:GetNext()
	end
	Duel.RaiseEvent(sg2,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
