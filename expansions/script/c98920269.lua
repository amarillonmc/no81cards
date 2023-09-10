--黑羽-阴风之帕森
function c98920269.initial_effect(c)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920269,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920269)
	e1:SetCondition(c98920269.spcon)
	e1:SetTarget(c98920269.sptg)
	e1:SetOperation(c98920269.spop)
	c:RegisterEffect(e1)
end
function c98920269.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x33)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.IsExistingMatchingCard(c98920269.filter2,tp,LOCATION_HAND,0,1,nil,tp,lv)
end
function c98920269.filter2(c,tp,lv)
	local rlv=lv-3
	local rg=Duel.GetMatchingGroup(c98920269.filter3,tp,LOCATION_DECK,0,c)
	return rlv>0 and c:IsCode(98920269) and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,63)
end
function c98920269.filter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsSetCard(0x33)
end
function c98920269.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c98920269.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920269.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920269.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c98920269.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local lv=g1:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=e:GetHandler()
	local rlv=lv-3
	local rg=Duel.GetMatchingGroup(c98920269.filter3,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,63)
	g3:AddCard(e:GetHandler())
	Duel.SendtoGrave(g3,REASON_EFFECT)
	g1:GetFirst():SetMaterial(nil)
	local tc=g1:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		tc:RegisterFlagEffect(98920269,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCondition(c98920269.descon)
		e2:SetOperation(c98920269.desop)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetCountLimit(1)
		e2:SetLabel(Duel.GetTurnCount())
		e2:SetLabelObject(tc)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.SpecialSummonComplete()
	g1:GetFirst():CompleteProcedure()
	local at=Duel.GetAttacker()
	if at:IsAttackable() and not at:IsImmuneToEffect(e) then
	   Duel.CalculateDamage(at,g1:GetFirst())
	end
end
function c98920269.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(98920269)~=0
end
function c98920269.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end