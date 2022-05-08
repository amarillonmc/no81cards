local m=53731009
local cm=_G["c"..m]
cm.name="狂喑月祭"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.RitualCheckEqual(g,c,lv)
	local res=false
	for i=1,24 do if g:CheckWithSumEqual(Card.GetRitualLevel,lv*i,#g,#g,c) then res=true end end
	return res
end
function cm.RitualCheck(g,tp,c,lv,greater_or_equal)
	return cm["RitualCheck"..greater_or_equal](g,c,lv) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp)) and (not aux.RCheckAdditional or aux.RCheckAdditional(tp,g,c))
end
function cm.RitualCheckAdditional(c)
		return  function(g)
					return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g))
				end
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then mg:Merge(m2) end
	if c.mat_filter then mg=mg:Filter(c.mat_filter,c,tp) else mg:RemoveCard(c) end
	local lv=level_function(c)
	aux.GCheckAdditional=cm.RitualCheckAdditional(c)
	local res=mg:CheckSubGroup(cm.RitualCheck,1,99,tp,c,lv,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function cm.rfilter(c,e,tp)
	return c:IsSetCard(0x9533)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,cm.rfilter,e,tp,mg,nil,Card.GetLevel,"Equal") end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,cm.rfilter,e,tp,mg,nil,Card.GetLevel,"Equal"):GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then mg:Merge(sg) end
		if tc.mat_filter then mg=mg:Filter(tc.mat_filter,tc,tp) else mg:RemoveCard(tc) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=cm.RitualCheckAdditional(tc)
		local mat=mg:SelectSubGroup(tp,cm.RitualCheck,false,1,99,tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		local lvsum=mat:GetSum(Card.GetRitualLevel,tc)
		local mul=math.floor(lvsum/tc:GetLevel())
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		if not tc:IsLocation(LOCATION_MZONE) or tc:IsFacedown() then return end
		if mul>=2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCountLimit(1)
		e1:SetTarget(cm.reptarget)
		e1:SetOperation(cm.repoperation)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		end
		if mul>=3 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(m,1))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetValue(aux.tgoval)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		end
		if mul>=5 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(m,2))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetValue(function(e,re)return e:GetOwnerPlayer()~=re:GetOwnerPlayer()end)
		e3:SetOwnerPlayer(tp)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		end
	end
end
function cm.repfilter(c)
	return c:IsSetCard(0x9533) and c:IsAbleToHand()
end
function cm.reptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_HAND and not c:IsReason(REASON_REPLACE) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.repfilter),tp,LOCATION_GRAVE,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,3))
end
function cm.repoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.repfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then Duel.SendtoHand(g,nil,REASON_EFFECT+REASON_REPLACE) end
end
