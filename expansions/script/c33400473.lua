--鸢一折纸 炮击
function c33400473.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400473,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c33400473.descon)
	e1:SetTarget(c33400473.target)
	e1:SetOperation(c33400473.activate)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400473,1))
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c33400473.eqtg)
	e2:SetOperation(c33400473.eqop)
	c:RegisterEffect(e2)
end
function c33400473.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x5342)
end
function c33400473.desfilter(c,tc,ec)
	return c:GetEquipTarget()~=tc and c~=ec
end
function c33400473.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)   end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c33400473.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c33400473.ckfilter(c)
	return c:IsSetCard(0x5343) and not c:IsForbidden()
end
function c33400473.thfilter(c)
	return c:IsSetCard(0x5343) and c:IsAbleToHand()
end
function c33400473.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return true end
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,0x5343) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,0,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,0,0,0)
end
function c33400473.eqop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,0x5343)
	  then return false end
	local op	
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or (not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x5342)) or (not Duel.IsExistingMatchingCard(c33400473.ckfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)) then 
	op=0 
	elseif not Duel.IsExistingMatchingCard(c33400473.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) then
	op=1
	else
	op=Duel.SelectOption(tp,aux.Stringid(33400473,2),aux.Stringid(33400473,3))
	end 
	local tg
	local tc
	if op==0 then 
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   tg=Duel.SelectMatchingCard(tp,c33400473.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	   Duel.SendtoHand(tg,tp,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		tg=Duel.SelectMatchingCard(tp,c33400473.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		tc=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0x5342)
		local tg1=tg:GetFirst() 
		local tc1=tc:GetFirst()
		Duel.Equip(tp,tg1,tc1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c33400473.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg1:RegisterEffect(e1,true)  
	end  
end
function c33400473.eqlimit(e,c)
	 return true
end