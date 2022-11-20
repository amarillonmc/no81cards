--自融合
function c10173079.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c10173079.target)
	e1:SetOperation(c10173079.activate)
	c:RegisterEffect(e1)
	if not c10173079.fusionlimit then
		c10173079.fusionlimit=Group.CreateGroup()
		c10173079.fusionlimit:KeepAlive()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(6205579)
		e2:SetTargetRange(0x7f,0x7f)
		e2:SetTarget(function(e,c) return c10173079.fusionlimit:IsContains(c) end)
		Duel.RegisterEffect(e2,0)	 
	end
end
function c10173079.filter(c,e,tp)
	return c:IsFaceup() and c:GetLevel()>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,86871615,0,0x4011,c:GetAttack()/2,c:GetDefense()/2,c:GetLevel()/2,c:GetRace(),c:GetAttribute())
end
function c10173079.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10173079.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10173079.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10173079.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,LOCATION_EXTRA)
end
function c10173079.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local atk,def,lv=tc:GetAttack()/2,tc:GetDefense()/2,tc:GetLevel()/2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetValue(def)
	tc:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(lv)
	tc:RegisterEffect(e3)
	if tc:IsImmuneToEffect(e) or not Duel.IsPlayerCanSpecialSummonMonster(tp,86871615,0,0x4011,atk,def,lv,tc:GetRace(),tc:GetAttribute()) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local token=Duel.CreateToken(tp,86871615)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0xfe0000)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(def)
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(lv)
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(tc:GetRace())
	token:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(tc:GetAttribute())
	token:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_CODE)
	e6:SetValue(tc:GetCode())
	token:RegisterEffect(e6)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	local g=Group.FromCards(token,tc)
	local mg=g:Filter(c10173079.ffilter,nil,e)
	if mg:GetCount()~=2 then return end
	local chkf=tp
	local fg=Duel.GetMatchingGroup(nil,tp,0x7f,0x7f,mg)
	c10173079.fusionlimit:Merge(fg)
	Auxiliary.FCheckAdditional=c10173079.fcheck
	Auxiliary.GCheckAdditional=c10173079.gcheck
	local sg=Duel.GetMatchingGroup(c10173079.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,g,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	Auxiliary.GCheckAdditional=nil
	c10173079.fusionlimit:Clear()
	if sg:GetCount()<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10173079,0)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fc=sg:Select(tp,1,1,nil):GetFirst()
	fc:SetMaterial(g)
	Duel.Release(g,REASON_MATERIAL+REASON_FUSION+REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	fc:CompleteProcedure()
end
function c10173079.ffilter(c,e)
	return not c:IsImmuneToEffect(e) and c:IsReleasableByEffect()
end
function c10173079.ffilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c10173079.fcheck(tp,sg,fc)
	return #sg<=2
end
function c10173079.gcheck(sg)
	return #sg<=2
end