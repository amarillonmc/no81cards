--美味的红茶宴
function c60151910.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --avoid battle damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,60151902))
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,60151902))
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --draw
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60151910,0))
    e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCountLimit(1)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTarget(c60151910.e4tg)
    e4:SetOperation(c60151910.e4op)
    c:RegisterEffect(e4)
    --draw
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(60151910,1))
    e5:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_FZONE)
    e5:SetTarget(c60151910.e5tg)
    e5:SetOperation(c60151910.e5op)
    c:RegisterEffect(e5)
end
function c60151910.e4tgfilter(c)
    return (c:IsSetCard(0xab26) or c:IsSetCard(0x6b26) or c:IsSetCard(0x9b26)) and c:IsAbleToDeck() and not c:IsPublic()
end
function c60151910.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp)
        and Duel.IsExistingMatchingCard(c60151910.e4tgfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151910.e4op(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local kz=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
	if kz>3 then kz=3 end
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(p,c60151910.e4tgfilter,p,LOCATION_HAND,0,1,kz,nil)
    if g:GetCount()>0 then
        Duel.ConfirmCards(1-p,g)
        if Duel.Draw(p,g:GetCount(),REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
		Duel.ShuffleDeck(p)
		Duel.ShuffleHand(p)
    end
end
function c60151910.e5tgfilter(c)
    return (c:IsSetCard(0xab26) or c:IsSetCard(0x6b26) or c:IsSetCard(0x9b26)) and c:IsAbleToDeck() and c:IsFaceup()
end
function c60151910.e5tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151910.e5tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil) and Duel.GetFlagEffect(tp,60151910)==0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c60151910.e5tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_EXTRA) then
        Duel.ConfirmCards(1-tp,tc)
	end
    Duel.RegisterFlagEffect(tp,60151910,RESET_CHAIN,0,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151910.e5op(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) then
			Duel.BreakEffect()
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
    end
end
