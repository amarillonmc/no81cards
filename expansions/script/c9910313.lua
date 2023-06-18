--神树精灵 木灵
function c9910313.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9910313)
	e1:SetCondition(c9910313.thcon)
	e1:SetTarget(c9910313.thtg)
	e1:SetOperation(c9910313.thop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9910312)
	e2:SetCondition(c9910313.eqcon)
	e2:SetTarget(c9910313.eqtg)
	e2:SetOperation(c9910313.eqop)
	c:RegisterEffect(e2)
end
function c9910313.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c9910313.thfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c9910313.gselect(g)
	return g:GetClassCount(Card.GetControler)==#g
end
function c9910313.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c9910313.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,c9910313.gselect,false,1,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c9910313.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c9910313.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c9910313.eqfilter(c,tp)
	return c:IsSetCard(0x5956) and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and not c:IsCode(9910313)
end
function c9910313.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9910313.eqfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910313.tgfilter(c)
	return c:IsSetCard(0x3956) and c:IsAbleToGrave()
end
function c9910313.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sc=Duel.SelectMatchingCard(tp,c9910313.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not sc or not Duel.Equip(tp,sc,ec) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c9910313.eqlimit)
	e1:SetLabelObject(ec)
	sc:RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(c9910313.tgfilter,tp,LOCATION_DECK,0,nil)
	if c:GetEquipTarget():IsCode(9910301) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910313,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c9910313.eqlimit(e,c)
	return e:GetLabelObject()==c
end
