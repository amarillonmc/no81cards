--军火大师
local m=16670035
local cm=_G["c"..m]
function cm.initial_effect(c)
    --
	local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_PREDRAW)
    e0:SetRange(0xfff)
    e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
    e0:SetOperation(cm.autoop)
    c:RegisterEffect(e0)
    --
end
function cm.autoop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    Duel.Hint(HINT_CARD,1-tp,m)
    Duel.ConfirmCards(1-tp,c)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xfff,0,nil)
    local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,0xfff-LOCATION_OVERLAY,nil)
    Duel.Exile(g,REASON_RULE)
    for tc in aux.Next(g2) do
        local ac=tc:GetOriginalCode()
        local token=Duel.CreateToken(tp,ac)
        if tc:IsLocation(LOCATION_DECK) then
            Duel.SendtoDeck(token,tp,SEQ_DECKBOTTOM,REASON_RULE)
        elseif tc:IsLocation(LOCATION_HAND) then
            Duel.SendtoHand(token,tp,REASON_RULE)
        elseif tc:IsLocation(LOCATION_ONFIELD) then
            local q=tc:GetPosition()
            local w=tc:GetSequence()
            local a=false
            if tc:IsFaceup() then
                a=true
            end
            if tc:IsLocation(LOCATION_MZONE) then
                Duel.MoveToField(token,tp,tp,LOCATION_MZONE,q,a,w)
            else
                Duel.MoveToField(token,tp,tp,LOCATION_SZONE,q,a,w)
            end
        elseif tc:IsLocation(LOCATION_GRAVE) then
            Duel.SendtoGrave(token,REASON_RULE)
        elseif tc:IsLocation(LOCATION_EXTRA) then
            if tc:IsFaceup() then
                Duel.SendtoExtraP(token,nil,REASON_RULE)
            else
                Duel.SendtoDeck(token,tp,SEQ_DECKBOTTOM,REASON_RULE)
            end
        elseif tc:IsLocation(LOCATION_REMOVED) then
            local q=tc:GetPosition()
            Duel.Remove(token,q,REASON_RULE)
        end
        if tc:GetOverlayGroup()~=nil then
            local g3=tc:GetOverlayGroup()
            for tz in aux.Next(g3) do
                local az=tz:GetOriginalCode()
                local token2=Duel.CreateToken(tp,az)
                Duel.SendtoDeck(token2,tp,SEQ_DECKBOTTOM,REASON_RULE)
                Duel.Overlay(token,token2)
            end
        end
    end
    --[[
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(2)
	Duel.RegisterEffect(e3,tp)
    ]]--
    g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil)
    Duel.ConfirmCards(tp,g)
end
