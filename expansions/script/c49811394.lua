--失剑泉
function c49811394.initial_effect(c)
	aux.AddCodeList(c,20188127)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR+RACE_FAIRY),2,true)
   --spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,49811394+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c49811394.hspcon)
	e0:SetOperation(c49811394.hspop)
	c:RegisterEffect(e0)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c49811394.tgtg)
	e1:SetOperation(c49811394.tgop)
	c:RegisterEffect(e1)
	--select
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811394,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c49811394.slcost)
	e2:SetTarget(c49811394.sltg)
	e2:SetOperation(c49811394.slop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49811394,4))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c49811394.eqcon)
	e3:SetCost(c49811394.eqcost)
	e3:SetTarget(c49811394.eqtg)
	e3:SetOperation(c49811394.eqop)
	c:RegisterEffect(e3)
end
function c49811394.matfilter(c)
	return c:IsRace(RACE_WARRIOR+RACE_FAIRY) and c:IsCanBeFusionMaterial() and c:IsAbleToDeckAsCost()
end
function c49811394.hspcon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c49811394.matfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_EQUIP)>=2 and #mg>=2
end
function c49811394.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.SelectMatchingCard(tp,c49811394.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,2,2,nil)
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c49811394.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c49811394.tgfilter(c)
	return c:IsCode(20188127) and c:IsAbleToGrave()
end
function c49811394.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c49811394.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c49811394.slcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c49811394.cfilter(c)
	return c:GetType()&(TYPE_SPELL+TYPE_EQUIP)==TYPE_SPELL+TYPE_EQUIP and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function c49811394.sltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c49811394.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectTarget(tp,c49811394.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c49811394.cpfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not c:IsCode(20188127) then return false end
	local te=c:CheckActivateEffect(false,true,true)
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c49811394.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c49811394.slop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local b1=tc:IsAbleToHand()
	local b2=tc:IsAbleToDeck()
	local op=aux.SelectFromOptions(1-tp,
		{b1,aux.Stringid(49811394,0)},
		{b2,aux.Stringid(49811394,1)})
	if op==1 then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	else
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		if Duel.IsExistingTarget(c49811394.cpfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(49811394,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local cc=Duel.SelectMatchingCard(tp,c49811394.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
			if cc:GetOriginalCode()==20188127 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tc=Duel.SelectTarget(tp,c49811394.thfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1,true)
			else
				local te,ceg,cep,cev,cre,cr,crp=cc:CheckActivateEffect(false,true,true)
				local tg=te:GetTarget()
				local op=te:GetOperation()
				if tg and op then
					tg(e,tp,eg,ep,ev,re,r,rp,1)
					op(e,tp,eg,ep,ev,re,r,rp)
				end
			end
		end
	end
end
function c49811394.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_EQUIP)==0
end
function c49811394.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c49811394.filter(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function c49811394.eqfilter(c,e,tp)
	return c:GetType()&(TYPE_SPELL+TYPE_EQUIP)==TYPE_SPELL+TYPE_EQUIP
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c49811394.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),c)
end
function c49811394.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c49811394.eqfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_HAND)
end
function c49811394.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c49811394.eqfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local eqg=Duel.SelectMatchingCard(tp,c49811394.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc)
		if #eqg>0 then
			Duel.HintSelection(eqg)
			Duel.Equip(tp,tc,eqg:GetFirst())
		end
	end
end
