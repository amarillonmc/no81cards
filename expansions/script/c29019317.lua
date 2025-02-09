--足践烈火
local m=29019317
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c29019317.xyztg)
	e1:SetOperation(c29019317.xyzop)
	c:RegisterEffect(e1)
	
end
function c29019317.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function c29019317.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c29019317.spfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x87af) and Duel.IsExistingMatchingCard(c29019317.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(c29019317.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c29019317.spfilter2(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x87af) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and not Duel.IsExistingMatchingCard(c29019317.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end


function c29019317.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29019317.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) or Duel.IsExistingMatchingCard(c29019317.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29019317.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(c29019317.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) then
		ops[off]=aux.Stringid(29019317,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c29019317.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) then
		ops[off]=aux.Stringid(29019317,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.GetMatchingGroup(c29019317.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local tc=Duel.SelectMatchingCard(tp,c29019317.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
		if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
		if tc:IsFacedown() or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c29019317.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		local sc=g:GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end



