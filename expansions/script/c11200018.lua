--地上的月兔 铃仙·优昙华院·因幡
function c11200018.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200018,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,11200018)
	e1:SetTarget(c11200018.tg1)
	e1:SetOperation(c11200018.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11200118)
	e2:SetLabelObject(e1)
	e2:SetTarget(c11200018.tg2)
	e2:SetOperation(c11200018.op2)
	c:RegisterEffect(e2)
--
end
--
c11200018.xig_ihs_0x132=1
--
function c11200018.tfilter1(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,8,rc)
	else return false end
end
function c11200018.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanBeRitualMaterial,c,c)
		local ft=Duel.GetMZoneCount(tp)
		if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
		if ft>0 then
			return mg:CheckWithSumGreater(Card.GetRitualLevel,8,c)
		else
			return mg:IsExists(c11200018.tfilter1,1,nil,tp,mg,c)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
--
function c11200018.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetMZoneCount(tp)
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,8,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c11200018.tfilter1,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,8,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		e:SetLabel(mat:GetCount())
		if not tc:IsRelateToEffect(e) then return end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--
function c11200018.tfilter2(c,e,tp)
	return c.xig_ihs_0x132 and c:IsType(TYPE_SPELL)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT)
end
function c11200018.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rcount=e:GetLabelObject():GetLabel()
	if chk==0 then
		if not e:GetLabelObject() then return false end
		if not e:GetLabelObject():GetLabel() then return false end
		if e:GetLabelObject():GetLabel()<1 then return false end
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200018.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rcount=e:GetLabelObject():GetLabel()
	local dc1,dc2,dc3,dc4,dc5,dc6,dc7,dc8=0
	dc1,dc2,dc3,dc4,dc5,dc6=Duel.TossDice(tp,rcount)
	if rcount>6 then dc7,dc8=Duel.TossDice(tp,rcount-6) end
	local aldc=0
	if dc1 then aldc=aldc+dc1 end
	if dc2 then aldc=aldc+dc2 end
	if dc3 then aldc=aldc+dc3 end
	if dc4 then aldc=aldc+dc4 end
	if dc5 then aldc=aldc+dc5 end
	if dc6 then aldc=aldc+dc6 end
	if dc7 then aldc=aldc+dc7 end
	if dc8 then aldc=aldc+dc8 end
	if aldc%2==1 then
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_UPDATE_ATTACK)
		e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2_1:SetValue(aldc*450)
		c:RegisterEffect(e2_1)
		local e2_2=e2_1:Clone()
		e2_2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2_2)
		local e2_3=Effect.CreateEffect(c)
		e2_3:SetType(EFFECT_TYPE_SINGLE)
		e2_3:SetCode(EFFECT_IMMUNE_EFFECT)
		e2_3:SetValue(c11200018.efilter2_3)
		e2_3:SetOwnerPlayer(tp)
		e2_3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		c:RegisterEffect(e2_3)
	end
	if aldc==4 then Duel.Damage(tp,1100,REASON_EFFECT) end
	if aldc%2==0 then
		if Duel.GetMZoneCount(tp)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c11200018.tfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if sg:GetCount()<1 then return end
		local tc=sg:GetFirst()
		tc:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_LIGHT,RACE_BEAST,4,1100,1100)
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
--
function c11200018.efilter2_3(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
