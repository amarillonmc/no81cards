--觉龙的启示
local s,id=GetID()
s.named_with_AwakenedDragon=1

s.MITRA_CODE=40020256

function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020256)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.optg)
	e2:SetOperation(s.opop)
	c:RegisterEffect(e2)
end

function s.mzfilter(c)
	return c:IsFaceup() and s.AwakenedDragon(c)
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)

	local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local has_mitra = ((pz0 and pz0:IsCode(s.MITRA_CODE)) or (pz1 and pz1:IsCode(s.MITRA_CODE)))
	if not has_mitra then return false end
	
	if not Duel.IsExistingMatchingCard(s.mzfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	
	return rp==1-tp and Duel.IsChainNegatable(ev)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsAbleToDeck() then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		re:GetHandler():CancelToGrave() 
		Duel.SendtoDeck(re:GetHandler(),nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end

function s.spfilter(c,e,tp)
	return c:IsFaceup() and s.AwakenedDragon(c) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.xyz_mat_filter(c)
	return c:IsFaceup() and s.AwakenedDragon(c) and c:IsType(TYPE_MONSTER)
end

function s.xyz_filter(c,e,tp)
	if not (s.AwakenedDragon(c) and c:IsType(TYPE_XYZ)) then return false end
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
end

function s.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1 = Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			   and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
			   
	local b2 = Duel.IsExistingMatchingCard(s.xyz_mat_filter,tp,LOCATION_REMOVED,0,1,nil)
			   and Duel.IsExistingMatchingCard(s.xyz_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
			   
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
	end
	e:SetLabel(op)
	
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end

function s.opop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local mat_g=Duel.GetMatchingGroup(s.xyz_mat_filter,tp,LOCATION_REMOVED,0,nil)
		local xyz_g=Duel.GetMatchingGroup(s.xyz_filter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if #mat_g==0 or #xyz_g==0 then return end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mat=mat_g:Select(tp,1,1,nil):GetFirst()
		if not mat then return end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyzc=xyz_g:Select(tp,1,1,nil):GetFirst()
		if xyzc then
			xyzc:SetMaterial(Group.FromCards(mat))
			if Duel.SpecialSummon(xyzc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP)~=0 then
				Duel.Overlay(xyzc,Group.FromCards(mat))
				xyzc:CompleteProcedure()
			end
		end
	end
end