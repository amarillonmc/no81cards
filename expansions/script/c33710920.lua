--组装融合
function c33710920.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33710920.target)
	e1:SetOperation(c33710920.activate)
	c:RegisterEffect(e1)
end
function c33710920.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsLocation(LOCATION_HAND) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c33710920.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and m:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99,c) and not c:IsType(TYPE_EFFECT)
end
function c33710920.filter3(g,tp,c,e)
	return g:GetSum(Card.GetLevel)==c:GetLevel() and c:IsAbleToRemove()
end
function c33710920.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(c33710920.filter1,nil,e)
		local res=Duel.IsExistingMatchingCard(c33710920.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33710920.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(c33710920.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c33710920.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	if sg1:GetCount()>0 then
		local sg=sg1:Clone()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local c=e:GetHandler()
		if sg1:IsContains(tc) then
			local mat1=mg1:SelectSubGroup(tp,c33710920.filter3,true,1,mg1:GetCount(),tp,tc,e)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCategory(CATEGORY_ATKCHANGE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(mat1:GetSum(Card.GetAttack))   
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetCategory(CATEGORY_ATKCHANGE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(mat1:GetSum(Card.GetDefense))   
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_DISABLE)
			e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1_1)
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_DISABLE_EFFECT)
			e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2_1)
		end
		Duel.SpecialSummonComplete()
	end
end