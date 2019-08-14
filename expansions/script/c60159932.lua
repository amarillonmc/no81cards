--曜日
function c60159932.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_DRAW)
    e1:SetOperation(c60159932.e1op)
    c:RegisterEffect(e1)
	--draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCost(c60159932.e2cost)
    e2:SetTarget(c60159932.e2tg)
    e2:SetOperation(c60159932.e2op)
    c:RegisterEffect(e2)
end
function c60159932.e1opfilter(c,p)
    return c:IsLocation(LOCATION_DECK) and c:IsControler(p)
end
function c60159932.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=e:GetHandlerPlayer()
    if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(60159932,0)) then
        Duel.ConfirmCards(1-tp,c)
		Duel.Hint(HINT_CARD,0,60159932)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local og=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,99,nil)
		Duel.SendtoDeck(og,nil,2,REASON_EFFECT)
		local dc=Duel.GetOperatedGroup()
		local dc2=dc:Filter(c60159932.e1opfilter,nil,tp)
		if dc2:GetCount()>0 then 
			Duel.Recover(tp,dc2:GetCount()*1000,REASON_EFFECT)
			Group.Sub(og,dc2)
			Duel.SendtoGrave(og,REASON_RULE)
		else
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.ShuffleHand(tp)
    end
end
function c60159932.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60159932,1))
end
function c60159932.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60159932.e2op(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)>0 then
        Duel.BreakEffect()
        Duel.SetLP(tp,Duel.GetLP(tp)-1000)
    end
end