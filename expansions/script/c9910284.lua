--星幽研究员
function c9910284.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c9910284.lcheck)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c9910284.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910284,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,9910284)
	e2:SetCondition(c9910284.setcon)
	e2:SetTarget(c9910284.settg)
	e2:SetOperation(c9910284.setop)
	c:RegisterEffect(e2)
end
function c9910284.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3957)
end
function c9910284.indtg(e,c)
	return e:GetHandler()==c or (c:IsType(TYPE_PENDULUM) and e:GetHandler():GetLinkedGroup():IsContains(c))
end
function c9910284.cfilter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsFacedown()
end
function c9910284.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910284.cfilter,1,nil)
end
function c9910284.setfilter(c)
	return c:IsSetCard(0x3957) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9910284.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910284.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910284.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c9910284.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c9910284.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)~=0 then
		local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(9910284,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local tg=g:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			local sc=tg:GetFirst()
			Duel.NegateRelatedChain(sc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			sc:RegisterEffect(e2)
			if sc:IsType(TYPE_TRAPMONSTER) then
				local e3=e1:Clone()
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				sc:RegisterEffect(e3)
			end
		end
	end
end
