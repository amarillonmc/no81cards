--深海猎人狩猎
function c29004690.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,29004690+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29004690.destg)
	e1:SetOperation(c29004690.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c29004690.handcon)
	c:RegisterEffect(e2)
	--"Arknights-Specter the Unchained":ACTIVATE FROM GRAVE
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,29063234)
	e3:SetCost(c29004690.descost)
	e3:SetCondition(c29004690.descon)
	e3:SetTarget(c29004690.destg)
	e3:SetOperation(c29004690.desop1(c29004690.desop))
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
function c29004690.desop1(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
				op(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				c:CancelToGrave()
				Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
			end
end
function c29004690.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,29063234) and e:GetLabelObject():CheckCountLimit(tp)
end
function c29004690.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
end
function c29004690.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29004690.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH) and c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER)
end
function c29004690.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29004690.filter,tp,LOCATION_MZONE,0,nil)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 and g:GetClassCount(Card.GetCode)<3 and g1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
				if #g2>0 then
					Duel.HintSelection(g2)
					Duel.Destroy(g2,REASON_EFFECT)
				end
		elseif g:GetClassCount(Card.GetCode)>=3 and g1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,g:GetCount(Card.GetCode),nil)
				if #g2>0 then
					Duel.HintSelection(g2)
					Duel.Destroy(g2,REASON_EFFECT)
				end
		end
end
function c29004690.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c29004690.handcon(e)
	return Duel.IsExistingMatchingCard(c29004690.cfilter,0,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c29004690.cfilter,1,LOCATION_MZONE,0,1,nil)
end