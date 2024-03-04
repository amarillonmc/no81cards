--翼のスコシアクマ
function c49811310.initial_effect(c)
	c:EnableReviveLimit()
	--aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsLevel,1),aux.NonTuner(nil),1,1)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c49811310.SynCondition)
	e0:SetTarget(c49811310.SynTarget)
	e0:SetOperation(c49811310.SynOperation)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811310,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c49811310.rmtg)
	e1:SetOperation(c49811310.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811310,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811310)
	e2:SetTarget(c49811310.sptg)
	e2:SetOperation(c49811310.spop)
	c:RegisterEffect(e2)
end
function c49811310.CheckGroup(g,f,cg,min,max,...)
	if cg then Duel.SetSelectedCard(cg) end
	return g:CheckSubGroup(f,min,max,...)
end
function c49811310.SelectGroupNew(tp,desc,cancelable,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	if cg then Duel.SetSelectedCard(cg) end
	Duel.Hint(tp,HINT_SELECTMSG,desc)
	return g:SelectSubGroup(tp,f,cancelable,min,max,...)
end
function c49811310.SelectGroup(tp,desc,g,f,cg,min,max,...)
	return c49811310.SelectGroupNew(tp,desc,false,g,f,cg,min,max,...)
end
function c49811310.matfilter1(c,syncard,tp)
	if c:IsFacedown() then return false end
	if c:IsSynchroType(TYPE_XYZ) or c:IsSynchroType(TYPE_LINK) then return false end 
	return c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard) and c:IsLevel(1)
end
function c49811310.matfilter2(c,syncard)
	if c:IsSynchroType(TYPE_XYZ) or c:IsSynchroType(TYPE_LINK) then return false end 
	return not c:IsSynchroType(TYPE_TUNER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c49811310.val(c,syncard)
	if not c:IsSummonableCard() and not c:IsSynchroType(TYPE_TUNER) then
		return 3
	else
		return c:GetSynchroLevel(syncard)
	end
end
function c49811310.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(c49811310.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function c49811310.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return c49811310.CheckGroup(tsg,c49811310.goal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c)
end
function c49811310.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(c49811310.val,lv,ct,ct,syncard)
end
function c49811310.SynCondition(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	local minc=2
	local maxc=2
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c49811310.matfilter1,nil,c,tp)
		g2=mg:Filter(c49811310.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c49811310.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(c49811310.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c49811310.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return c49811310.matfilter1(c,tp) and c49811310.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	elseif pe then
		return c49811310.matfilter1(pe:GetOwner(),tp) and c49811310.synfilter(pe:GetOwner(),c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(c49811310.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function c49811310.SynTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local minc=2
	local maxc=2
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c49811310.matfilter1,nil,c,tp)
		g2=mg:Filter(c49811310.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c49811310.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(c49811310.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c49811310.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuner=tuc
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local t1=g1:FilterSelect(tp,c49811310.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp)
			tuc=t1:GetFirst()
		else
			tuc=pe:GetOwner()
			Group.FromCards(tuc):Select(tp,1,1,nil)
		end
	end
	tuc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
	local tsg=tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=tuc.tuner_filter
	if tuc.tuner_filter then tsg=tsg:Filter(f,nil) end
	local g=c49811310.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,c49811310.goal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c49811310.SynOperation(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c49811310.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg1=Duel.GetDecktopGroup(tp,1)
	local rg2=Duel.GetDecktopGroup(1-tp,1)
	rg1:Merge(rg2)
	if chk==0 then return rg1:FilterCount(Card.IsAbleToRemove,nil)==2 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg1,2,0,0)
end
function c49811310.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsRace(RACE_WINDBEAST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811310.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg1=Duel.GetDecktopGroup(tp,1)
	local rg2=Duel.GetDecktopGroup(1-tp,1)
	rg1:Merge(rg2)
	if #rg1<=0 then return end
	Duel.DisableShuffleCheck()
	if Duel.Remove(rg1,POS_FACEUP,REASON_EFFECT)~=0
		and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c49811310.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(49811310,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c49811310.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c49811310.thfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_WINDBEAST+RACE_BEAST) and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToHand()
end
function c49811310.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c49811310.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c49811310.thfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c49811310.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c49811310.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_HAND)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c49811310.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c49811310.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_WINDBEAST+RACE_BEAST)
end