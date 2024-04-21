--超量坍缩
function c11561045.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c11561045.target)
	e1:SetOperation(c11561045.activate)
	c:RegisterEffect(e1)
end
function c11561045.filter1(c,e,tp)
	local rk=c:GetRank()  
	return not c:IsSetCard(0x48) and rk>0 and c:IsFaceup() and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(c11561045.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c11561045.filter2(c,e,tp,mc) 
	return c:IsRank(math.ceil(mc:GetRank()/2)) and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,TYPE_XYZ)>=2 and Duel.IsExistingMatchingCard(c11561045.filter3,tp,LOCATION_EXTRA,0,1,c,e,tp,mc)
end
function c11561045.filter3(c,e,tp,mc) 
	return c:IsRank(math.ceil(mc:GetRank()/2)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
end
function c11561045.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c11561045.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and e:GetHandler():IsCanOverlay() and (e:IsHasType(EFFECT_TYPE_ACTIVATE) or e:GetHandler():IsLocation(LOCATION_ONFIELD)) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11561045.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11561045.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end 
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c11561045.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst() 
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure() 
		if Duel.IsExistingMatchingCard(c11561045.filter3,tp,LOCATION_EXTRA,0,1,sc,e,tp,tc) then 
			local xc=Duel.SelectMatchingCard(tp,c11561045.filter3,tp,LOCATION_EXTRA,0,1,1,sc,e,tp,tc):GetFirst()
			Duel.SpecialSummon(xc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			xc:CompleteProcedure() 
			if c:IsRelateToEffect(e) then
				c:CancelToGrave()
				Duel.Overlay(xc,Group.FromCards(c))
			end 
			Duel.BreakEffect() 
			local sg=Group.FromCards(sc,xc) 
			local tc1=sg:Select(tp,1,1,nil):GetFirst()
			Duel.NegateRelatedChain(tc1,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc1:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc1:RegisterEffect(e2)
			local tc2=sg:Filter(aux.TRUE,tc1):GetFirst() 
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(0)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e3)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_DEFENSE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(0)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e3)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e3)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL) 
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e3)
		end 
	end 
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(0,1)
		e3:SetValue(0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end 
end

