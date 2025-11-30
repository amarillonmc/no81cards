--颶風海劫“溶藥”樸茨茅斯冒險號
local s,id,o=GetID()
function s.initial_effect(c)
    --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --ToHand(0x0c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.con1)
    e2:SetTarget(s.rhtg)
	e2:SetOperation(s.rhop)
	c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCondition(s.con2)
    c:RegisterEffect(e3)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_AQUA)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,0x04,0,1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x540b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,0x04)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
        if g:GetCount()>0 and Duel.GetLocationCount(tp,0x04)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.BreakEffect()
            Duel.Hint(3,tp,509)
            local gh=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
            Duel.SpecialSummon(gh,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function s.cfi2ter(c)
	return c:IsFaceup() and c:IsSetCard(0x540b)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfi2ter,tp,0x04,0,1,e:GetHandler())
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfi2ter,tp,0x04,0,1,e:GetHandler())
end
function s.rhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0x04,0x04,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0x04,0x04,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.rhop(e,tp,eg,ep,ev,re,r,rp)
	local tc,Check=Duel.GetFirstTarget(),false
	if tc:IsRelateToEffect(e) then
        if tc:IsControler(tp) then Check=true end
        if Duel.SendtoHand(tc,nil,0x40)>0 and Check then
            local g=Duel.GetFieldGroup(tp,0,0x0c)
            if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
                Duel.Hint(3,tp,502)
                local sg=g:Select(tp,1,1,nil)
                Duel.HintSelection(sg)
                Duel.Destroy(sg,0x40)
            end
        end
    end
end