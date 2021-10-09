--假面骑士电王-电车形态
function c9950876.initial_effect(c)
	 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950876,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1,9950876)
	e2:SetTarget(c9950876.sptg)
	e2:SetOperation(c9950876.spop)
	c:RegisterEffect(e2)
  --equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950876,1))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99508761)
	e1:SetTarget(c9950876.eqtg)
	e1:SetOperation(c9950876.eqop)
	c:RegisterEffect(e1)
	--extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950876,2))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1,99508760)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9950876.excost)
	e1:SetOperation(c9950876.exop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950876.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950876.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950876,0))
end 
function c9950876.thfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xbca) and c:IsLevelAbove(5) and not c:IsCode(9950876) and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)
end
function c9950876.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9950876.thfilter(chkc,tp) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c9950876.thfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9950876.thfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9950876.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9950876.filter(c)
	return c:IsSetCard(0x6bcb,0xbca) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9950876.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c9950876.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9950876.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c9950876.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
end
function c9950876.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<sg:GetCount() then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=sg:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9950876.eqlimit)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c9950876.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9950876.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	if ct>3 then ct=3 end
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,ct,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c9950876.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local ct=e:GetLabel()
	if g:GetCount()<ct then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,ct,ct,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950876,4))
end
