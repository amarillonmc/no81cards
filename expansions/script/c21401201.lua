--血魔大君的赐福
local cid = c21401201
local id = 21401201
cid.SetCard_Sanguinarch=true 
function cid.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	--protect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+114514)
	e2:SetCondition(cid.tdcon)
	e2:SetTarget(cid.tdtg)
	e2:SetOperation(cid.tdop)
	c:RegisterEffect(e2)
end

function cid.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function cid.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end

function cid.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end

function cid.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,21401200))
		e1:SetValue(cid.efilter)
		if Duel.GetCurrentPhase()==PHASE_MAIN1 then
			e1:SetReset(RESET_PHASE+PHASE_MAIN1)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_MAIN1,0,1)
		else
			e1:SetReset(RESET_PHASE+PHASE_MAIN2)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_MAIN2,0,1)
		end
		Duel.RegisterEffect(e1,tp)
		
	end
end

function cid.tgfilter(c)
	return c:IsFaceup()
end

function cid.eqfilter(c)
	if c:IsLocation(LOCATION_DECK) then
		return c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:IsSetCard(0x8e)
	else
		return c:IsType(TYPE_MONSTER) and not c:IsForbidden() 
	end
end

function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cid.tgfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(cid.eqfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,cid.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function cid.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Recover(tp,atk,REASON_EFFECT)
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,cid.eqfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			local sc=g:GetFirst()
			if not sc then return end
			if not Duel.Equip(tp,sc,tc) then return end
			--Add Equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cid.eqlimit)
			e1:SetLabelObject(tc)
			sc:RegisterEffect(e1)
			--control
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_SET_CONTROL)
			e2:SetValue(tp)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			--banish
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_EQUIP)
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			sc:RegisterEffect(e3)
		end
	end
end
