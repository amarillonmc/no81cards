--颶風海劫“偉大的”王富貴
local s,id,o=GetID()
function s.initial_effect(c)
    --SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
    local e4=e1:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --Indes
    local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0x0c,0)
	e2:SetTarget(s.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
    --ToHand(0x0c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg2)
	e3:SetOperation(s.thop2)
	c:RegisterEffect(e3)
end
--SearchCard
function s.thfilter(c)
	return c:IsSetCard(0x540b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,0x01,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,0x01,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
        local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x02,0,nil)
        if #hg>0 then
            Duel.Hint(3,tp,507)
            local sg=hg:Select(tp,1,1,nil)
            Duel.SendtoDeck(sg,nil,2,0x40)
        end
	end
end
--Indes
function s.target(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
--ToHand
function s.thfi2ter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousPosition(POS_FACEUP)
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(s.thfi2ter,tp,0x0c,0x0c,1,nil) end
	Duel.Hint(3,tp,505)
	local g=Duel.SelectTarget(tp,s.thfi2ter,tp,0x0c,0x0c,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SendtoHand(tc,nil,0x40) end
end