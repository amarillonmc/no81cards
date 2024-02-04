--高速疾行机人 纸模空间船
--21.09.14
local cm,m=GetID()
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	aux.AddSynchroProcedure(c,cm.tfilter,cm.ntfilter,1)
	c:EnableReviveLimit()
	--twist synchro
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC_G)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.spcon)
	e0:SetOperation(cm.spop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(cm.sycon)
	e1:SetTarget(cm.sytg)
	e1:SetOperation(cm.syop)
	c:RegisterEffect(e1)
	--Dice!!
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(cm.diceop)
	c:RegisterEffect(e2)
end
function cm.tfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER)
end
function cm.ntfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and not c:IsType(TYPE_TUNER)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true)
end
function cm.chkfilter(g,c,e,tp)
	local bg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,c,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,TYPE_SYNCHRO)>1 and bg:IsExists(cm.synfilter2,1,nil,g)
end
function cm.synfilter2(c,g)
	for mc in aux.Next(g) do
		if not mc:IsCanBeSynchroMaterial(c) then return false end
	end
	return true
end
function cm.SynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat,gc,mgchk,e)
	return (not f1 or f1(c,syncard)) and mg:IsExists(cm.SynMixFilter2,1,c,f2,f3,f4,minc,maxc,syncard,mg,smat,c,gc,mgchk,e)
end
function cm.SynMixFilter2(c,f2,f3,f4,minc,maxc,syncard,mg,smat,c1,gc,mgchk,e)
	if f2 then
		return f2(c,syncard,c1) and mg:IsExists(cm.SynMixFilter3,1,Group.FromCards(c1,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c,gc,mgchk,e)
	else
		return mg:IsExists(cm.SynMixFilter4,1,c1,f4,minc,maxc,syncard,mg,smat,c1,nil,nil,gc,mgchk,e)
	end
end
function cm.SynMixFilter3(c,f3,f4,minc,maxc,syncard,mg,smat,c1,c2,gc,mgchk,e)
	if f3 then
		return f3(c,syncard,c1,c2) and mg:IsExists(cm.SynMixFilter4,1,Group.FromCards(c1,c2,c),f4,minc,maxc,syncard,mg,smat,c1,c2,c,gc,mgchk,e)
	else
		return mg:IsExists(cm.SynMixFilter4,1,Group.FromCards(c1,c2),f4,minc,maxc,syncard,mg,smat,c1,c2,nil,gc,mgchk,e)
	end
end
function cm.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk,e)
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,sg,syncard)
	else
		mg:Sub(sg)
	end
	return cm.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc,mgchk,e)
end
function cm.SynMixCheck(mg,sg1,minc,maxc,syncard,smat,gc,mgchk,e)
	local tp=syncard:GetControler()
	local sg=Group.CreateGroup()
	if minc==0 and cm.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat,gc,mgchk,e) then return true end
	if maxc==0 then return false end
	return mg:IsExists(cm.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat,gc,mgchk,e)
end
function cm.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk,e)
	sg:AddCard(c)
	ct=ct+1
	local res=cm.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk,e)
		or (ct<maxc and mg:IsExists(cm.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk,e))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function cm.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk,e)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if gc and not gc(g,syncard,e,tp) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	if not g:CheckWithSumEqual(Card.GetSynchroLevel,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard)
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(aux.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
		then return false end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=hg:GetCount()
	if hct>0 and not mgchk then
		local found=false
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(aux.SynLimitFilter,1,c,hf,he,syncard) then return false end
				if (hmin and hct<hmin) or (hmax and hct>hmax) then return false end
			end
		end
		if not found then return false end
	end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(aux.SynLimitFilter,1,c,lf,le,syncard) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end
function cm.spcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<2 then return false end
	local bg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,c,e,tp)
	if #bg==0 then return false end
	local mg=aux.GetSynMaterials(tp,c)
	return mg:IsExists(cm.SynMixFilter1,1,nil,cm.tfilter,nil,nil,cm.ntfilter,1,99,c,mg,nil,cm.chkfilter,false,e) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<2 then return false end
	local bg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,c,e,tp)
	if #bg==0 then return false end
	local g=Group.CreateGroup()
	local mg=aux.GetSynMaterials(tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local c1=mg:FilterSelect(tp,cm.SynMixFilter1,1,1,nil,cm.tfilter,nil,nil,cm.ntfilter,1,99,c,mg,nil,cm.chkfilter,false,e):GetFirst()
	g:AddCard(c1)
	local g4=Group.CreateGroup()
	for i=0,98 do
		local mg2=mg:Filter(cm.ntfilter,g,c)
		local cg=mg2:Filter(cm.SynMixCheckRecursive,g4,tp,g4,mg2,i,1,99,c,g,nil,cm.chkfilter,false,e)
		if #cg==0 then break end
		local minct=1
		if cm.SynMixCheckGoal(tp,g4,1,i,c,g,nil,cm.chkfilter,false,e) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=cg:Select(tp,minct,1,nil)
		if #tg==0 then break end
		g4:Merge(tg)
	end
	g:Merge(g4)
	if #g>0 then
		local bg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,c,e,tp):Filter(cm.synfilter2,nil,g)
		if #bg==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local bc=bg:Select(tp,1,1,nil):GetFirst()
		sg:AddCard(bc)
		sg:AddCard(c)
		bc:SetMaterial(g)
		c:SetMaterial(g)
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
		g:KeepAlive()
		local _GetReasonCard=Card.GetReasonCard
		function Card.GetReasonCard(gc)
			local res=_GetReasonCard(gc)
			local ref=c:GetReasonEffect()
			if res==c and ref and ref:GetCode()==EFFECT_SPSUMMON_PROC_G then return bc end
			return res
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_OATH)
		e1:SetLabelObject(g)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.adjustop2)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.adjustop2(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		tc:CompleteProcedure()
	end
	local g=e:GetLabelObject()
	Duel.RaiseEvent(g,EVENT_BE_MATERIAL,nil,REASON_SYNCHRO,tp,tp,0)
	for tc in aux.Next(g) do
		Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,nil,REASON_SYNCHRO,tp,tp,0)
	end
	g:DeleteGroup()
	e:Reset()
