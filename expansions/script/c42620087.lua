--魔偶甜点盛筵
local cm,m=GetID()

function cm.initial_effect(c)
	--th
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg2)
	e1:SetOperation(cm.thop2)
	c:RegisterEffect(e1)
    --tograve
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetTarget(cm.reptg)
	e4:SetValue(cm.repval)
	c:RegisterEffect(e4)
end

function cm.tgsfilter(c)
    return c:IsSetCard(0x71) and c:IsType(0x1) and c:IsAbleToHand() and c:IsFaceup()
end

function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    if Duel.IsExistingTarget(cm.tgsfilter,tp,0x20,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        e:SetCategory(e:GetCategory()|CATEGORY_TOHAND)
        e:SetProperty(e:GetProperty()|EFFECT_FLAG_CARD_TARGET)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
        local tc=Duel.SelectTarget(tp,cm.tgsfilter,tp,0x20,0,1,1,nil):GetFirst()
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,nil,nil)
    end
end

function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToChain() then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end

function cm.repfilter(c,e,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:GetDestination()==LOCATION_DECK and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 and bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x71) and eg:IsExists(cm.repfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,0x04)>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x02,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_CARD,0,m)
        Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
        Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil)
		local g=eg:Filter(cm.repfilter,nil,e,tp)
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=g:Select(tp,1,1,nil)
		end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		e:SetLabelObject(g)
		return true
	else return false end
end

function cm.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end