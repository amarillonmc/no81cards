--幻龙兽 林德虫
local s,id,o=GetID()
function s.initial_effect(c)
    --Destroy and Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
    --ToGrave(0x10)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.recon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_TO_GRAVE)
    c:RegisterEffect(e3)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0x04,0x04,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x02,0,1,nil,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0x04,0x04,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.thfilter(c)
	return c:IsSetCard(0x40a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)>0 and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and tc:IsSetCard(0x40a) then
        local g=Duel.GetMatchingGroup(s.thfilter,tp,0x01,0,nil)
        if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.Hint(3,tp,506)
            local sg=g:Select(tp,1,1,nil)
            Duel.SendtoHand(sg,nil,0x40)
            Duel.ConfirmCards(1-tp,sg)
        end
	end
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	return re and bit.band(r,REASON_EFFECT)==REASON_EFFECT
        and re:GetHandler():IsSetCard(0x40a)
end
function s.tgfilter(c)
	return c:IsSetCard(0x40a) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsCode(id)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,0x01,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,504)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,0x01,0,1,1,nil)
	if #g>0 then Duel.SendtoGrave(g,0x40) end
end