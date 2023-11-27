local m=15005141
local cm=_G["c"..m]
cm.name="麦卡恩的秩序"
function cm.initial_effect(c)
	aux.AddCodeList(c,15005130)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.Tuner(nil),nil,aux.NonTuner(cm.sfilter),1,99)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(15005141)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--Hand Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.syncon)
	e1:SetTarget(cm.syntg)
	e1:SetValue(1)
	e1:SetOperation(cm.synop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(cm.mattg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--Hand Synchro
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e3:SetCondition(cm.syncon)
	e3:SetCode(EFFECT_HAND_SYNCHRO)
	e3:SetTargetRange(0,1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(cm.mattg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--add ind
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(cm.tncon)
	e5:SetOperation(cm.tnop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(cm.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	--all ind
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAIN_SOLVING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.discon)
	e7:SetOperation(cm.disop)
	c:RegisterEffect(e7)
	--SpecialSummon
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,3))
	e8:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,m)
	e8:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e8:SetTarget(cm.sptg)
	e8:SetOperation(cm.spop)
	c:RegisterEffect(e8)
end
function cm.sfilter(c)
	return c:IsRace(RACE_MACHINE)
end
function cm.mattg(e,c)
	return c:IsType(TYPE_TUNER)
end
function cm.synfilter(c,syncard,tuner,f)
	return c:IsFaceupEx() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard)) and (c:IsFaceup() or (c:IsLocation(LOCATION_HAND) and c:IsRace(RACE_MACHINE)))
end
function cm.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=cm.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(cm.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function cm.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL)
		and (g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==0 or (syncard:IsHasEffect(15005141) and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1))
end
function cm.syncon(e)
	return true
end
function cm.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(cm.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(cm.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	return mg:IsExists(cm.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(cm.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(cm.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	for i=1,maxc do
		local cg=mg:Filter(cm.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if cm.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
		for tc in aux.Next(g) do
			if tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tc) end
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetValue(LOCATION_DECK)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e1,true)
		end
	end
	Duel.SetSynchroMaterial(g)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsCode,1,nil,15005130) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetControler()==1-tp and re:IsActivated()
		and e:GetHandler():GetFlagEffect(15005142)<=0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,2)) then
		Duel.Hint(HINT_CARD,0,m)
		local c=e:GetHandler()
		--immune effect
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetTargetRange(0xff,0)
		e3:SetTarget(cm.etarget)
		e3:SetValue(cm.efilter)
		e3:SetReset(RESET_CHAIN)
		e3:SetLabel(tp)
		e3:SetLabelObject(re)
		Duel.RegisterEffect(e3,tp)
		e:GetHandler():RegisterFlagEffect(15005142,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
	end
end
function cm.etarget(e,c)
	return c:IsControler(tp)
end
function cm.efilter(e,re)
	local te=e:GetLabelObject()
	return re==te
end
function cm.spfilter(c,e,tp,sc)
	return (aux.IsCodeListed(c,15005130) or c:IsCode(15005130)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp,sc)>=1
end
function cm.spgcheck(g)
	return g:GetSum(Card.GetLevel)>=12
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp,c)
		return e:GetHandler():IsReleasable() and Duel.IsPlayerCanSpecialSummon(tp) and g:CheckSubGroup(cm.spgcheck) and not Duel.IsPlayerAffectedByEffect(tp,63060238) and not Duel.IsPlayerAffectedByEffect(tp,97148796)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsReleasable()) then return end
	if Duel.Release(c,REASON_EFFECT)~=0 and Duel.IsPlayerCanSpecialSummon(tp) then
		local ct=1
		local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local spg=Group.CreateGroup()
		local check=0
		while (ct<=dcount and check==0) do
			local g=Duel.GetDecktopGroup(tp,ct)
			local fg=g:Filter(cm.spfilter,nil,e,tp,c)
			if fg:CheckSubGroup(cm.spgcheck) then
				check=1
				spg=fg
			end
			ct=ct+1
		end
		if check==0 then
			Duel.ConfirmDecktop(tp,dcount)
			Duel.ShuffleDeck(tp)
			return
		end
		Duel.ConfirmDecktop(tp,ct-1)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or spg:GetCount()==0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if ft>=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spcg=Group.CreateGroup()
			if ft<=Duel.GetLocationCount(tp,LOCATION_MZONE) then
				spcg=spg
			else
				spcg=spg:Select(tp,ft,ft,nil)
			end
			local tc=spcg:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				tc=spcg:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end
end