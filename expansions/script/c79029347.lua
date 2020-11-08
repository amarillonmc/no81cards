--罗德岛·部署-勿忘我
function c79029347.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029347,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79029347.target)
	e1:SetOperation(c79029347.operation)
	c:RegisterEffect(e1)   
end
function c79029347.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0xa900)
		return Duel.IsExistingMatchingCard(c79029347.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,nil,e,tp,mg,nil,Card.GetAttack,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c79029347.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0xa900)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c79029347.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,nil,e,tp,mg,nil,Card.GetAttack,"Greater")
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
		aux.GCheckAdditional=c79029347.RitualCheckAdditional(tc,tc:GetAttack(),"Greater")
		local mat=mg:SelectSubGroup(tp,c79029347.RitualCheck,false,1,#mg,tp,tc,tc:GetAttack(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	Debug.Message("该出任务了吗？我知道的，我会保护好罗德岛的干员们的。一定。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029347,1))
	 if tc:GetSummonLocation()==LOCATION_HAND then
	 --
	 local e1=Effect.CreateEffect(tc)
	 e1:SetDescription(aux.Stringid(79029347,0))
	 e1:SetType(EFFECT_TYPE_IGNITION)
	 e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	 e1:SetRange(LOCATION_MZONE) 
	 e1:SetCountLimit(1)	   
	 e1:SetCost(c79029347.xxcost)
	 e1:SetOperation(c79029347.xxop)
	 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	 tc:RegisterEffect(e1)
	 --
	 local e2=Effect.CreateEffect(tc)
	 e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	 e2:SetCode(EVENT_BATTLE_CONFIRM)
	 e2:SetRange(LOCATION_MZONE)
	 e2:SetCondition(c79029347.xcon)
	 e2:SetOperation(c79029347.xop)
	 e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	 tc:RegisterEffect(e2)
	 end
   end
end
function c79029347.xcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	local lv=e:GetHandler():GetMaterial():GetSum(Card.GetLevel)
	return tc:IsLevelAbove(lv)
end
function c79029347.xop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Duel.Hint(HINT_CARD,0,79029347)
	Debug.Message("痛的话就叫出来，会好受些的。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029347,3))
	local tc=e:GetHandler():GetBattleTarget()
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_RULE)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-tc:GetAttack())
	end
end
function c79029347.xxfil(c)
	return c:IsSetCard(0xa900) and c:IsAbleToGraveAsCost()
end
function c79029347.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029347.xxfil,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029347.xxfil,tp,LOCATION_EXTRA,0,1,3,nil)
	local x=Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(x)
end
function c79029347.xxop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我不想家人受到伤害。我会把可能伤害到家人的东西全毁掉。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029347,2))
	local x=e:GetLabel()
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(x*1000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c79029347.RitualCheckGreater(g,c,atk)
	if atk==0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetAttack,atk)
end
function c79029347.RitualCheckEqual(g,c,atk)
	if atk==0 then return false end
	return g:CheckWithSumEqual(Card.GetAttack,atk,#g,#g)
end
function c79029347.RitualCheck(g,tp,c,atk,greater_or_equal)
	return c79029347["RitualCheck"..greater_or_equal](g,c,atk) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not Auxiliary.RCheckAdditional or Auxiliary.RCheckAdditional(tp,g,c))
end
function c79029347.RitualCheckAdditional(c,atk,greater_or_equal)
	if greater_or_equal=="Equal" then
		return  function(g)
					return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g)) and g:GetSum(Card.GetAttack)<=atk
				end
	else
		return  function(g,ec)
					if atk==0 then return #g<=1 end
					if ec then
						return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g,ec)) and g:GetSum(Card.GetAttack)-Card.GetAttack(ec)<=atk
					else
						return not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g)
					end
				end
	end
end
function c79029347.RitualUltimateFilter(c,filter,e,tp,m1,m2,attack_function,greater_or_equal,chk)
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
	Auxiliary.GCheckAdditional=c79029347.RitualCheckAdditional(c,atk,greater_or_equal)
	local res=mg:CheckSubGroup(c79029347.RitualCheck,1,#mg,tp,c,atk,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end









