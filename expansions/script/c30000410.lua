--幻邪龙机 卡度卡斯
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm=rscf.DefineCard(30000410)
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(RACE_WYRM+RACE_FIEND)
	c:RegisterEffect(e1)
	--target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--race
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(cm.tgtg2)
	e3:SetOperation(cm.tgop2)
	--c:RegisterEffect(e3)
	--remove 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m+1)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),0,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,4,PLAYER_ALL,LOCATION_GRAVE)
end
function cm.rmfilter(c)
	return c:IsAbleToRemove(c:GetControler(),POS_FACEDOWN)
end 
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rmfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,5,5,nil)
	if #rg==5 then
		Duel.HintSelection(rg)
		if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)>0 then
			if Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
				local fid=c:GetFieldID()
				c:RegisterFlagEffect(m+1,RESET_PHASE+PHASE_END,0,2,fid)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
				e1:SetLabel(Duel.GetTurnCount())
				e1:SetCountLimit(1)
				e1:SetValue(fid)
				e1:SetLabelObject(c)
				e1:SetCondition(cm.spscon)
				e1:SetOperation(cm.spsop)
				Duel.RegisterEffect(e1,tp)	
			end
		end
	end
end
function cm.spscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and c:GetFlagEffectLabel(m+1)==e:GetValue() and
			c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.bfilter(c)
	return not c:IsOnField() or c:IsAbleToGrave()
end 
function cm.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,m)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	rsop.SelectOC(nil,true)
	local og=rsop.SelectSolve(HINTMSG_TARGET,tp,cm.bfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_REMOVED,2,2,nil)
	local g1=og:Filter(Card.IsOnField,nil)
	local g2=og:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	Duel.SendtoGrave(g2,REASON_EFFECT+REASON_RETURN)
end
function cm.cfilter1(c)
	return (c:IsAbleToGrave() or c:IsAbleToRemove()) and c:IsRace(RACE_WYRM+RACE_DRAGON) 
		and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(10)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			if Duel.SendtoGrave(tc,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_GRAVE) then 
				return
			end
		else
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_REMOVED) then 
				return
			end
		end
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.BreakEffect()
			--cannot attack
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e1)
			--cannot be target
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
			e2:SetRange(LOCATION_MZONE)
			e2:SetValue(aux.imval1)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e3:SetValue(aux.tgoval)
			c:RegisterEffect(e3)
		end
	end
end
function cm.cfilter2(c)
	return (c:IsAbleToGrave() or c:IsAbleToRemove()) and c:IsRace(RACE_FIEND) 
		and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(12)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsRace(RACE_FIEND) 
		and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(12) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_DECK,0,1,nil) and c:IsAbleToGrave() 
			and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and
				Duel.GetMZoneCount(tp,c,tp)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			if Duel.SendtoGrave(tc,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_GRAVE) then 
				return
			end
		else
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_REMOVED) then 
				return
			end
		end
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			if Duel.SendtoGrave(c,REASON_EFFECT)>0 then
				local fid=c:GetFieldID()
				c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,fid)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetLabel(Duel.GetTurnCount())
				e1:SetLabelObject(c)
				e1:SetValue(fid)
				e1:SetCondition(cm.retcon)
				e1:SetOperation(cm.retop)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				--Duel.RegisterEffect(e1,tp)
				local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
				if #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sc=sg:Select(tp,1,1,nil):GetFirst()
					Duel.HintSelection(Group.FromCards(sc))
					if Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP) then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_CANNOT_TRIGGER)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						sc:RegisterEffect(e1)
					end
					Duel.SpecialSummonComplete()
				end
			end   
		end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()>e:GetLabel() and tc:GetFlagEffectLabel(m)==e:GetValue()
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.cfilter3(c)
	return (c:IsAbleToGrave() or c:IsAbleToRemove()) and c:IsRace(RACE_MACHINE) 
		and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_DECK,0,1,nil) and c:IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetTarget(cm.sumlimit)
	e0:SetTargetRange(1,0)
	Duel.RegisterEffect(e0,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			if Duel.SendtoGrave(tc,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_GRAVE) then 
				return
			end
		else
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_REMOVED) then 
				return
			end
		end
		if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE) then
			--race
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetCondition(cm.racecon)
			e1:SetValue(RACE_MACHINE)
			Duel.RegisterEffect(e1,tp)
			--attribute
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetValue(ATTRIBUTE_DARK)
			Duel.RegisterEffect(e2,tp)  
			--untarget
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
			e3:SetReset(RESET_PHASE+PHASE_END)
			e3:SetTarget(cm.tgtg3)
			e3:SetValue(1)
			Duel.RegisterEffect(e3,tp) 
		end
	end
end
function cm.sumlimit(e,c)
	return not c:IsCode(m) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.racecon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) 
		and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY)
end
function cm.tgtgc(e,c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK)
end
