--异梦剧场的馆长
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.yume_nikki) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71400001,0)
		yume.import_flag=false
	end
	--xyz summon
	aux.AddXyzProcedure(c,yume.YumeCheck(c,true),4,3)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+100000)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.samefilter(c)
	if c:IsType(TYPE_LINK) or not (c:IsFaceup() and c:IsSetCard(0x714)) then return false end
	local num=0
	local xyz=false
	if c:IsType(TYPE_XYZ) then
		num=c:GetRank()
		xyz=true
	else
		num=c:GetLevel()
	end
	return num>0 and Duel.IsExistingMatchingCard(s.samefilter2,0,LOCATION_MZONE,LOCATION_MZONE,1,c,num,xyz)
end
function s.samefilter2(c,num,xyz)
	if c:IsType(TYPE_LINK) or not (c:IsFaceup() and c:IsSetCard(0x714)) then return false end
	if xyz then
		return c:IsType(TYPE_XYZ) and c:IsRank(num)
	else
		return not c:IsType(TYPE_XYZ) and c:IsLevel(num)
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev)
		and Duel.IsExistingMatchingCard(s.samefilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)>0 then
		Duel.NegateEffect(ev)
	end
end
function s.costfilter(c)
	return c:IsCode(71400026) and c:IsAbleToDeckAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.costfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.costfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsCode(71400011) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.matfilter(c)
	return c:IsSetCard(0x714) and c:IsCanOverlay()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if not sc then return end
	if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)==0 then return end
	sc:CompleteProcedure()
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.matfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local og=mg:Select(tp,1,math.min(3,#mg),nil)
		if #og>0 then
			Duel.Overlay(sc,og)
		end
	end
end
