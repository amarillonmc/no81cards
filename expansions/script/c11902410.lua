--深淵魔影
local s,id,o=GetID()
function s.initial_effect(c)
    --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
    --Remove()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.thfi1ter(c)
    return c:IsSetCard(0x540b) and c:IsFaceup()
        and c:IsAbleToHand()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,0x1c,1,nil,tp,POS_FACEDOWN)
        and Duel.IsExistingMatchingCard(s.thfi1ter,tp,0x04,0,1,nil) end
	Duel.Hint(3,tp,503)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,0x1c,1,1,nil,tp,POS_FACEDOWN)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
    local g=Duel.GetMatchingGroup(s.thfi1ter,tp,0x04,0,nil)
	if #g>0 and tc:IsRelateToEffect(e) then
        Duel.Hint(3,tp,505)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        local sc=sg:GetFirst()
        if Duel.SendtoHand(sc,nil,0x40)>0 and sc:IsLocation(0x02) then
            Duel.Remove(tc,POS_FACEDOWN,0x40)
        end
    end
end