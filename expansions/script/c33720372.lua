--[[
茧 永恒之站
Mayu, Station to Eternity
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")

local FLAG_TOKEN_MAT_COUNT	= id

function s.initial_effect(c)
	aux.CheckAlreadyRegisteredEffects()
	aux.EnabledRegisteredEffectMods[EXTRA_DECK_INFO_MODS]=true
	c:EnableReviveLimit()
	--1 Tuner + 1 non-Tuner monster
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--[[This card gains the following effects, based on the number of Tokens used for its Synchro Summon.]]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetLabel(0)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)
	--● 1+: This card is also treated as a Token.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.tkcon(1))
	e1:SetValue(TYPE_TOKEN)
	c:RegisterEffect(e1)
	--[[● 2+: You can reduce this card's Level by 2; Special Summon 1 Synchro Monster from your Extra Deck, ignoring its Summoning conditions, but its ATK/DEF become 0, its effects are negated, its
	Level becomes 2 and it is treated as a Token, also you cannot Special Summon other monsters for the rest of this turn, except Tokens.
	● 3+: If you would Special Summon a Synchro Monster using this card's effect, you can look at your opponent's Extra Deck, and Special Summon 1 Synchro Monster from their Extra Deck instead.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetFunctions(s.tkcon(2),s.spcost,s.sptg,s.spop)
	c:RegisterEffect(e2)
	--[[● 4+: If this card you control would be used as Synchro Material, you can also use monsters your opponent controls as the other materials. If you do, those monsters are treated as Level 1
	Tokens for that Synchro Summon.]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetRange(LOCATION_MZONE)
	e3:SetFunctions(s.tkcon(4),nil,s.syntg,s.synop)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(id,2)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE|EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(s.SynMixCondition(c))
	e4:SetTarget(s.SynMixTarget(c))
	e4:SetOperation(s.SynMixOperation(c))
	e4:SetValue(SUMMON_TYPE_SYNCHRO)
	local e5=aux.RegisterGrantEffect(c,LOCATION_MZONE,LOCATION_EXTRA,LOCATION_EXTRA,s.synmixfilter,e4)
	e5:SetCondition(s.tkcon(4))
end
s.effs_to_reset={}

function s.tkcon(ct,cond)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				return c:IsSynchroSummoned() and c:HasFlagEffect(FLAG_TOKEN_MAT_COUNT) and c:GetFlagEffectLabel(FLAG_TOKEN_MAT_COUNT)>=ct and (not cond or cond(e,tp,eg,ep,ev,re,r,rp))
			end
end

--E0
function s.valcheck(e,c)
	local ct=c:GetMaterial():FilterCount(Card.IsSynchroType,nil,TYPE_TOKEN)
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_UNION,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(id-1,math.min(4,ct)))
end

--E3
function s.spfilter_alt(c,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and s.spfilter_alt(c,e,tp)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLevelAbove(3) end
	xgl.UpdateLevel(c,-2,true,{c,true})
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tkaltcon=s.tkcon(3)(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then
		return Duel.IsExists(false,s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
			or (tkaltcon and Duel.IsExists(false,s.spfilter_alt,tp,0,LOCATION_EXTRA,1,nil,e,tp))
	end
	Duel.SetTargetParam(tkaltcon and 1 or 0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tkaltcon and PLAYER_ALL or tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local v=Duel.GetTargetParam()
	local extra_oppo=Group.CreateGroup()
	if v==1 then
		extra_oppo:Merge(Duel.GetExtraDeck(1-tp))
	end
	if #extra_oppo>0 then Duel.ConfirmCards(tp,extra_oppo) end
	local g=Duel.Group(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)+extra_oppo:Filter(s.spfilter,nil,e,tp)
	if #g>0 then
		Duel.HintMessage(tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetReset(RESET_EVENT|RESETS_STANDARD)
			e0:SetCode(EFFECT_SET_ATTACK_FINAL)
			e0:SetValue(0)
			tc:RegisterEffect(e0,true)
			local e0a=e0:Clone()
			e0a:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e0a,true)
			local e0b=e0:Clone()
			e0b:SetCode(EFFECT_CHANGE_LEVEL)
			e0b:SetValue(2)
			tc:RegisterEffect(e0b,true)
			local e0c=e0:Clone()
			e0c:SetCode(EFFECT_ADD_TYPE)
			e0c:SetValue(TYPE_TOKEN)
			tc:RegisterEffect(e0c,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
	end
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(c)
	e1:Desc(1,id)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT|EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsType(TYPE_TOKEN)
end

--E4
function s.synfilter1(c,syncard,tuner,f)
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
		and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL)
end
function s.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(s.synfilter1,c,syncard,c,f)
	local mg2=Duel.GetMatchingGroup(s.synfilter1,tp,0,LOCATION_MZONE,c,syncard,c,f)
	
	for tc in aux.Next(mg2) do
		tc:AssumeProperty(ASSUME_LEVEL,1)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetReset(RESET_EVENT|RESETS_STANDARD)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetValue(TYPE_TOKEN)
		tc:RegisterEffect(e0,true)
		table.insert(s.effs_to_reset,e0)
	end
	mg:Merge(mg2)
	local res=mg:IsExists(s.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
	for i=#s.effs_to_reset,1,-1 do
		s.effs_to_reset[i]:Reset()
		table.remove(s.effs_to_reset)
	end
	return res
end
function s.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(s.synfilter1,c,syncard,c,f)
	local mg2=Duel.GetMatchingGroup(s.synfilter1,tp,0,LOCATION_MZONE,c,syncard,c,f)
	for tc in aux.Next(mg2) do
		tc:AssumeProperty(ASSUME_LEVEL,1)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetReset(RESET_EVENT|RESETS_STANDARD)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetValue(TYPE_TOKEN)
		tc:RegisterEffect(e0,true)
	end
	mg:Merge(mg2)
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

--E4
function s.synmixfilter(e,c)
	return c:IsType(TYPE_SYNCHRO) and c.ExtraDeckSummonProcTable and c.ExtraDeckSummonProcTable[1]==EXTRA_DECK_PROC_SYNCHRO_MIX
end
function s.SynMixCondition(Akane)
	return	function(e,c,smat,mg1,min,max)
				if c==nil then return true end
				local _,f1,f2,f3,f4,minct,maxct,gc=table.unpack(c.ExtraDeckSummonProcTable)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
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
				if not Akane:IsCanBeSynchroMaterial(c) then
					Duel.ResetFlagEffect(tp,8173184+1)
					return false
				end
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
					mgchk=true
				else
					mg=Auxiliary.GetSynMaterials(tp,c)
				end
				
				local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,0,LOCATION_MZONE,nil,c)
				for tc in aux.Next(mg2) do
					local e0=Effect.CreateEffect(c)
					e0:SetType(EFFECT_TYPE_SINGLE)
					e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_CANNOT_DISABLE)
					e0:SetReset(RESET_EVENT|RESETS_STANDARD)
					e0:SetCode(EFFECT_ADD_TYPE)
					e0:SetValue(TYPE_TOKEN)
					tc:RegisterEffect(e0,true)
					local e1=e0:Clone()
					e1:SetCode(EFFECT_CHANGE_LEVEL)
					e1:SetValue(2)
					tc:RegisterEffect(e1,true)
					table.insert(s.effs_to_reset,e0)
					table.insert(s.effs_to_reset,e1)
				end
				mg:Merge(mg2)
				mg:AddCard(Akane)
				local res=mg:IsExists(Auxiliary.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,Akane,gc,mgchk)
				Duel.ResetFlagEffect(tp,8173184+1)
				for i=#s.effs_to_reset,1,-1 do
					s.effs_to_reset[i]:Reset()
					table.remove(s.effs_to_reset)
				end
				return res
			end
end
function s.SynMixTarget(Akane)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				local _,f1,f2,f3,f4,minct,maxct,gc=table.unpack(c.ExtraDeckSummonProcTable)
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
					mgchk=true
				else
					mg=Auxiliary.GetSynMaterials(tp,c)
				end
				
				local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,0,LOCATION_MZONE,nil,c)
				for tc in aux.Next(mg2) do
					local e0=Effect.CreateEffect(c)
					e0:SetType(EFFECT_TYPE_SINGLE)
					e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_CANNOT_DISABLE)
					e0:SetReset(RESET_EVENT|RESETS_STANDARD)
					e0:SetCode(EFFECT_ADD_TYPE)
					e0:SetValue(TYPE_TOKEN)
					tc:RegisterEffect(e0,true)
					local e1=e0:Clone()
					e1:SetCode(EFFECT_CHANGE_LEVEL)
					e1:SetValue(1)
					tc:RegisterEffect(e1,true)
					table.insert(s.effs_to_reset,e0)
					table.insert(s.effs_to_reset,e1)
				end
				mg:Merge(mg2)
				mg:AddCard(Akane)
				local c1
				local c2
				local c3
				local g4=Group.CreateGroup()
				local cancel=Duel.IsSummonCancelable()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				c1=mg:Filter(Auxiliary.SynMixFilter1,nil,f1,f2,f3,f4,minc,maxc,c,mg,Akane,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
				if not c1 then goto SynMixTargetSelectCancel end
				g:AddCard(c1)
				if f2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					c2=mg:Filter(Auxiliary.SynMixFilter2,g,f2,f3,f4,minc,maxc,c,mg,Akane,c1,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
					if not c2 then goto SynMixTargetSelectCancel end
					if g:IsContains(c2) then goto SynMixTargetSelectStart end
					g:AddCard(c2)
					if f3 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
						c3=mg:Filter(Auxiliary.SynMixFilter3,g,f3,f4,minc,maxc,c,mg,Akane,c1,c2,gc,mgchk):SelectUnselect(g,tp,false,cancel,1,1)
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
					local cg=mg2:Filter(Auxiliary.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,Akane,gc,mgchk)
					if cg:GetCount()==0 then break end
					local finish=Auxiliary.SynMixCheckGoal(tp,g4,minc,i,c,g,Akane,gc,mgchk)
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
					for i=#s.effs_to_reset,1,-1 do
						s.effs_to_reset[i]:Reset()
						table.remove(s.effs_to_reset)
					end
					return true
				end
				::SynMixTargetSelectCancel::
				Duel.ResetFlagEffect(tp,8173184+1)
				for i=#s.effs_to_reset,1,-1 do
					s.effs_to_reset[i]:Reset()
					table.remove(s.effs_to_reset)
				end
				return false
			end
end
function s.SynMixOperation(Akane)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local _,f1,f2,f3,f4,minc,maxc,gc=table.unpack(c.ExtraDeckSummonProcTable)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				for i=#s.effs_to_reset,1,-1 do
					s.effs_to_reset[i]:Reset()
					table.remove(s.effs_to_reset)
				end
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end