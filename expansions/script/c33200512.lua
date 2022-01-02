--逆转检事 戈多
function c33200512.initial_effect(c)
	aux.AddCodeList(c,33200500)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c33200512.xyzfilter,6,2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200512,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,33200512)
	e1:SetCondition(c33200512.thcon)
	e1:SetTarget(c33200512.thtg)
	e1:SetOperation(c33200512.thop)
	c:RegisterEffect(e1) 
	--immu
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c33200512.con)
	e2:SetTarget(c33200512.imtg)
	e2:SetValue(c33200512.efilter)
	c:RegisterEffect(e2)
	--TZ times
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200512,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,33200513)
	e3:SetCost(c33200512.cost)
	e3:SetOperation(c33200512.twop)
	c:RegisterEffect(e3)
end

--xyz
function c33200512.xyzfilter(c)
	return aux.IsCodeListed(c,33200500)
end

--e1
function c33200512.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33200512.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return g:FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c33200512.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsAbleToHand,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			if Duel.SendtoHand(sg,nil,REASON_EFFECT) then 
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(33200512,0)) then
					local desg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
					local tc=desg:GetFirst()
					Duel.Destroy(tc,REASON_EFFECT)
				end
			end
		end
	end
end

--e2
function c33200512.con(e,c)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsFaceup() 
end
function c33200512.imtg(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(33200500)>=1 and c:IsLocation(LOCATION_ONFIELD)
end
function c33200512.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--e3
function c33200512.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33200512.twop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,33200503,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c33200512.tdop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e:GetHandler():RegisterEffect(e1)
end
function c33200512.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end