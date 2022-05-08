local m=53713006
local cm=_G["c"..m]
cm.name="ALC之灾 HNS"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c)return c:GetOriginalType()&TYPE_TRAP~=0 and c:IsFusionType(TYPE_MONSTER)end,2,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(0xff)
	e0:SetCost(cm.spcost)
	e0:SetOperation(cm.spcop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
end
function cm.tefilter(c)
	return c:IsType(TYPE_FUSION) and c:IsAbleToExtraAsCost()
end
function cm.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION then
		e:SetLabel(1)
		return Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_MZONE,0,1,nil)
	else
		e:SetLabel(0)
		return true
	end
end
function cm.spcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return true end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.filter(c,tp)
	return c:IsFaceup() and ((c:IsControler(tp) and (c:GetType()&0x20004~=0x20004 or c:IsCanTurnSet())) or (c:IsControler(1-tp) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())))
end
function cm.setfilter(c,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsCanTurnSet()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,nil,tp) and Duel.GetFlagEffect(tp,m)==0
	local b2=Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,nil,tp) and Duel.GetFlagEffect(tp,m+50)==0
	if chk==0 then return b1 or b2 end
end
function cm.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x535) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc1,loc2=0
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,nil,tp) and Duel.GetFlagEffect(tp,m)==0 then loc1=LOCATION_ONFIELD end
	if Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,nil,tp) and Duel.GetFlagEffect(tp,m+50)==0 then loc2=LOCATION_ONFIELD end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,loc1,loc2,1,1,nil,tp):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	local res=false
	if tc:IsControler(tp) then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetLabel(tc:GetCode())
		e1:SetTarget(function(e,c,tp,sumtp,sumpos)return c:IsCode(e:GetLabel())end)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e2,tp)
		if tc:GetType()&0x20004==0x20004 then
			tc:CancelToGrave()
			if Duel.ChangePosition(tc,POS_FACEDOWN)~=0 and tc:IsFacedown() then
				if tc:IsType(TYPE_SPELL+TYPE_TRAP) then Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) end
				res=true
			end
		else res=true end
	else
		Duel.RegisterFlagEffect(tp,m+50,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tc:GetCode()):GetFirst()
		Duel.HintSelection(Group.FromCards(sc))
		sc:CancelToGrave()
		if Duel.ChangePosition(sc,POS_FACEDOWN)~=0 and sc:IsFacedown() then
			if sc:IsType(TYPE_SPELL+TYPE_TRAP) then Duel.RaiseEvent(sc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) end
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then res=true end
		end
	end
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,c)
	if res and c:IsAbleToExtra() and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		if c:IsLocation(LOCATION_EXTRA) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spg=sg:Select(tp,1,1,nil,e,tp,nil)
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
