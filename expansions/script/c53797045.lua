local s,id,o=GetID()
s.sync=nil
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynMixCondition(aux.NonTuner(nil),nil,nil,s.matfilter1,2,99,nil))
	e1:SetTarget(s.SynMixTarget)
	e1:SetOperation(s.SynMixOperation)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.smtg)
	e2:SetOperation(s.smop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local sg=Group.CreateGroup()
		sg:KeepAlive()
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetLabelObject(sg)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		local f1=Card.GetReasonCard
		Card.GetReasonCard=function(c)
			local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+id)}
			if #eset>0 then return (eset[1]):GetLabelObject() else return f1(c) end
		end
		local f2=Card.GetBattleTarget
		Card.GetBattleTarget=function(c)
			local eset1={c:IsHasEffect(EFFECT_FLAG_EFFECT+id)}
			local eset2={c:IsHasEffect(EFFECT_FLAG_EFFECT+id+500)}
			if #eset1>0 then return (eset1[1]):GetLabelObject() elseif #eset2>0 then return (eset2[1]):GetLabelObject() else return f2(c) end
		end
		local f3=Card.GetBattledGroup
		Card.GetBattledGroup=function(c)
			local g=f3(c)
			local eset1={c:IsHasEffect(EFFECT_FLAG_EFFECT+id)}
			local eset2={c:IsHasEffect(EFFECT_FLAG_EFFECT+id+500)}
			if #eset1>0 then g:AddCard((eset1[1]):GetLabelObject()) elseif #eset2>0 then g:AddCard((eset2[1]):GetLabelObject()) end
			return g
		end
		local f4=Card.GetBattledGroupCount
		Card.GetBattledGroupCount=function(c)
			local ct=f4(c)
			local eset1={c:IsHasEffect(EFFECT_FLAG_EFFECT+id)}
			local eset2={c:IsHasEffect(EFFECT_FLAG_EFFECT+id+500)}
			if #eset1>0 or #eset2>0 then ct=ct+1 end
			return ct
		end
	end
end
s.reason=REASON_MATERIAL+REASON_SYNCHRO+REASON_BATTLE+REASON_DESTROY
function s.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsSynchroType(TYPE_TOKEN)
end
function s.SynMixTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
	local minc=2
	local maxc=99
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	::SynMixTargetSelectStart::
	local g=Group.CreateGroup()
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
		mgchk=true
	else
		mg=aux.GetSynMaterials(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	local c1
	local cancel=Duel.IsSummonCancelable()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	c1=mg:Filter(aux.SynMixFilter1,nil,aux.NonTuner(nil),nil,nil,s.matfilter1,minc,maxc,c,mg,smat,nil,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
	if not c1 then return false end
	g:AddCard(c1)
	local g4=Group.CreateGroup()
	for i=0,maxc-1 do
		local mg2=mg:Clone()
		mg2=mg2:Filter(s.matfilter1,g,c,c1)
		local cg=mg2:Filter(aux.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,nil,mgchk)
		if cg:GetCount()==0 then break end
		local finish=aux.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,nil,mgchk)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local c4=cg:SelectUnselect(g+g4,tp,finish,cancel,minc,maxc)
		if not c4 then
			if finish then break
			else return false end
		end
		if g:IsContains(c4) or g4:IsContains(c4) then goto SynMixTargetSelectStart end
		g4:AddCard(c4)
	end
	g:Merge(g4)
	if g:GetCount()>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		s.sync=c1
		return true
	else return false end
end
function s.SynMixOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local tc=s.sync
	local rs=tc:GetReason()
	tc:SetReason(s.reason)
	local f=Duel.GetBattleMonster
	Duel.GetBattleMonster=function(p)
		if p==tp then return c,tc else return tc,c end
	end
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	s.sync=nil
	if not Duel.GetOperatedGroup():IsContains(tc) then tc:SetReason(rs) else
		tc:SetReason(s.reason)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_FLAG_EFFECT+id)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+0x5fe0000)
		e1:SetLabelObject(c)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_FLAG_EFFECT+id+500)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_EVENT+0x4fe0000)
		c:RegisterEffect(e1,true)
		Duel.RaiseSingleEvent(tc,EVENT_DESTROYED,e,s.reason,tp,tp,0)
		Duel.RaiseSingleEvent(tc,EVENT_BATTLE_DESTROYED,e,0,tp,tp,0)
		Duel.RaiseSingleEvent(c,EVENT_BATTLE_DESTROYING,e,0,tp,tp,0)
		Duel.RaiseEvent(tc,EVENT_DESTROYED,e,s.reason,tp,tp,0)
		Duel.RaiseEvent(tc,EVENT_BATTLE_DESTROYED,e,0,tp,tp,0)
		Duel.RaiseEvent(c,EVENT_BATTLE_DESTROYING,e,0,tp,tp,0)
	end
	Duel.GetBattleMonster=f
	g:DeleteGroup()
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sfilter(c,e,tp)
	if not (c:IsRace(RACE_REPTILE) and c:IsControler(tp)) then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1,true)
	local res=c:IsSummonable(true,nil)
	e1:Reset()
	return res and not c:IsReason(REASON_DRAW) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.sfilter,nil,e,tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,g,1,0,0)
end
function s.smop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(s.sfilter,nil,e,tp)
	if #g==0 then return end
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	tc:RegisterFlagEffect(id+498,RESET_EVENT+0xfe0000,0,1,c:GetFieldID())
	if c:GetFlagEffect(id+497)==0 then
		c:RegisterFlagEffect(id+497,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(s.discon)
		e2:SetOperation(s.disop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2,true)
	end
	Duel.Summon(tp,g:GetFirst(),true,nil)
end
function s.disfilter(c,fid)
	for _,flag in ipairs({c:GetFlagEffectLabel(id+498)}) do if flag==fid then return true end end
	return false
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and e:GetHandler():GetFlagEffect(id+499)<Duel.GetMatchingGroupCount(s.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler():GetFieldID())
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,0,id)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
		e:GetHandler():RegisterFlagEffect(id+499,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function s.con(con)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local tc=s.sync
				if tc then tc:SetReason(s.reason) end
				return con(e,tp,eg,ep,ev,re,r,rp)
			end
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(nil,0,0xff,0xff,sg)
	if #g==0 then return end
	sg:Merge(g)
	local cp={}
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		local code=te:GetCode()
		if code==EVENT_MOVE or code==EVENT_LEAVE_FIELD or code==EVENT_REMOVE or code==EVENT_TO_DECK or code==EVENT_TO_GRAVE or code==EVENT_TO_HAND then table.insert(cp,te:Clone()) end
		return f(tc,te,bool)
	end
	local cg=Group.CreateGroup()
	for tc in aux.Next(g) do
		Duel.CreateToken(tp,tc:GetOriginalCode())
		if #cp>0 then cg:AddCard(tc) end
		cp={}
	end
	Card.RegisterEffect=function(tc,te,bool)
		local res=f(tc,te,bool)
		local con=te:GetCondition()
		if con then te:SetCondition(s.con(con)) end
		return f(tc,te,bool)
	end
	for tc in aux.Next(cg) do cm.ReplaceEffect(tc,tc:GetOriginalCode(),0) end
	Card.RegisterEffect=f
end
