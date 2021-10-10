--黑衣之献身
local m=40009903
local cm=_G["c"..m]
cm.named_with_Relief=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.Relief(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Relief
end
function cm.ccfilter(c)
	return c:IsFacedown() or not cm.Relief(c)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.ccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter(c,e,tp)
	return cm.Relief(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)then
			Duel.Damage(tp,tc:GetAttack(),REASON_EFFECT)
		end
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and ((c:IsRace(RACE_FAIRY) and c:IsType(TYPE_SYNCHRO)) or c:IsCode(40009327))
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tdfilter(c)
	return cm.Relief(c) and c:IsType(TYPE_MONSTER)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local rg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,rg)
		Duel.ShuffleDeck(tp)
		local tg=rg:GetFirst()
		while tg do
			Duel.MoveSequence(tg,0)
			tg=rg:GetNext()
		end
		Duel.SortDecktop(tp,tp,3)
	end
end