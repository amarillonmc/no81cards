--灵光 凤凰
function c21692415.initial_effect(c)
	--revive
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,21692415) 
	e1:SetCost(c21692415.spcost)
	e1:SetTarget(c21692415.sptg)
	e1:SetOperation(c21692415.spop)
	c:RegisterEffect(e1)	 
	--syn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_CHECK) 
	e2:SetValue(c21692415.syncheck)
	c:RegisterEffect(e2) 
	--SpecialSummon 
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_DISCARD)
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,11692415) 
	e3:SetTarget(c21692415.syptg)
	e3:SetOperation(c21692415.sypop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(21692415)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
end
c21692415.SetCard_ZW_ShLight=true 
function c21692415.costfilter(c)
	return not c:IsCode(21692415) and c:IsSetCard(0x555) and c:IsDiscardable()
end
function c21692415.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21692415.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c21692415.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c21692415.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21692415.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c21692415.syncheck(e,c)
	if c~=e:GetHandler() then
		c:AssumeProperty(ASSUME_LEVEL,2)
	end
end
function c21692415.syptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21692415.sypop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21692415,0)) then 
			Duel.BreakEffect() 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=g:Select(tp,1,1,nil):GetFirst() 
			Duel.SynchroSummon(tp,sc,c)
		end
	end
end
local _SynMixCheckGoal=Auxiliary.SynMixCheckGoal
function Auxiliary.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if gc and not gc(g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not Auxiliary.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	if Duel.IsPlayerAffectedByEffect(tp,8173184)
		and not g:IsExists(Auxiliary.Tuner(Card.IsSetCard,0x2),1,nil,syncard) then return false end
	if not g:CheckWithSumEqual(Card.GetSynchroLevel,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard)
		and (not g:IsExists(Card.IsHasEffect,1,nil,21692415)
		or not g:CheckWithSumEqual(function(c) return c:IsHasEffect(21692415)~=nil and c:GetSynchroLevel(syncard) or 2 end,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(Auxiliary.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
		then return false end
	if not (mgchk or Auxiliary.SynMixHandCheck(g,tp,syncard)) then return false end
	for c in Auxiliary.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(Auxiliary.SynLimitFilter,1,c,lf,le,syncard) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	if (g:IsExists(Card.IsHasEffect,1,nil,21692415) and g:CheckWithSumEqual(function(c) return c:IsHasEffect(21692415)~=nil and c:GetSynchroLevel(syncard) or 2 end,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard)) then return true end
	return _SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
end