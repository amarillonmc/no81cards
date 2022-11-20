--武器冢
function c10174003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetDescription(aux.Stringid(10174003,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetTarget(c10174003.target)
	e1:SetOperation(c10174003.activate)
	c:RegisterEffect(e1)	
	--equip change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10174003,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c10174003.eqtg)
	e2:SetOperation(c10174003.eqop)
	c:RegisterEffect(e2)
end
function c10174003.eqfilter1(c,tp)
	return c:IsFaceup()
		and Duel.IsExistingTarget(c10174003.eqfilter2,tp,LOCATION_GRAVE,0,1,nil,c)
end
function c10174003.eqfilter2(c,ec)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c10174003.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10174003.eqfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c10174003.eqfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g1:GetFirst()
	e:SetLabelObject(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectTarget(tp,c10174003.eqfilter2,tp,LOCATION_GRAVE,0,1,1,nil,tc)
end
function c10174003.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==ec then tc=g:GetNext() end
	if ec:IsFaceup() and ec:IsRelateToEffect(e) and tc:CheckEquipTarget(ec) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,tc,ec)
	end
end
function c10174003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end
function c10174003.tgfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c10174003.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c10174003.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10174003,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,3,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end