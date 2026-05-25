--梅加特伦机车连结
function c37730061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37730061)
	e1:SetTarget(c37730061.target)
	e1:SetOperation(c37730061.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c37730061.eqtg)
	e2:SetOperation(c37730061.eqop)
	c:RegisterEffect(e2)
end
c37730061.has_text_type=TYPE_UNION
function c37730061.thfilter(c,chk)
	return c:IsSetCard(0x2af) and c:GetType()~=TYPE_SPELL and c:IsAbleToHand()
end
function c37730061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37730061.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c37730061.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c37730061.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	--Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	--if not tc:IsLocation(LOCATION_HAND) or not Duel.SelectYesNo(tp,aux.Stringid(37730061,2)) then return end
end
function c37730061.tfilter(c,tp)
	return c:IsType(TYPE_UNION) and c:IsFaceup() and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c37730061.eqfilter(c)
	return c:IsSetCard(0x2af) and c:IsFaceup()
end
function c37730061.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c37730061.tfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c37730061.tfilter,tp,LOCATION_REMOVED,0,1,nil,tp) and Duel.IsExistingMatchingCard(c37730061.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c37730061.tfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
end
function c37730061.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sc=Duel.SelectMatchingCard(tp,c37730061.eqfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		if sc and Duel.Equip(tp,tc,sc) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(sc)
			e1:SetValue(c37730061.eqlimit)
			tc:RegisterEffect(e1)
		end
	end
end
function c37730061.eqlimit(e,c)
	return e:GetLabelObject()==c
end
