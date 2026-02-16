local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--synchro custom (Based on Tatsunoko )
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.syncon)
	e1:SetTarget(s.syntg)
	e1:SetValue(1)
	e1:SetOperation(s.synop)
	c:RegisterEffect(e1)
	--hand synchro (Based on Tatsunoko )
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetCondition(s.syncon)
	e2:SetCode(EFFECT_HAND_SYNCHRO)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--immune (Based on Ancient Gear Chaos Giant )
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	--synchro effect (Based on Synchro Transmission/Sleipnir/Pegasus/Into the VRAINS!)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.sccon)
	e4:SetTarget(s.sctg)
	e4:SetOperation(s.scop)
	c:RegisterEffect(e4)
end
--Tatsunoko Logic 
function s.synfilter(c,syncard,tuner,f)
	return c:IsFaceupEx() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function s.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=s.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(s.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function s.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
		and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL)
end
function s.syncon(e)
	return true
end
function s.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(s.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	return mg:IsExists(s.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function s.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(s.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	for i=1,maxc do
		local cg=mg:Filter(s.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if s.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
end

--Immune Logic 
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--Quick Synchro Logic
--Timing from Sleipnir 
function s.sccon(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return (tn==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2))
		or (tn==1-tp and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	--Check condition "At the time of this effect's activation" (Pegasus logic )
	if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		--Protection Application (Adapted from Into the VRAINS! )
		if e:GetLabel()==1 then
			--Cannot be negated
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			e1:SetTargetRange(1,0)
			e1:SetLabelObject(tc)
			e1:SetTarget(s.distg)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
			--Cannot activate effects
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetLabelObject(tc)
			e2:SetOperation(s.sumop)
			e2:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e2,tp)
		end
		--Perform Summon 
		Duel.SynchroSummon(tp,tc,nil)
	end
end
function s.distg(e,c)
	return c==e:GetLabelObject()
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsContains(tc) then return end
	Duel.SetChainLimitTillChainEnd(s.chainlm)
end
function s.chainlm(e,rp,tp)
	return tp==rp
end