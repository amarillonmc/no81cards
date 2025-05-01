--极彩蛇的腹辙
local s,id,o=GetID()
function s.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.desfilter(c)
	return c:GetSequence()<5 and c:IsAbleToGrave()
end
function s.ctrfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc20) and c:IsControlerCanBeChanged()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(s.ctrfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,tp,LOCATION_MZONE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local seq=tc:GetSequence()
		if Duel.SendtoGrave(tc,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_GRAVE) then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local sg=Duel.SelectMatchingCard(tp,s.ctrfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if #sg<=0 then return end
		local sc=sg:GetFirst()
		if Duel.GetControl(sc,1-tp,PHASE_END,1,1<<seq)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_SUM)
			sc:RegisterEffect(e2)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			sc:RegisterEffect(e2)
		end
	end
end
