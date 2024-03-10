--试胆竞猜
local m=16670021
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
end
function cm.f(c,ac)
	return c:IsCode(ac)
end
function cm.f2(c,ac)
	return c:IsCode(ac) and c:IsAbleToDeck()
end
function cm.f3(c,ac)
	return c:IsCode(ac) and c:IsAbleToHand()
end
function cm.f4(c,ac)
	return c:IsAbleToDeck()
end
function cm.bantg(e,c)
	local fcode=e:GetLabel()
	return c:IsOriginalCodeRule(fcode)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
		Duel.SetChainLimit(aux.FALSE)
end
function cm.handcon(e)
    local c=e:GetHandler()
    local fcode=e:GetLabel()
	return c:IsCode(fcode)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SetChainLimit(aux.FALSE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,0,0)
    Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local op=Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1))
    --Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,op+3))
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
    Duel.ConfirmCards(1-tp,g)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
    if Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_HAND,0,1,nil,ac) and op==0 then
        local g2=Duel.GetMatchingGroup(cm.f2,tp,LOCATION_HAND,0,nil,ac)
        Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetCode(EFFECT_FORBIDDEN)
        e2:SetTargetRange(0xff,0)
        e2:SetTarget(cm.bantg)
        e2:SetLabel(ac)
        e2:SetReset(RESET_OPPO_TURN+RESET_SELF_TURN,2)
        Duel.RegisterEffect(e2,tp)
    elseif Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_HAND,0,1,nil,ac) and op==1 then
        Duel.Draw(tp,2,REASON_EFFECT)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAINING)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCondition(cm.handcon)
        e1:SetOperation(cm.chainop)
        e1:SetLabel(ac)
        c:RegisterEffect(e1)
    elseif not Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_HAND,0,1,nil,ac) and op==0 then
        local g2=Duel.GetMatchingGroup(cm.f3,tp,LOCATION_DECK,0,nil,ac)
        local t=g2:Select(tp,1,1,nil)
        Duel.SendtoHand(t,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,t)
    elseif not Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_HAND,0,1,nil,ac) and op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g2=Duel.GetMatchingGroup(cm.f4,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,ac)
        if g2~=nil then
            local t=g2:Select(tp,1,1,nil)
            Duel.SendtoDeck(t,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        end
    end
end
