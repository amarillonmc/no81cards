--矛枪龙之影灵衣
function c11533718.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetRange(LOCATION_PZONE)
	e10:SetTargetRange(1,0)
	e10:SetTarget(function(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xb4,0xc4) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM end) 
	c:RegisterEffect(e10) 
	--SpecialSummon
	local e20=Effect.CreateEffect(c)
	e20:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e20:SetCode(EVENT_CHAINING)  
	e20:SetProperty(EFFECT_FLAG_DELAY) 
	e20:SetRange(LOCATION_PZONE)
	e20:SetCountLimit(1,11533718) 
	e20:SetCondition(c11533718.ricon)
	e20:SetTarget(c11533718.ritg)
	e20:SetOperation(c11533718.riop)
	c:RegisterEffect(e20) 
	--Negate Activation
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21533718)
	e1:SetCondition(c11533718.negcon)
	e1:SetCost(c11533718.negcost)
	e1:SetTarget(c11533718.negtg)
	e1:SetOperation(c11533718.negop)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,31533718) 
	e2:SetCondition(c11533718.spcon)
	e2:SetTarget(c11533718.sptg)
	e2:SetOperation(c11533718.spop)
	c:RegisterEffect(e2) 
	--pset
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)  
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,41533718)  
	e3:SetTarget(c11533718.pentg)
	e3:SetOperation(c11533718.penop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone() 
	e4:SetCode(EVENT_TO_DECK) 
	e4:SetCondition(c11533718.pencon) 
	c:RegisterEffect(e4) 
end
function c11533718.mat_filter(c)
	return not c:IsLevel(10)
end
function c11533718.ricon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp  
end  
function c11533718.filter(c,e,tp)
	return c:IsSetCard(0xb4)
end 
function c11533718.mfilter(c)
	return c:IsSetCard(0xb4)
end
function c11533718.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	local b1=bit.band(c:GetType(),0x81)==0x81 or (c:IsLocation(LOCATION_PZONE) and bit.band(c:GetOriginalType(),0x81)==0x81)
	if not b1 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function c11533718.ritg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp) 
		local mg2=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,c11533718.mfilter) 
		return Duel.IsExistingMatchingCard(c11533718.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,nil,c11533718.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE) 
end
function c11533718.riop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetRitualMaterial(tp) 
	local mg2=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,c11533718.mfilter) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c11533718.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil,c11533718.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if mg2 then
			mg:Merge(mg2)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c11533718.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end
function c11533718.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
--function c11533718.negcfilter(c)
--  return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0xb4) and c:IsReleasable()
--end
function c11533718.rrfil(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then
		val=re:GetValue()
	end
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0xb4) and (c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_HAND) and (val==nil or val(re,c)~=true)))
end 
function c11533718.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533718.rrfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c11533718.rrfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c11533718.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c11533718.rrfil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)~=0 then
		Duel.NegateActivation(ev)
	end
end
function c11533718.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) 
end  
function c11533718.spfil(c,e,tp) 
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND+LOCATION_DECK)) and c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsCode(11533718)
end 
function c11533718.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533718.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,11533718)==0 end 
	Duel.RegisterFlagEffect(tp,11533718,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end 
function c11533718.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(c11533718.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local tc=Duel.SelectMatchingCard(tp,c11533718.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst() 
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end 
end 
function c11533718.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA) 
end
function c11533718.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c11533718.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
