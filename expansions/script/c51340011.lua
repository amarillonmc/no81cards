--窃时姬 nek
local m=51340011
local cm=_G["c"..m]
xpcall(function() dofile("expansions/script/c51300039.lua") end,function() dofile("script/c51300039.lua") end)
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=qie.qeffect(c,m)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)	  
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(cm.rmcon)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
end
--SpecialSummon

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and c:GetFlagEffect(51340001)>0
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xa06) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Remove(Duel.GetDecktopGroup(1-tp,1),POS_FACEDOWN,REASON_EFFECT)>0 then
		local opp=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		if opp%2==0 
			and Duel.IsExistingMatchingCard(cm.sppfilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,nil,e,tp) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,cm.sppfilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil,e,tp)
			if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
			and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_DECK,0,1,nil) and aux.Stringid(m,2) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_DECK,0,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
					tc:RegisterFlagEffect(51340001,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				end
			end
		end
		if opp%2==1 
			and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
			and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_DECK,0,1,1,nil)
			local tc1=g:GetFirst()
			if tc1 and Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
				tc1:RegisterFlagEffect(51340001,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				if Duel.IsExistingMatchingCard(cm.sppfilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,nil,e,tp) 
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and aux.Stringid(m,1) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg1=Duel.SelectMatchingCard(tp,cm.sppfilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil,e,tp)
					Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
function cm.penfilter(c)
	return c:IsSetCard(0xa06) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.sppfilter(c,e,tp)
	return c:IsSetCard(0xa06) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
















