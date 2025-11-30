--飓风海劫“饵钓”和睦号
local s,id,o=GetID()
function s.initial_effect(c)
    --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
    e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --ToHand(0x0c)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))  
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_HAND) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1)
	e2:SetCondition(s.thcon)  
	e2:SetTarget(s.thtg) 
	e2:SetOperation(s.thop) 
	c:RegisterEffect(e2)
    --Tohand(0x01)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.scon)
	e3:SetTarget(s.stg)
	e3:SetOperation(s.sop)
	c:RegisterEffect(e3)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>0 and Duel.GetFlagEffect(tp,id)==0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,EFFECT_FLAG_OATH,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tckfil(c,tp) 
	return c:IsControler(1-tp)
        and not c:IsReason(REASON_DRAW)  
end 
function s.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(s.tckfil,1,nil,tp)  
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0x0c,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,0x0c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(3,tp,505)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0x0c,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,0x40)
    end
end
function s.thfi2ter(c,e,tp,check)
	return c:IsSetCard(0x540b) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_FIRE)
        and (c:IsAbleToHand() or (check and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousPosition(POS_FACEUP)
end
function s.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local c,check=e:GetHandler(),Duel.GetFieldGroupCount(tp,0x04,0)==0
        if c:IsLocation(0x02) and c:GetFlagEffect(id)==0 then
            c:RegisterFlagEffect(id,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
        end
        return Duel.IsExistingMatchingCard(s.thfi2ter,tp,0x01,0,1,nil,e,tp,check)
            and Duel.GetFlagEffect(tp,id)==0
    end
    Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,EFFECT_FLAG_OATH,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
    local check=Duel.GetFieldGroupCount(tp,0x04,0)==0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfi2ter,tp,0x01,0,1,1,nil,e,tp,check)
	if g:GetCount()>0 then
        local tc=g:GetFirst()
        if check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        else 
		    Duel.SendtoHand(tc,nil,REASON_EFFECT)
            if tc:IsLocation(0x02) then
		        Duel.ConfirmCards(1-tp,g)
            end
        end
	end
end