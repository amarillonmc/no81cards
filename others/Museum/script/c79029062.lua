--龙门·狙击干员-白雪
function c79029062.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029062+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c79029062.hspcon)
	e1:SetOperation(c79029062.hspop)
	c:RegisterEffect(e1)   
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029062,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,09029062)
	e1:SetTarget(c79029062.thtg)
	e1:SetOperation(c79029062.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c79029062.spfilter(c,ft)
	return c:IsSetCard(0xa900) and c:IsAbleToRemoveAsCost() and ((ft>0 or c:GetSequence()<5) or c:IsLocation(LOCATION_GRAVE))
end
function c79029062.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c79029062.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,ft)
end
function c79029062.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c79029062.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,ft)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Debug.Message("风雪将掩埋这片战场。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029062,0))
end
function c79029062.filter(c)
	return c:IsSetCard(0x1905) and (c:IsAbleToHand() or c:IsAbleToRemove())
end
function c79029062.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029062.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c79029062.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c79029062.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1190,1192)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	Debug.Message("准备。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029062,1))
	else
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	Debug.Message("行动开始。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029062,2))
	end
end

