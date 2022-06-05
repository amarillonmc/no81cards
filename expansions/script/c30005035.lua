--仪死的供物
local m=30005035
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_LINK)
	e0:SetCost(cm.spcost)
	c:RegisterEffect(e0)
	--ritual oblation
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_RITUAL_LEVEL)
	e13:SetRange(LOCATION_MZONE)
	e13:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e13:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,1))
	e13:SetValue(cm.rlevel)
	c:RegisterEffect(e13)
	local e23=Effect.CreateEffect(c)
	e23:SetType(EFFECT_TYPE_FIELD)
	e23:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e23:SetRange(LOCATION_MZONE)
	e23:SetTargetRange(LOCATION_GRAVE,0)
	e23:SetValue(1)
	c:RegisterEffect(e23)
	--ritual summon hand
	local e3=aux.AddRitualProcGreater2(c,cm.filter3,nil,nil,cm.matfilter3,true)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	c:RegisterEffect(e3)
	--ritual summon szone
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	--duel sunmmon success code
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL)
end
--duel sunmmon success code
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc:IsSummonType(SUMMON_TYPE_RITUAL) then return end
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
--spsummon condition
function cm.spcost(e,c,tp,st)
	return Duel.GetFlagEffect(tp,m)>=1
end
--ritual oblation
function cm.rlevel(e,c)
	if bit.band(c:GetType(),TYPE_RITUAL+TYPE_MONSTER)==TYPE_RITUAL+TYPE_MONSTER 
		and c:IsAttribute(ATTRIBUTE_DARK) then
		local clv=c:GetLevel()
		return clv
	end
end
--ritual summon hand
function cm.filter3(c,e,tp,chk)
	return c:IsAttribute(ATTRIBUTE_DARK) and (not chk or c~=e:GetHandler())
end
function cm.matfilter3(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
--ritual summon szone
function cm.dfilter(c)
	return c:IsReleasable() and c:GetOriginalLevel()>0
end
function cm.filter(c,e,tp)
	return true
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if (bit.band(c:GetType(),0x81)~=0x81 and not (c:IsLocation(LOCATION_SZONE) and c:GetOriginalType()&TYPE_RITUAL~=0)) or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
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
	if c:IsLocation(LOCATION_SZONE) then
		lv=c:GetOriginalLevel()
	end
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function cm.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function cm.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function cm.extra(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		aux.RCheckAdditional=cm.rcheck
		aux.RGCheckAdditional=cm.rgcheck
		local res=Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_SZONE,0,1,e:GetHandler(),cm.filter,e,tp,mg,nil,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=cm.rcheck
	aux.RGCheckAdditional=cm.rgcheck
	local tg=Duel.SelectMatchingCard(tp,cm.RitualUltimateFilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler(),cm.filter,e,tp,m,nil,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		if mat:GetCount()>0 then
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end


