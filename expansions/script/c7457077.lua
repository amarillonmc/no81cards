--冰水缔 霓石精
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
	--synchro summon
	s.AddSynchroMixProcedure(c,s.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
end
function s.matfilter1(c,syncard)
	return (c:IsTuner(syncard) or c:IsSetCard(0x16c)) and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.tgfilter(c)
	return c:IsSetCard(0x16c) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetCategory(CATEGORY_TOGRAVE)
	local ch=Duel.GetCurrentChain()
	if ch>1 and Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)==1-tp then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local ch=Duel.GetCurrentChain()
		if ch>1 then
			local p,code,te=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_EFFECT)
			if p==1-tp and te then
				local tc=te:GetHandler()
				if tc and tc:IsRelateToEffect(te) and tc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					Duel.BreakEffect()
					Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				end
			end
		end
	end
end

-----------------synchro summon----------------------

---Synchro monster, f1~f3 each 1 MONSTER + f4 min to max monsters
---@param c Card
---@param f1 function|nil
---@param f2 function|nil
---@param f3 function|nil
---@param f4 function|nil
---@param minc integer
---@param maxc integer
---@param gc? function
function s.AddSynchroMixProcedure(c,f1,f2,f3,f4,minc,maxc,gc)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetTarget(s.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetOperation(s.SynMixOperation(f1,f2,f3,f4,minc,maxc,gc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function s.SynMaterialFilter(c,syncard)
	return c:IsFaceupEx() and c:IsCanBeSynchroMaterial(syncard)
end
function s.SynMaterialFilterExtra(c,syncard)
	return c.IsCanBeSynchroMaterial(syncard) and c:IsSetCard(0x16c)-- and Debug.Message("1")
end
function s.GetSynMaterials(tp,syncard)
	local mg=Duel.GetSynchroMaterial(tp):Filter(aux.SynMaterialFilter,nil,syncard)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	if Duel.GetFlagEffect(tp,id)==0 then
		--Debug.Message("0")
		local mg3=Duel.GetMatchingGroup(s.SynMaterialFilterExtra,tp,LOCATION_REMOVED,0,nil,syncard)
		if mg3:GetCount()>0 then mg:Merge(mg3) end
	end
	return mg
end
function s.SynMixCondition(f1,f2,f3,f4,minct,maxct,gc)
	return  function(e,c,smat,mg1,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				--Debug.Message("3")
				local minc=minct
				local maxc=maxct
				if min then
					local exct=0
					if f2 then exct=exct+1 end
					if f3 then exct=exct+1 end
					if min-exct>minc then minc=min-exct end
					if max-exct<maxc then maxc=max-exct end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				if Duel.IsPlayerAffectedByEffect(tp,8173184) then
					Duel.RegisterFlagEffect(tp,8173184+1,0,0,1)
				end
				if smat and not smat:IsCanBeSynchroMaterial(c) then
					Duel.ResetFlagEffect(tp,8173184+1)
					return false
				end
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
					mgchk=true
				else
					mg=s.GetSynMaterials(tp,c)
					--if mg and #mg>0 then Duel.HintSelection(mg) end
					--Debug.Message("0")
				end
				--Debug.Message("5")
				if smat~=nil then mg:AddCard(smat) end
				local res=mg:IsExists(s.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk)
				Duel.ResetFlagEffect(tp,8173184+1)
				return res
			end
end
function s.SynMixTarget(f1,f2,f3,f4,minct,maxct,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				local minc=minct
				local maxc=maxct
				if min then
					local exct=0
					if f2 then exct=exct+1 end
					if f3 then exct=exct+1 end
					if min-exct>minc then minc=min-exct end
					if max-exct<maxc then maxc=max-exct end
					if minc>maxc then return false end
				end
				::SynMixTargetSelectStart::
				if Duel.IsPlayerAffectedByEffect(tp,8173184) then
					Duel.RegisterFlagEffect(tp,8173184+1,0,0,1)
				end
				local g=Group.CreateGroup()
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
					--Debug.Message("1")
					mgchk=true
				else
					mg=s.GetSynMaterials(tp,c)
					--Debug.Message("0")
				end
				if smat~=nil then mg:AddCard(smat) end
				local c1
				local c2
				local c3
				local g4=Group.CreateGroup()
				local cancel=Duel.IsSummonCancelable()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				c1=mg:Filter(s.SynMixFilter1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
				if not c1 then goto SynMixTargetSelectCancel end
				g:AddCard(c1)
				if f2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					c2=mg:Filter(s.SynMixFilter2,g,f2,f3,f4,minc,maxc,c,mg,smat,c1,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
					if not c2 then goto SynMixTargetSelectCancel end
					if g:IsContains(c2) then goto SynMixTargetSelectStart end
					g:AddCard(c2)
					if f3 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
						c3=mg:Filter(s.SynMixFilter3,g,f3,f4,minc,maxc,c,mg,smat,c1,c2,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
						if not c3 then goto SynMixTargetSelectCancel end
						if g:IsContains(c3) then goto SynMixTargetSelectStart end
						g:AddCard(c3)
					end
				end
				for i=0,maxc-1 do
					local mg2=mg:Clone()
					if f4 then
						mg2=mg2:Filter(f4,g,c,c1,c2,c3)
					else
						mg2:Sub(g)
					end
					local cg=mg2:Filter(s.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,gc,mgchk,c1)
					if cg:GetCount()==0 then break end
					local finish=s.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,gc,mgchk,c1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local c4=cg:SelectUnselect(g+g4,tp,finish,cancel,minc,maxc)
					if not c4 then
						if finish then break
						else goto SynMixTargetSelectCancel end
					end
					if g:IsContains(c4) or g4:IsContains(c4) then goto SynMixTargetSelectStart end
					g4:AddCard(c4)
				end
				g:Merge(g4)
				if g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					Duel.ResetFlagEffect(tp,8173184+1)
					return true
				end
				::SynMixTargetSelectCancel::
				Duel.ResetFlagEffect(tp,8173184+1)
				return false
			end
end
function s.SynMixOperation(f1,f2,f3,f4,minct,maxct,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				local reg=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
				--Debug.Message("0")
				if #reg>0 then
					Duel.SendtoGrave(reg,REASON_MATERIAL+REASON_SYNCHRO+REASON_RETURN)
					Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
					g:Sub(reg)
					if #g<=0 then g:DeleteGroup() return end
				--Debug.Message("1")
				end
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
				--Debug.Message("2")
			end
end
function s.SynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat,gc,mgchk)
			--Debug.Message("4")
	return (not f1 or f1(c,syncard)) and mg:IsExists(s.SynMixFilter2,1,c,f2,f3,f4,minc,maxc,syncard,mg,smat,c,gc,mgchk)
end
function s.SynMixFilter2(c,f2,f3,f4,minc,maxc,syncard,mg,smat,c1,gc,mgchk)
	if f2 then
		return f2(c,syncard,c1)
			and (mg:IsExists(s.SynMixFilter3,1,Group.FromCards(c1,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c,gc,mgchk)
				or minc==0 and s.SynMixFilter4(c,nil,1,1,syncard,mg,smat,c1,nil,nil,gc,mgchk))
	else
		return mg:IsExists(s.SynMixFilter4,1,c1,f4,minc,maxc,syncard,mg,smat,c1,nil,nil,gc,mgchk)
	end
end
function s.SynMixFilter3(c,f3,f4,minc,maxc,syncard,mg,smat,c1,c2,gc,mgchk)
	if f3 then
		return f3(c,syncard,c1,c2)
			and (mg:IsExists(s.SynMixFilter4,1,Group.FromCards(c1,c2,c),f4,minc,maxc,syncard,mg,smat,c1,c2,c,gc,mgchk)
				or minc==0 and s.SynMixFilter4(c,nil,1,1,syncard,mg,smat,c1,c2,nil,gc,mgchk))
	else
		return mg:IsExists(s.SynMixFilter4,1,Group.FromCards(c1,c2),f4,minc,maxc,syncard,mg,smat,c1,c2,nil,gc,mgchk)
	end
end
function s.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,sg,syncard,c1,c2,c3)
	else
		mg:Sub(sg)
	end
	--			Debug.Message("7")
	return s.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc,mgchk,c1)
end
function s.SynMixCheck(mg,sg1,minc,maxc,syncard,smat,gc,mgchk,c1)
	local tp=syncard:GetControler()
	local sg=Group.CreateGroup()
	--			Debug.Message("8")
	if minc<=0 and s.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat,gc,mgchk,c1) then return true end
	if maxc==0 then return false end
	return mg:IsExists(s.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat,gc,mgchk,c1)
end
function s.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk,c1)
	sg:AddCard(c)
	ct=ct+1
	local res=s.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk,c1)
		or (ct<maxc and mg:IsExists(s.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk,c1))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function s.GetSynchroLevel(c,syncard,c1)
	if c==c1 and c:IsSetCard(0x16c) then
		local lv=c:GetSynchroLevel(syncard)
		local lv2=aux.GetCappedLevel(c)
		if lv~=0 and c:IsType(TYPE_TUNER) then
			--	Debug.Message("4")
			return (3<<16)+lv2
		else
			return 3
		end
	else
		return c:GetSynchroLevel(syncard)
	end
end
function s.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk,c1)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	--Debug.Message("0")
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	--Debug.Message("1")
	if gc and not gc(g) then return false end
	--Debug.Message("2")
	if smat and not g:IsContains(smat) then return false end
	--Debug.Message("3")
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	--Debug.Message("4")
	if Duel.IsPlayerAffectedByEffect(tp,8173184)
		and not g:IsExists(aux.Tuner(Card.IsSetCard,0x2),1,nil,syncard) then return false end
	--Debug.Message("5")
	--synchro level
	local e0=Effect.CreateEffect(c1)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCode(EFFECT_SYNCHRO_LEVEL)
	e0:SetValue(s.slevel)
	c1:RegisterEffect(e0)
	local boolean=g:CheckWithSumEqual(Card.GetSynchroLevel,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard)
	e0:Reset()
	if not boolean
		and (not g:IsExists(Card.IsHasEffect,1,nil,89818984)
		or not g:CheckWithSumEqual(aux.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard))
		then return false end
	--Debug.Message("6")
	if not (mgchk or aux.SynMixHandCheck(g,tp,syncard)) then return false end
	--Debug.Message("7")
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
	--Debug.Message("8")
	return true
end
function s.slevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	return (3<<16)+lv
end
