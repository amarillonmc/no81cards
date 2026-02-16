-- Define a local table to hold our custom functions to avoid global pollution
local MySynchro = {}

function MySynchro.SynMixCheckGoal(tp, sg, minc, ct, syncard, sg1, smat, gc, mgchk)
	if ct < minc then return false end
	local g = sg:Clone()
	g:Merge(sg1)
	
	-- Standard Location Check
	if Duel.GetLocationCountFromEx(tp, tp, g, syncard) <= 0 then return false end
	-- Custom Goal Check (if provided)
	if gc and not gc(g, syncard, tp) then return false end
	-- Must Material Check
	if smat and not g:IsContains(smat) then return false end
	if not Auxiliary.MustMaterialCheck(g, tp, EFFECT_MUST_BE_SMATERIAL) then return false end
	
	-- [CRITICAL MODIFICATION START]
	-- We replace g:CheckWithSumEqual with custom logic
	local sum = 0
	local tuner = nil
	local tuner_count = 0
	
	-- Iterate materials to separate Tuner and sum Non-Tuners
	for tc in Auxiliary.Next(g) do
		if tc:IsTuner(syncard) then
			tuner = tc
			tuner_count = tuner_count + 1
		else
			sum = sum + tc:GetSynchroLevel(syncard)
		end
	end
	
	-- Ensure exactly 1 Tuner (based on your "1 Tuner + ..." requirement)
	if tuner_count ~= 1 or not tuner then return false end
	
	local target_lv = syncard:GetLevel()
	local req_tuner_lv = target_lv - sum
	local valid_level = false
	
	-- 1. Check Standard Current Level
	-- Note: GetSynchroLevel might return multiple values, strictly we check the primary one or assume integer
	if tuner:GetSynchroLevel(syncard) == req_tuner_lv then 
		valid_level = true 
	end
	
	-- 2. Check Custom Level Range (Original Level + 1 to 3)
	if not valid_level then
		local orig_lv = tuner:GetOriginalLevel()
		local diff = req_tuner_lv - orig_lv
		if diff >= 1 and diff <= 3 then
			valid_level = true
		end
	end
	
	if not valid_level then return false end
	
	-- Flower Cardian Check (Legacy support, optional)
	if g:IsExists(Card.IsHasEffect, 1, nil, 89818984) and 
	   not g:CheckWithSumEqual(Auxiliary.GetSynchroLevelFlowerCardian, target_lv, g:GetCount(), g:GetCount(), syncard) then
	   return false
	end
	-- [CRITICAL MODIFICATION END]

	if not (mgchk or Auxiliary.SynMixHandCheck(g, tp, syncard)) then return false end
	
	-- Check specific Tuner Limits (e.g., "Cannot be used for Synchro of Level X")
	for c in Auxiliary.Next(g) do
		local le, lf, lloc, lmin, lmax = c:GetTunerLimit()
		if le then
			local lct = g:GetCount() - 1
			if lloc then
				local llct = g:FilterCount(Card.IsLocation, c, lloc)
				if llct ~= lct then return false end
			end
			if lf and g:IsExists(Auxiliary.SynLimitFilter, 1, c, lf, le, syncard) then return false end
			if (lmin and lct < lmin) or (lmax and lct > lmax) then return false end
		end
	end
	return true
end

function MySynchro.SynMixCheckRecursive(c, tp, sg, mg, ct, minc, maxc, syncard, sg1, smat, gc, mgchk)
	sg:AddCard(c)
	ct = ct + 1
	-- Call OUR Custom Goal
	local res = MySynchro.SynMixCheckGoal(tp, sg, minc, ct, syncard, sg1, smat, gc, mgchk)
		or (ct < maxc and mg:IsExists(MySynchro.SynMixCheckRecursive, 1, sg, tp, sg, mg, ct, minc, maxc, syncard, sg1, smat, gc, mgchk))
	sg:RemoveCard(c)
	ct = ct - 1
	return res
end

function MySynchro.SynMixCheck(mg, sg1, minc, maxc, syncard, smat, gc, mgchk)
	local tp = syncard:GetControler()
	local sg = Group.CreateGroup()
	if minc <= 0 and MySynchro.SynMixCheckGoal(tp, sg1, 0, 0, syncard, sg, smat, gc, mgchk) then return true end
	if maxc == 0 then return false end
	return mg:IsExists(MySynchro.SynMixCheckRecursive, 1, nil, tp, sg, mg, 0, minc, maxc, syncard, sg1, smat, gc, mgchk)
end

