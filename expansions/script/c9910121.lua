--战车道装甲·丘吉尔MkⅦ
dofile("expansions/script/c9910100.lua")
function c9910121.initial_effect(c)
	--xyz summon
	QutryZcd.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),5,2,c9910121.xyzfilter,99)
	c:EnableReviveLimit()
	--to deck top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910121,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(c9910121.ttcost)
	e1:SetTarget(c9910121.tttg)
	e1:SetOperation(c9910121.ttop)
	c:RegisterEffect(e1)
	--draw & negate
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(9910121,2))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c9910121.drcon)
	e2:SetTarget(c9910121.drtg)
	e2:SetOperation(c9910121.drop)
	c:RegisterEffect(e2)
end
function c9910121.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9958) and c:IsFaceup()))
		and c:IsRace(RACE_MACHINE)
end
function c9910121.ttcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910121.tttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x9958)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910121.ttop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910121,3))
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x9958)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c9910121.drcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c9910121.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910121.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-p,tc)
	if tc:IsSetCard(0x9958) then
		Duel.BreakEffect()
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
	Duel.ShuffleHand(p)
end
