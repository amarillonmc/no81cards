--十七驱 浦风
local s,id,o=GetID()
function s.initial_effect(c)
    --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
    --ThAndSum(0x10)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.thfilter(c)
	return c:IsSetCard(0x340b) and c:IsLevelBelow(3) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,0x01,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,0x01,0,nil)
	if #g>0 then
        Duel.Hint(3,tp,506)
        local tc=g:Select(tp,1,1,nil)
        Duel.SendtoHand(tc,nil,0x40)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.tgfi2ter(c,tp)
	return c:IsPreviousLocation(0x06) and c:IsLocation(0x10)
        and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
        and c:GetOriginalType()&TYPE_MONSTER>0
end
function s.tsfi1ter(c,e,tp,tc)
	return s.tgfi2ter(c,tp) and c:IsCanBeEffectTarget(e)
        and ((c:IsAbleToHand() and tc:IsCanBeSpecialSummoned(e,0,tp,false,false))
        or (c:IsSetCard(0x340b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsAbleToHand()))
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.tgfi2ter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local gg=eg:Filter(s.tsfi1ter,nil,e,tp,e:GetHandler())
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>0 and #gg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local sg=gg:Select(tp,1,1,nil)
	local g=Duel.SetTargetCard(sg)
    sg:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function s.tsfi2ter(c,e,tp)
	return c:IsAbleToHand() or (c:IsSetCard(0x340b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.spfi1ter(c,e,tp)
	return c:IsSetCard(0x340b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	local stg=Group.FromCards(tc,c)
    local g=stg:Filter(Card.IsRelateToEffect,nil,e)
    if #g==2 then
        local pg=g:Filter(s.spfi1ter,nil,e,tp)
        if #pg>0 then
            local sc=pg:GetFirst()
            if #pg>1 then
                Duel.Hint(3,tp,509)
                sc=pg:Select(tp,1,1,nil):GetFirst()
            end
            if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
                local e1=Effect.CreateEffect(c)
			    e1:SetType(EFFECT_TYPE_SINGLE)
			    e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			    e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			    e1:SetValue(LOCATION_REMOVED)
			    sc:RegisterEffect(e1)
                Duel.SpecialSummonComplete()
                g:RemoveCard(sc)
                if Duel.SendtoHand(g,nil,0x40)>0 then
                    local hg=g:Filter(Card.IsLocation,nil,0x02)
                    if #hg>0 then Duel.ConfirmCards(1-tp,hg) end
                end
            end
        end
    end
end