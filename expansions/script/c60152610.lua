--皇家吉祥物的鼓舞
function c60152610.initial_effect(c)
	--spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152610,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,60152610+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c60152610.e1tar)
    e1:SetOperation(c60152610.e1op)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60152610,2))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c60152610.e2tg)
    e2:SetOperation(c60152610.e2op)
    c:RegisterEffect(e2)
end
function c60152610.e1tarfilter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x6b27) and Duel.IsExistingMatchingCard(c60152610.e1tarfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c60152610.e1tarfilter2(c,e,tp,code)
    return c:IsSetCard(0x6b27) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c60152610.e1tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c60152610.e1tarfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c60152610.e1tarfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local g=Duel.SelectTarget(tp,c60152610.e1tarfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60152610.e1opfilter(c)
    return c:IsSetCard(0x6b27) and c:IsType(TYPE_MONSTER)
end
function c60152610.e1op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60152610.e1tarfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
    if g:GetCount()>0 then
		if tc:GetColumnGroupCount()==0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			local g=Duel.GetMatchingGroup(c60152610.e1opfilter,tp,LOCATION_GRAVE,0,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60152610,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local sg=g:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
			end
		else
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
    end
end
function c60152610.e2tgfilter(c,e,tp)
    return c:IsSetCard(0x6b27) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c60152610.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60152610.e2tgfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c60152610.e2op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60152610.e2tgfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2,true)
        local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e4:SetValue(0)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4,true)
    end
    Duel.SpecialSummonComplete()
end