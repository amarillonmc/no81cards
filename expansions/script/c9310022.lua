--红帽单调士
function c9310022.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9310022+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c9310022.spcon1)
	e1:SetTarget(c9310022.destg)
	e1:SetOperation(c9310022.desop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetCondition(c9310022.indcon)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9310022.splimit)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetCondition(c9310022.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--To hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,9311022)
	e4:SetCondition(c9310022.spcon2)
	e4:SetTarget(c9310022.sptg)
	e4:SetOperation(c9310022.spop)
	c:RegisterEffect(e4)
end
function c9310022.cfilter(c)
	return c:IsFacedown() or not c:IsLevelAbove(0)
end
function c9310022.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9310022.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9310022.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
		or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	local g2=Duel.GetDecktopGroup(tp,1)
	local sg=g1:Clone()
	sg:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9310022.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	local g2=Duel.GetDecktopGroup(tp,1)
	local sg=g1:Clone()
	sg:Merge(g2)
	if sg:GetCount()>0 then
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		if (tc:IsAttack(1950) and tc:IsRace(RACE_BEASTWARRIOR)) or aux.AtkEqualsDef(tc) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c9310022.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	local b1=Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	local op=2
	e:SetCategory(0)
	if Duel.GetFlagEffect(tp,9310022)==0 and (b1 or b2) then
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(9310022,1),aux.Stringid(9310022,2))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(9310022,1))
		else
			op=Duel.SelectOption(tp,aux.Stringid(9310022,2))+1
		end
		if op==0 then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
		else
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
		Duel.RegisterFlagEffect(tp,9310022,RESET_PHASE+PHASE_END,0,1)
	end
	e:SetLabel(op)
end
function c9310022.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==2 or not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
		if g1:GetCount()>0 then
			Duel.Destroy(g1,REASON_EFFECT)
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	else
		local g2=Duel.GetDecktopGroup(tp,1)
		if g2:GetCount()>0 then
			local kc=g2:GetFirst()
			Duel.Destroy(kc,REASON_EFFECT)
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			if (kc:IsAttack(1950) and kc:IsRace(RACE_BEASTWARRIOR)) or aux.AtkEqualsDef(kc) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
function c9310022.indcon(e)
	return e:GetHandler():IsDefensePos()
end
function c9310022.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c9310022.tnval(e,c)
	return e:GetHandler():IsDefensePos()
end
function c9310022.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY)
end
function c9310022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9310022.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetCountLimit(1)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end