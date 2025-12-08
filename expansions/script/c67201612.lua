--童话之复转
function c67201612.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67201612)
	e1:SetCost(c67201612.cost)
	e1:SetTarget(c67201612.target)
	e1:SetOperation(c67201612.activate)
	c:RegisterEffect(e1)  
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201612,0))
	--e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,67201613)
	e3:SetTarget(c67201612.xyztg)
	e3:SetOperation(c67201612.xyzop)
	c:RegisterEffect(e3)  
end
function c67201612.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local spct=0
	if Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,0,1,REASON_COST)
		and Duel.SelectYesNo(tp,aux.Stringid(67201612,1)) then
		spct=Duel.RemoveOverlayCard(tp,LOCATION_MZONE,0,1,1,REASON_COST)
	end
	e:SetLabel(spct)
end
function c67201612.filter11(c,e,tp)
	return c:IsSetCard(0x367f) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67201612.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67201612.filter11,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c67201612.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67201612.filter11,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then  
		local spct=e:GetLabel()
		if spct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(67201612,5))
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetOperation(c67201612.disop)
			e1:SetTargetRange(1,1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c67201612.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if Duel.GetFlagEffect(tp,67201612)==0 and Duel.SelectYesNo(tp,aux.Stringid(67201612,3)) then
		Duel.RegisterFlagEffect(tp,67201612,RESET_PHASE+PHASE_END,0,1)
		Duel.NegateEffect(ev,true)
	end
end
--
function c67201612.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x367f)
end
function c67201612.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67201612.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67201612.filter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c67201612.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c67201612.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) and c:IsCanOverlay() then
		Duel.Overlay(tc,Group.FromCards(c))
		--
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c67201612.thcon2)
		e1:SetOperation(c67201612.thop2)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c67201612.thfilter(c)
	return c:IsSetCard(0x367f) and c:IsAbleToHand()
end
function c67201612.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(c67201612.thfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c67201612.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67201612.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end