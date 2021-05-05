--一人千面·亚森
function c40006889.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PSYCHO))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)	
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_LINK))
	e4:SetValue(500)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40006889,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_TO_DECK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,40006889)
	e5:SetCondition(c40006889.thcon)
	e5:SetTarget(c40006889.thtg)
	e5:SetOperation(c40006889.thop)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40006889,1))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1,400068899)
	e6:SetTarget(c40006889.sptgg)
	e6:SetOperation(c40006889.spopp)
	c:RegisterEffect(e6)
end
function c40006889.thfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsSetCard(0xdf1d) and c:IsControler(tp)
end
function c40006889.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40006889.thfilter,1,nil,tp)
end
function c40006889.filter1(c)
	return c:IsSetCard(0xdf1d) and c:IsAbleToHand() and not c:IsCode(40006889)
end
function c40006889.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40006889.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40006889.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40006889.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c40006889.filter2(c,e,tp)
	return c:IsSetCard(0xdf1d) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c40006889.filter3(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetControler()==tp
		and c:IsSetCard(0xdf1d) and c:IsType(TYPE_MONSTER)
end
function c40006889.sptgg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40006889.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c40006889.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c40006889.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c40006889.spopp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c40006889.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc:IsImmuneToEffect(e) then return end
		local g1=Duel.SelectMatchingCard(tp,c40006889.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			local tc2=g1:GetFirst()
			if tc2:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(g1) end
			Duel.Equip(tp,tc2,tc,true,true)
			Duel.EquipComplete()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c40006889.eqlimit2)
			e1:SetLabelObject(tc)
			tc2:RegisterEffect(e1)
		end
	end
end
function c40006889.eqlimit2(e,c)
	return c==e:GetLabelObject()
end