-- Filter 4: Checks the combination
function MySynchro.SynMixFilter4(c, f4, minc, maxc, syncard, mg1, smat, c1, c2, c3, gc, mgchk)
	if f4 and not f4(c, syncard, c1, c2, c3) then return false end
	local sg = Group.FromCards(c1, c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg = mg1:Clone()
	if f4 then
		mg = mg:Filter(f4, sg, syncard, c1, c2, c3)
	else
		mg:Sub(sg)
	end
	-- Call OUR Custom Check
	return MySynchro.SynMixCheck(mg, sg, minc - 1, maxc - 1, syncard, smat, gc, mgchk)
end

-- Filter 2: Used for "1 Tuner + ..." logic (standard structure)
function MySynchro.SynMixFilter2(c, f2, f3, f4, minc, maxc, syncard, mg, smat, c1, gc, mgchk)
	-- We assume standard structure: f2 is non-tuner filter
	if f2 then
		return f2(c, syncard, c1)
			-- Note: We skip Filter3 logic for simplicity if you only have 1 non-tuner type logic
			-- Calling Filter4 directly
			and (minc == 0 or MySynchro.SynMixFilter4(c, nil, 1, 1, syncard, mg, smat, c1, nil, nil, gc, mgchk))
			-- If you need complex mix (f3), you would need to implement Filter3 pointing to Filter4 as well.
			-- But for "1 Tuner + 1+ Non-Tuner", Filter2 leads to Filter4 (recursive non-tuners).
	else
		return mg:IsExists(MySynchro.SynMixFilter4, 1, c1, f4, minc, maxc, syncard, mg, smat, c1, nil, nil, gc, mgchk)
	end
end

-- Filter 1: The Tuner
function MySynchro.SynMixFilter1(c, f1, f2, f3, f4, minc, maxc, syncard, mg, smat, gc, mgchk)
	return (not f1 or f1(c, syncard)) 
		and mg:IsExists(MySynchro.SynMixFilter2, 1, c, f2, f3, f4, minc, maxc, syncard, mg, smat, c, gc, mgchk)
end

local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	
	local f1 = Auxiliary.Tuner -- Tuner
	local f2 = Auxiliary.NonTuner -- Non-Tuner
	local minc = 1 -- Min 1 Non-Tuner
	local maxc = 99 -- Max Non-Tuners
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	
	-- CONDITION
	e1:SetCondition(function(e, c, smat, mg1, min, max)
		if c == nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp = c:GetControler()
		local mg
		local mgchk = false
		if mg1 then
			mg = mg1:Filter(Card.IsCanBeSynchroMaterial, nil, c)
			mgchk = true
		else
			mg = Auxiliary.GetSynMaterials(tp, c)
		end
		if smat ~= nil then mg:AddCard(smat) end
		return mg:IsExists(MySynchro.SynMixFilter1, 1, nil, f1, f2, nil, nil, minc, maxc, c, mg, smat, nil, mgchk)
	end)
	
	-- TARGET
	e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk, c, smat, mg1, min, max)
		local g = Group.CreateGroup()
		local mg
		local mgchk = false
		if mg1 then
			mg = mg1:Filter(Card.IsCanBeSynchroMaterial, nil, c)
			mgchk = true
		else
			mg = Auxiliary.GetSynMaterials(tp, c)
		end
		if smat ~= nil then mg:AddCard(smat) end
		
		local cancel = Duel.IsSummonCancelable()
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SMATERIAL)
		-- Select Tuner (Filter 1)
		local c1 = mg:Filter(MySynchro.SynMixFilter1, nil, f1, f2, nil, nil, minc, maxc, c, mg, smat, nil, mgchk):SelectUnselect(g, tp, false, cancel, 1, 1)
		if not c1 then return false end
		g:AddCard(c1)
		
		-- Select Non-Tuners
		-- We simplify the loop here for "1 Tuner + Non-Tuners" logic
		-- Logic: Loop until goal is met or max reached, checking our Custom Recursive function
		local g4 = Group.CreateGroup()
		for i = 0, maxc - 1 do
			local mg2 = mg:Clone()
			-- Non-Tuner Filter (f2 becomes f4 in mix logic context here)
			mg2 = mg2:Filter(f2, g, c, c1) 
			local cg = mg2:Filter(MySynchro.SynMixCheckRecursive, g4, tp, g4, mg2, i, minc, maxc, c, g, smat, nil, mgchk)
			if cg:GetCount() == 0 then break end
			
			local finish = MySynchro.SynMixCheckGoal(tp, g4, minc, i, c, g, smat, nil, mgchk)
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SMATERIAL)
			local c4 = cg:SelectUnselect(g + g4, tp, finish, cancel, minc, maxc)
			if not c4 then
				if finish then break else return false end
			end
			if g:IsContains(c4) or g4:IsContains(c4) then return false end -- Should reset
			g4:AddCard(c4)
		end
		
		g:Merge(g4)
		if g:GetCount() > 0 then
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		end
		return false
	end)
	
	-- OPERATION (Standard)
	e1:SetOperation(Auxiliary.SynMixOperation(f1, f2, nil, nil, minc, maxc, nil))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)

	--Effect 1: Special Summon Synchro using materials
	--Reference: Source 1 (Trigger/Material Filter) & Source 4 (Selection/Synchro Check)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.matfilter(c,e,tp,sync)
	--Filter for materials in GY/Removed used for this card's Synchro Summon
	--Reference: Source 1 s.spfilter
	return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsControler(tp)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync and c:IsCanBeEffectTarget(e)
end

function s.scfilter(c,tp,mg)
	--Check if a Synchro Monster can be summoned using the selected group 'mg'
	--Reference: Source 4 s.filter / Card.IsSynchroSummonable
	return c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,mg,#mg-1,#mg-1) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function s.chk(g,tp)
	--Check sub-group validity
	return Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_EXTRA,0,1,nil,tp,g)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	if chk==0 then
		if not mg then return false end
		local valid_mg=mg:Filter(s.matfilter,nil,e,tp,c)
		return valid_mg:GetCount()>0 
			and valid_mg:CheckSubGroup(s.chk,1,valid_mg:GetCount(),tp)
	end
	local valid_mg=mg:Filter(s.matfilter,nil,e,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	--Select materials that form a valid Synchro Summon
	local g=valid_mg:SelectSubGroup(tp,s.chk,false,1,valid_mg:GetCount(),tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_SYNCHRO)<1 then return end
	local g=Duel.GetTargetsRelateToChain()
	if not g or g:GetCount()==0 then return end
	
	local scg=Duel.GetMatchingGroup(s.scfilter,tp,LOCATION_EXTRA,0,nil,tp,g)
	if scg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=scg:Select(tp,1,1,nil):GetFirst()
		--Reference: Source 4 s.activate (Special Summon from Extra)
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			--Reduce Level by 1
			--Reference: Source 15 (Update Level)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
	end
end