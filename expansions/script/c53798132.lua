--User Card
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.imcon)
	e1:SetOperation(s.imop)
	c:RegisterEffect(e1)
	--special summon & synchro
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
--E1: Immune Logic
function s.imcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp
end
function s.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Reference & logic adaptation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0) -- Own Field and GY
	e1:SetValue(s.efilter)
	e1:SetLabelObject(re) -- Store the opponent's effect
	e1:SetReset(RESET_CHAIN) -- Only needs to last for the chain resolution
	Duel.RegisterEffect(e1,tp)
end
function s.efilter(e,te,c)
	--Logic based on "Noble Angel" 
	--Checks if the incoming effect (te) matches the target (re) and applies logic
	local tp=e:GetHandlerPlayer()
	local re=e:GetLabelObject()
	
	--Basic check: Is this the effect we are protecting against?
	if te~=re then return false end
	
	--Prevention of recursive checking (similar to Noble Angel's "ctns" check)
	local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+id)}
	local ctns=false
	if not te:IsHasType(EFFECT_TYPE_ACTIONS) then
		for _,se in pairs(eset) do
			if se:GetLabelObject()==te then ctns=true end
		end
	end

	--If protection is applicable and not already processed
	if not ctns then
		--Register a flag/effect to indicate protection happened
		local e1=Effect.CreateEffect(e:GetOwner())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_FLAG_EFFECT+id)
		e1:SetLabelObject(te)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		c:RegisterEffect(e1,true)
		
		--Register the EVENT_ADJUST to raise the custom event
		--Using FlagEffect to ensure we only raise the event once per chain/resolution
		if Duel.GetFlagEffect(tp,id)==0 then
			Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
			local e2=Effect.CreateEffect(e:GetOwner())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_ADJUST)
			e2:SetOperation(s.raiseop)
			e2:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e2,tp)
		end
	end
	return true
end
function s.raiseop(e,tp,eg,ep,ev,re,r,rp)
	--Reference adaptation: Trigger the event instead of direct action
	local c=e:GetOwner()
	Duel.RaiseEvent(c,EVENT_CUSTOM+id,nil,0,0,tp,0)
	e:Reset()
end

--E2: Special Summon & Synchro
function s.spfilter(c,e,tp,owner_check)
	--Check if it can be SS'd to TP's field in Def
	--If from opponent's GY (owner_check == 1-tp), we still summon to tp
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc_count=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if loc_count<=0 then return false end
		--Need at least one valid target in Hand or Opp GY
		local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,tp)
		local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,1-tp)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc_count=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if loc_count<=0 then return end
	
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp,tp)
	local g2=Duel.GetMatchingGroup(s.spfilter,tp,0,LOCATION_GRAVE,nil,e,tp,1-tp)
	
	--Select up to 1 from Hand
	if g1:GetCount()>0 and loc_count>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(tp,1,1,nil)
		g:Merge(sg1)
		loc_count=loc_count-1
	end
	
	--Select up to 1 from Opponent's GY
	if g2:GetCount()>0 and loc_count>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,1,nil)
		g:Merge(sg2)
	end
	
	if g:GetCount()>0 then
		--Reference logic: Special Summon Step with Negate
		for tc in aux.Next(g) do
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
		Duel.SpecialSummonComplete()
		Duel.AdjustAll()
		
		--Synchro Summon Logic Reference 
		local mg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
		if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local smg=mg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,smg:GetFirst(),nil)
		end
	end
end