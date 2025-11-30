--颶風海劫與“復仇”的會面
local s,id,o=GetID()
function s.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --SpSum(0x02)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
    e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
function s.thfi0ter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x540b) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfi0ter,tp,0x31,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
        local tc=sg:GetFirst()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
        if tc:IsLocation(0x02) then
            Duel.ConfirmCards(1-tp,sg)
            local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x02,0,nil)
            if #hg>0 then
                Duel.ShuffleDeck(tp)
                Duel.BreakEffect()
                Duel.Hint(3,tp,507)
                local dc=hg:Select(tp,1,1,nil)
                Duel.SendtoDeck(dc,nil,1,0x40)
            end
        end
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x540b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0x04,0,1,nil,c:GetAttribute())
end
function s.fi6ter(c)
    return c:IsSetCard(0x540b) and c:IsFaceup()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,0x02,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(s.fi6ter,tp,0x04,0,1,nil)
        and Duel.GetLocationCount(tp,0x04)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02)
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)>0 then
	    Duel.Hint(3,tp,509)
	    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,0x02,0,1,1,nil,e,tp)
	    if g:GetCount()>0 then
		    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
	end
end