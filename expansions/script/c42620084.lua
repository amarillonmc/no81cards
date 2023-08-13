--魔偶甜点搜索
local cm,m=GetID()

function cm.initial_effect(c)
	--sp
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end

function cm.tgsfilter2(c,e,tp)
    return c:IsSetCard(0x71) and c:IsRace(RACE_FAIRY) and c:IsFaceup()
end

function cm.tgsfilter(c,e,tp)
    return c:IsSetCard(0x71) and c:IsType(0x1) and ((Duel.IsExistingMatchingCard(cm.tgsfilter2,tp,0x04,0,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,0x04)>0) or c:IsAbleToHand())
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x01,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
    local tc=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x01,0,1,1,nil,e,tp):GetFirst()
    if tc then
        if Duel.IsExistingMatchingCard(cm.tgsfilter2,tp,0x04,0,1,nil) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,0x04)>0 and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        else
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        end
    end
end