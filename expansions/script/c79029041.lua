--罗德岛·狙击干员-守林人
function c79029041.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_DECK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c79029041.dscost)
	e1:SetOperation(c79029041.dsop)
	e1:SetCountLimit(1,79029041)
	c:RegisterEffect(e1)   
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(73594093,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79029041)
	e2:SetCost(c79029041.tdcost)
	e2:SetTarget(c79029041.tdtg)
	e2:SetOperation(c79029041.tdop)
	c:RegisterEffect(e2)
end
function c79029041.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,3,REASON_COST) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.RemoveCounter(tp,1,0,0x1099,3,REASON_COST)
end
function c79029041.dsop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
		local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(tc,REASON_EFFECT)
	Debug.Message("开火！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029041,0))
end
function c79029041.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c79029041.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79029041.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	Debug.Message("到达目标地点。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029041,1))
end
