--致以辉煌的人们
function c79200024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCountLimit(1,79200024+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c79200024.condition)
	e1:SetCost(c79200024.cost)
	e1:SetTarget(c79200024.target)
	e1:SetOperation(c79200024.activate)
	c:RegisterEffect(e1)
end
function c79200024.cfilter(c)
	return c:IsCode(79200020)
end
function c79200024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79200024.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c79200024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c79200024.zlzjy,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local cg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,c,POS_FACEDOWN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc=Duel.SelectMatchingCard(tp,c79200024.zlzjy,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	cg:Sub(sc)
	Duel.ConfirmCards(1-tp,sc)
	Duel.Remove(cg,POS_FACEDOWN,REASON_COST)
	local bg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)
	if bg:GetCount()>0 and Duel.SendtoGrave(bg,REASON_COST+REASON_RETURN) then
		Duel.Remove(bg,POS_FACEDOWN,REASON_COST)
	end
	sc:CreateEffectRelation(e)
	e:SetLabelObject(sc)
 
end
function c79200024.zlzjy(c,e,tp)
	return c:IsCode(79200023) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c79200024.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c79200024.zlzjy,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79200024.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	if Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)~=0 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ADD_SETCODE)
		e4:SetValue(0x683)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(79200024,1))
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e5:SetValue(c79200024.efilter)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e5,true)
	end
end
function c79200024.efilter(e,te)
	return not (te:GetOwner():IsSetCard(0x683) or te:GetOwner():IsType(TYPE_MONSTER))
end