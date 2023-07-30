--战械人形 M4A1
function c29065600.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065600,1))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c29065600.eqtg)
	e1:SetOperation(c29065600.eqop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065600,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c29065600.rettg)
	e2:SetOperation(c29065600.retop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c29065600.eftg1)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--effect gain xyz
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c29065600.eftg2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c29065600.eqfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and not c:IsForbidden()
end
function c29065600.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c29065600.eqfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
end
function c29065600.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c29065600.eqfil,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c29065600.eqlimit)
		tc:RegisterEffect(e1)
			local g1=Duel.GetMatchingGroup(c29065600.thfilter,tp,LOCATION_DECK,0,nil)
			if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29065600,2)) then
			local hg=g1:Select(tp,1,1,nil)
			Duel.SendtoHand(hg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	end
end
function c29065600.thfilter(c)
	return c:IsLevel(4) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x87ad) and c:IsAbleToHand()
end
function c29065600.eftg1(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsSetCard(0x7ad) and not c:IsType(TYPE_XYZ)
end
function c29065600.eftg2(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsSetCard(0x7ad) and c:IsType(TYPE_XYZ)
end
function c29065600.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,1-tp,LOCATION_MZONE)
end
function c29065600.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c29065600.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c29065600.eqlimit(e,c)
	return e:GetOwner()==c 
end
