--仙王流星·辉巧
function c11612635.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22398665,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11612635.target)
	e1:SetOperation(c11612635.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22398665,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c11612635.thcon)
	e2:SetTarget(c11612635.thtg)
	e2:SetOperation(c11612635.thop)
	c:RegisterEffect(e2)
end
function c11612635.thcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,11612634) then
		return true
	else return Duel.GetFlagEffect(tp,22398665)<1 end
end
function c11612635.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x154) and c:IsAttackAbove(1000)
end
function c11612635.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11612635.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11612635.cfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c11612635.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.RegisterFlagEffect(tp,22398665,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c11612635.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsAttackAbove(1000) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
		if not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) and c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
function c11612635.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterialEx(tp)--:Filter(Card.IsRace,nil,RACE_ALL)
		if not Duel.IsPlayerAffectedByEffect(tp,11612607) then
			mg=Duel.GetRitualMaterialEx(tp):Filter(Card.IsRace,nil,RACE_MACHINE)
		end
		return Duel.IsExistingMatchingCard(c11612635.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,nil,e,tp,mg,nil,aux.GetCappedAttack,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c11612635.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterialEx(tp)--:Filter(Card.IsRace,nil,RACE_ALL)
	if not Duel.IsPlayerAffectedByEffect(tp,11612607) then
		mg=Duel.GetRitualMaterialEx(tp):Filter(Card.IsRace,nil,RACE_MACHINE)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11612635.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,nil,e,tp,mg,nil,aux.GetCappedAttack,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=c11612635.RitualCheckAdditional(tc,tc:GetAttack(),"Greater")
		local mat=mg:SelectSubGroup(tp,c11612635.RitualCheck,false,1,#mg,tp,tc,tc:GetAttack(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c11612635.RitualCheckGreater(g,c,atk)
	if atk==0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(aux.GetCappedAttack,atk)
end
function c11612635.RitualCheckEqual(g,c,atk)
	if atk==0 then return false end
	return g:CheckWithSumEqual(aux.GetCappedAttack,atk,#g,#g)
end
function c11612635.RitualCheck(g,tp,c,atk,greater_or_equal)
	return c11612635["RitualCheck"..greater_or_equal](g,c,atk) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not aux.RCheckAdditional or aux.RCheckAdditional(tp,g,c))
end
function c11612635.RitualCheckAdditional(c,atk,greater_or_equal)
	if greater_or_equal=="Equal" then
		return  function(g)
					return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g)) and g:GetSum(aux.GetCappedAttack)<=atk
				end
	else
		return  function(g,ec)
					if atk==0 then return #g<=1 end
					if ec then
						return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g,ec)) and g:GetSum(aux.GetCappedAttack)-aux.GetCappedAttack(ec)<=atk
					else
						return not aux.RGCheckAdditional or aux.RGCheckAdditional(g)
					end
				end
	end
end
function c11612635.RitualUltimateFilter(c,filter,e,tp,m1,m2,attack_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local atk=attack_function(c)
	aux.GCheckAdditional=c11612635.RitualCheckAdditional(c,atk,greater_or_equal)
	local res=mg:CheckSubGroup(c11612635.RitualCheck,1,#mg,tp,c,atk,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
