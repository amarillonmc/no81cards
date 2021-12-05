--饮食艺术·秋色拿铁
function c1184022.initial_effect(c)
--
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c1184022.XyzLevelFreeCondition(c1184022.f,nil,2,2))
	e1:SetTarget(c1184022.XyzLevelFreeTarget(c1184022.f,nil,2,2))
	e1:SetOperation(aux.XyzLevelFreeOperation(c1184022.f,nil,2,2))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1184022,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,1184022)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c1184022.cost3)
	e3:SetTarget(c1184022.tg3)
	e3:SetOperation(c1184022.op3)
	c:RegisterEffect(e3)
--
end
--
function c1184022.f(c,xyzcard)
	return c:IsXyzLevel(xyzcard,3) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c1184022.XyzExgFilter(c,xyzcard)
	return c:IsSetCard(0x3e12) and c:IsCanBeXyzMaterial(xyzcard)
		and c:IsFaceup() and c:GetOriginalLevel()==3
		and bit.band(c:GetOriginalAttribute(),ATTRIBUTE_EARTH)~=0
end
function c1184022.XyzLevelFreeCondition(f,gf,minct,maxct)
	return
	function(e,c,og,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local minc=minct
		local maxc=maxct
		if min then
			minc=math.max(minc,min)
			maxc=math.min(maxc,max)
		end
		if maxc<minc then return false end
		local mg=nil
		if og then
			mg=og:Filter(aux.XyzLevelFreeFilter,nil,c,f)
		else
			mg=Duel.GetMatchingGroup(aux.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
			exg=Duel.GetMatchingGroup(c1184022.XyzExgFilter,tp,LOCATION_SZONE,0,nil,c)
			mg:Merge(exg)
		end
		local sg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
		if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
		Duel.SetSelectedCard(sg)
		aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
		local res=mg:CheckSubGroup(aux.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
		aux.GCheckAdditional=nil
		return res
	end
end
function c1184022.XyzLevelFreeTarget(f,gf,minct,maxct)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
		if og and not min then return true end
		local minc=minct
		local maxc=maxct
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
		end
		local mg=nil
		if og then
			mg=og:Filter(aux.XyzLevelFreeFilter,nil,c,f)
		else
			mg=Duel.GetMatchingGroup(aux.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
			exg=Duel.GetMatchingGroup(c1184022.XyzExgFilter,tp,LOCATION_SZONE,0,nil,c)
			mg:Merge(exg)
		end
		local sg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
		Duel.SetSelectedCard(sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local cancel=Duel.IsSummonCancelable()
		aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
		local g=mg:SelectSubGroup(tp,aux.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
		Auxiliary.GCheckAdditional=nil
		if g and g:GetCount()>0 then
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		else return false end
	end
end
--
function c1184022.cfilter3_1(c,e,tp,og)
	return c:IsAbleToGraveAsCost()
		and og:IsExists(c1184022.cfilter3_2,1,c,e,tp)
end
function c1184022.cfilter3_2(c,e,tp)
	return c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1184022.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if chk==0 then return og:IsExists(c1184022.cfilter3_1,1,nil,e,tp,og) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=og:FilterSelect(tp,c1184022.cfilter3_1,1,1,nil,e,tp,og)
	Duel.SendtoGrave(sg,REASON_COST)
end
--
function c1184022.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and og:IsExists(c1184022.cfilter3_2,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
--
function c1184022.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=og:FilterSelect(tp,c1184022.cfilter3_2,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
