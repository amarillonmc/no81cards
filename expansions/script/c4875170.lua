function c4875170.initial_effect(c)   
   local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4875170,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,4875170)
    e2:SetTarget(c4875170.attg)
    e2:SetOperation(c4875170.atop)
    c:RegisterEffect(e2)
end
function c4875170.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(rc)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c4875170.chainlm)
	end
end
function c4875170.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
function c4875170.atop(e,tp,eg,ep,ev,re,r,rp)
    local lv=e:GetLabel()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c4875170.filter,tp,LOCATION_DECK,0,nil,lv)
	if	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>8 then
	local g1=Duel.GetMatchingGroup(c4875170.filter1,tp,0,LOCATION_ONFIELD,nil)
	local tc=g1:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g1:GetNext()
	end
	end
end
function c4875170.filter1(c)
	return c:IsFaceup()
end
function c4875170.filter(c,lv)
	return c:IsAttribute(lv)
end