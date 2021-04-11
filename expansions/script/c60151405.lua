--LUKA Relaxing Time
function c60151405.initial_effect(c)
	--sp
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151401,0))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,60151405)
    e1:SetCost(c60151405.spcost)
    e1:SetTarget(c60151405.sptg)
    e1:SetOperation(c60151405.spop)
    c:RegisterEffect(e1)
	--to deck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151401,1))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c60151405.spcon2)
    e2:SetCost(c60151405.spcost2)
    e2:SetTarget(c60151405.sptg2)
    e2:SetOperation(c60151405.spop2)
    c:RegisterEffect(e2)
	--sp success
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151405,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,6011405)
    e3:SetCost(c60151405.spcost)
    e3:SetTarget(c60151405.sptg3)
    e3:SetOperation(c60151405.spop3)
    c:RegisterEffect(e3)
end
function c60151405.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,6011405)==0 end
	Duel.RegisterFlagEffect(tp,6011405,RESET_CHAIN,0,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151405.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.GetMZoneCount(tp)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g1=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60151405.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
        local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
    end
end
function c60151405.tfilter(c,tp)
    return c:IsLocation(LOCATION_ONFIELD)
end
function c60151405.spcon2(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c60151405.tfilter,1,nil,tp)
end
function c60151405.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>-1
        and e:GetHandler():IsFaceup() 
		and e:GetHandler():IsAbleToDeck() 
		and Duel.GetFlagEffect(tp,60151405)==0 
		and Duel.GetFlagEffect(tp,6011405)==0 end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	Duel.RegisterFlagEffect(tp,60151405,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,6011405,RESET_CHAIN,0,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151405.filter(c,e,tp)
    return c:IsSetCard(0x3b28) and not c:IsCode(60151405) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151405.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151405.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60151405.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetMZoneCount(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60151405.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c60151405.xyzfilter(c)
    return c:IsXyzSummonable(nil)
end
function c60151405.sptg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToDeck() and chkc~=e:GetHandler() end
    if chk==0 then return (Duel.IsExistingMatchingCard(c60151405.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) 
		or Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)) 
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g1=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60151405.spop3(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
    local g2=Duel.GetMatchingGroup(c60151405.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
        local op=Duel.SelectOption(tp,aux.Stringid(60151405,3),aux.Stringid(60151405,4))
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g1:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
			local tc=Duel.GetFirstTarget()
			if tc and tc:IsRelateToEffect(e) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g2:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
			local tc=Duel.GetFirstTarget()
			if tc and tc:IsRelateToEffect(e) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
		end
	elseif g1:GetCount()>0 then
		local op=Duel.SelectOption(tp,aux.Stringid(60151405,3))
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g1:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
			local tc=Duel.GetFirstTarget()
			if tc and tc:IsRelateToEffect(e) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
		end
	else
		local op=Duel.SelectOption(tp,aux.Stringid(60151405,4))
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g2:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
			local tc=Duel.GetFirstTarget()
			if tc and tc:IsRelateToEffect(e) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
		end
    end
end