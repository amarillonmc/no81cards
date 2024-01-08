--窃时姬 mfu
local m=51341111
local cm=_G["c"..m]
xpcall(function() dofile("expansions/script/c51300039.lua") end,function() dofile("script/c51300039.lua") end)
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=qie.qeffect(c,m)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(cm.xyztg)
	e1:SetOperation(cm.xyzop)
	c:RegisterEffect(e1)	 
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.rmcon)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
end
function cm.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
--remove 
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.thfilter(c)
	return c:IsSetCard(0xa06) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xa06) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.setfilter(c)
	return c:IsSetCard(0xa06) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)

	local hg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	local a1=ct>=1 and hg:GetCount()>0

	local spg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local stg=Duel.GetMatchingGroup(cm.setfilter,tp,LOCATION_DECK,0,nil)
	local a2=ct>=2 and (#spg>0 or #stg>0)

	local a3=ct>=3 and a2 and a1

	local off=1
	local ops={}
	local opval={}
	if a1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if a2 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	if a3 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))

	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg1=hg:Select(tp,1,1,nil)
		Duel.SendtoHand(shg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,shg1)
	end
	if opval[op]==2 then
		Duel.BreakEffect()
		if #spg>0 then
			if (#stg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4))) or #stg<1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=spg:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
				tc:RegisterFlagEffect(51340001,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
	if opval[op]==3 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg1=hg:Select(tp,1,1,nil)
		Duel.SendtoHand(shg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,shg1)
		Duel.BreakEffect()
		if #spg>0 then
			if (#stg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4))) or #stg<1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=spg:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end

