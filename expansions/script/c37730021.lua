--梅加特伦 运载车节
function c37730021.initial_effect(c)
	aux.EnableUnionAttribute(c,c37730021.filter)
	--[[--equip-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37730021,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c37730021.eqstg)
	e1:SetOperation(c37730021.eqsop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37730021,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c37730021.sptg)
	e2:SetOperation(c37730021.spop)
	c:RegisterEffect(e2)]]
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37730021,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetCountLimit(1,37730021+1)
	e3:SetTarget(c37730021.eqtg)
	e3:SetOperation(c37730021.eqop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c37730021.filter(c)
	--local ct1,ct2=c:GetUnionCount()
	return c:IsRace(RACE_MACHINE)-- and c:IsFaceup() and ct2==0
end
function c37730021.thfilter(c,chk)
	return c:IsSetCard(0x2af) and not c:IsCode(37730021) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()-- and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c37730021.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2af) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c37730021.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37730021.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local c=e:GetHandler()
	local te=c:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT)
	if te and te:GetHandler()==c then
		e:SetCategory(CATEGORY_EQUIP+CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_EQUIP)
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c37730021.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sc=Duel.SelectMatchingCard(tp,c37730021.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if sc and Duel.Equip(tp,sc,c) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetLabelObject(c)
			e1:SetValue(c37730021.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			if e:GetLabel()==1 and Duel.IsExistingMatchingCard(c37730021.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(37730021,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tc=Duel.SelectMatchingCard(tp,c37730021.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
function c37730021.eqlimit(e,c)
	return c==e:GetLabelObject()
end