end
function cm.sycon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.syfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSynchroSummonable(nil)
end
function cm.sytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.syfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.syop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.syfilter,tp,LOCATION_EXTRA,0,nil,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		--[[local mg=aux.GetSynMaterials(tp,sg:GetFirst())
		for tc in aux.Next(mg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetTarget(cm.syntg)
			e1:SetValue(1)
			e1:SetOperation(cm.synop)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EVENT_MOVE)
			e2:SetCountLimit(1)
			e2:SetLabelObject(e1)
			e2:SetOperation(cm.adjustop)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end--]]
		local sc=sg:GetFirst()
		local _SendToGrave=Duel.SendtoGrave
		Duel.SendtoGrave=function(g,r)
							if r==REASON_MATERIAL+REASON_SYNCHRO and #g>0 and Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO+REASON_TEMPORARY)>0 then
								local fid=sc:GetFieldID()
								local og=Duel.GetOperatedGroup():Filter(cm.rffilter,nil)
								for oc in aux.Next(og) do
									oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
								end
								og:KeepAlive()
								local e1=Effect.CreateEffect(sc)
								e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
								e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
								e1:SetCode(EVENT_PHASE+PHASE_END)
								e1:SetCountLimit(1)
								e1:SetLabel(fid)
								e1:SetLabelObject(og)
								e1:SetCondition(cm.retcon)
								e1:SetOperation(cm.retop)
								e1:SetReset(RESET_PHASE+PHASE_END)
								Duel.RegisterEffect(e1,tp)
								Duel.SendtoGrave=_SendToGrave
								return #og
							else
								return _SendToGrave(tg,r)
							end
						end
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
function cm.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te and aux.GetValueType(te)=="Effect" then te:Reset() end
	e:Reset()
end
function cm.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=cm.syngoal(g,tp,lv,syncard,minc,ct) or (ct<maxc and mg:IsExists(cm.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function cm.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard) and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
end
function cm.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=aux.GetSynMaterials(tp,syncard):Filter(f,nil,syncard)
	return mg:IsExists(cm.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=aux.GetSynMaterials(tp,syncard):Filter(f,nil,syncard)
	for i=1,maxc do
		local cg=mg:Filter(cm.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if #cg==0 then break end
		local minct=1
		if cm.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if #sg==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO+REASON_TEMPORARY)>0 then
		local fid=c:GetFieldID()
		local og=Duel.GetOperatedGroup()
		for oc in aux.Next(og) do
			oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetOwner())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_SEND_REPLACE)
		e2:SetTarget(function(e) return e:GetLabel()==0 end)
		e2:SetValue(function(e,c) e:SetLabel(100) return c:GetFlagEffect(m)~=0 end)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.retfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.retfilter2(c,p,loc)
	return c:IsPreviousControler(p) and c:IsPreviousLocation(loc)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local ft,mg,ng={},{},Group.CreateGroup()
	ft[1]=Duel.GetLocationCount(tp,LOCATION_MZONE)
	ft[2]=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	ft[3]=Duel.GetLocationCount(tp,LOCATION_SZONE)
	ft[4]=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	mg[1]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_MZONE)
	mg[2]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_MZONE)
	mg[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_SZONE)
	mg[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_SZONE)
	for i=1,4 do
		if #mg[i]>ft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local tg=mg[i]:Select(tp,ft[i],ft[i],nil)
			local rg=mg[i]-tg
			sg:Sub(rg)
			ng:Merge(rg)
		end
	end
	for tc in aux.Next(sg) do
		if tc:GetPreviousLocation()&LOCATION_ONFIELD>0 then
			Duel.ReturnToField(tc)
			--Duel.MoveToField(tc,tp,tc:GetPreviousControler(),tc:GetPreviousLocation(),tc:GetPreviousPosition(),true)
		elseif tc:IsPreviousLocation(LOCATION_HAND) then
			Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		end
	end
	Duel.SendtoGrave(ng,REASON_RULE+REASON_RETURN)
end
function cm.diceop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_DICE_NEGATE)
	e1:SetLabel(d)
	e1:SetOperation(cm.diceop2)
	Duel.RegisterEffect(e1,tp)
end
function cm.diceop2(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabel()
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if cm[0]~=cid and Duel.SelectYesNo(tp,aux.Stringid(m,d+3)) then
		Duel.Hint(HINT_CARD,0,m)
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=bit.band(ev,0xff)+bit.rshift(ev,16)
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(aux.idx_table,1,ct))
			ac=idx+1
		end
		dc[ac]=d
		Duel.SetDiceResult(table.unpack(dc))
		cm[0]=cid
	end
end