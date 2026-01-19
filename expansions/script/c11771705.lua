--蓝冰之承继 斯嘉蒂娅
-- c12345678.lua
local s,id,o=GetID()
function s.initial_effect(c)
	-- Pendulum Set
	aux.EnablePendulumAttribute(c)
	-- P Effect: Scale Change & Place/ToExtra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.ptg)
	e1:SetOperation(s.pop)
	c:RegisterEffect(e1)
	-- Monster Effect: SpSummon Deck & Optional SpSummon Grave/Rem
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- Pendulum Effect
function s.pfilter(c)
	return c:IsSetCard(0x6c74) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- Hint that we might add to extra, though place in P-zone is also possible
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,0,tp,LOCATION_DECK)
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	
	-- Select Scale Option
	local scl=c:GetLeftScale()
	local b1=scl<13 -- Can increase
	local b2=scl>0  -- Can decrease
	
	-- Fail safe if somehow scale is out of logical bounds for both operations (unlikely)
	if not b1 and not b2 then return end
	
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)})
	
	local val=(op==1) and 1 or -1
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
	
	-- Subsequent Effect
	local g=Duel.GetMatchingGroup(s.pfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not tc then return end
		
		local b_zone=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		local b_extra=true
		
		local op2=aux.SelectFromOptions(tp,
			{b_zone,aux.Stringid(id,5)},
			{b_extra,aux.Stringid(id,6)})
			
		if op2==1 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
		end
	end
end

-- Monster Effect
function s.spfilter1(c,e,tp)
	return c:IsSetCard(0x6c74) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter2(c,e,tp)
	return c:IsLevel(9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
			if ag:GetClassCount(Card.GetAttribute)>=3 
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) 
				and Duel.SelectYesNo(tp,aux.Stringid(id,7)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
				if sg:GetCount()>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end