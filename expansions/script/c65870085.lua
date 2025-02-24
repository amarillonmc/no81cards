--Protoss·光子炮台
function c65870085.initial_effect(c)
	aux.AddCodeList(c,65870015)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetCondition(c65870085.excondition)
	e3:SetDescription(aux.Stringid(65870085,0))
	c:RegisterEffect(e3)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,65870085+EFFECT_COUNT_CODE_OATH)
	--e0:SetCost(c65870085.cost)
	e0:SetTarget(c65870085.destg1)
	e0:SetOperation(c65870085.desop1)
	c:RegisterEffect(e0)
end

function c65870085.cfilter(c)
	return c:IsCode(65870015) and c:IsFaceup()
end
function c65870085.excondition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65870085.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

function c65870085.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c65870085.desop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.IsExistingMatchingCard(c65870085.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(65870085,1)) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
