--召唤之魔导书
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--remian instead of send to grave
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVED)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetCondition(s.rmcon)
	e0:SetOperation(s.rmop)
	Duel.RegisterEffect(e0,tp)
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(s.effop)
	Duel.RegisterEffect(e1,tp)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
		and rc:IsType(TYPE_SPELL) and rc:IsRelateToEffect(re) and rc:IsStatus(STATUS_LEAVE_CONFIRMED) and rc:IsSetCard(0x106e) and (rc:GetSequence()==0 or rc:GetSequence()==4)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local rc=re:GetHandler()
	rc:CancelToGrave()
	--remain field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
	--destory
	local fid=rc:GetFieldID()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetLabel(fid)
	e4:SetLabelObject(rc)
	e4:SetCondition(s.descon)
	e4:SetOperation(s.desop)
	Duel.RegisterEffect(e4,tp)
	--
	rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function s.efffilter(c)
	return c:GetSequence()==0 and c:IsSetCard(0x106e) and c:GetFlagEffect(id+1)==0 and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local g=Duel.GetMatchingGroup(s.efffilter,tp,LOCATION_SZONE,0,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		if not aux.PendulumChecklist then
			aux.PendulumChecklist=0
			local ge1=Effect.GlobalEffect()
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
			ge1:SetOperation(aux.PendulumReset)
			Duel.RegisterEffect(ge1,0)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCondition(s.PendCondition())
		e1:SetOperation(s.PendOperation())
		e1:SetValue(SUMMON_TYPE_PENDULUM)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.rpzfilter(c)
	return c:GetSequence()==4 and c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function s.PConditionFilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	if c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) then lv=7 end
	local bool=aux.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND|LOCATION_GRAVE|LOCATION_REMOVED) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and 
		((c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)) or (c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x106e,TYPES_NORMAL_TRAP_MONSTER,0,0,7,RACE_SPELLCASTER,ATTRIBUTE_LIGHT)))
		and not c:IsForbidden()
		and (aux.PendulumChecklist&(0x1<<tp)==0 or aux.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end
function s.PendCondition()
	return  function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				if Auxiliary.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
				local rpz=Duel.GetMatchingGroup(s.rpzfilter,tp,LOCATION_SZONE,0,nil):GetFirst()
				if rpz==nil or c==rpz then return false end
				local lscale=6
				local rscale=8
				--if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED end
				if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(s.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
			end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.PendOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local rpz=Duel.GetMatchingGroup(s.rpzfilter,tp,LOCATION_SZONE,0,nil):GetFirst()
				local lscale=6
				local rscale=8
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				local tg=nil
				local loc=0
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
				local ft=Duel.GetUsableMZoneCount(tp)
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and ect<ft2 then ft2=ect end
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				if ft1>0 then loc=loc|LOCATION_HAND|LOCATION_GRAVE|LOCATION_REMOVED end
				if ft2>0 then loc=loc|LOCATION_EXTRA end
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(s.PConditionFilter,nil,e,tp,lscale,rscale,eset)
				else
					tg=Duel.GetMatchingGroup(s.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
				end
				local ce=nil
				local b1=Auxiliary.PendulumChecklist&(0x1<<tp)==0
				local b2=#eset>0
				if b1 and b2 then
					local options={1163}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					if op>0 then
						ce=eset[op]
					end
				elseif b2 and not b1 then
					local options={}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					ce=eset[op+1]
				end
				if ce then
					tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				aux.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
				local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
				aux.GCheckAdditional=nil
				if not g then return end
				if ce then
					Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
					ce:UseCountLimit(tp)
				else
					aux.PendulumChecklist=aux.PendulumChecklist|(0x1<<tp)
				end
				sg:Merge(g)
				if KOISHI_CHECK then 
					c:SetCardData(CARDDATA_LSCALE,6)
					rpz:SetCardData(CARDDATA_LSCALE,8)
				end
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
				--
				local spellg=sg:Filter(s.spellfilter,nil)
				local exgc=sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
				for tc in aux.Next(spellg) do
					--spsummon limit
					--local e0=Effect.CreateEffect(tc)
					--e0:SetType(EFFECT_TYPE_SINGLE)
					--e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+ EFFECT_FLAG_UNCOPYABLE)
					--e0:SetCode(EFFECT_SPSUMMON_CONDITION)
					--e0:SetReset(RESET_EVENT+0x47c0000)
					--e0:SetValue(aux.penlimit)
					--tc:RegisterEffect(e0,true)
					--local mt=getmetatable(tc)
					--local loc=mt.psummonable_location
					--if loc==nil then 
					-- loc=0xff 
					-- mt.psummonable_location=loc
					--end
					if KOISHI_CHECK then
						tc:RegisterFlagEffect(id+2,0,0,1,tc:GetOriginalType())
						tc:SetCardData(CARDDATA_TYPE,TYPE_NORMAL+TYPE_MONSTER)
					end
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
					e1:SetReset(RESET_EVENT+0x47c0000)
					tc:RegisterEffect(e1,true)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_ADD_RACE)
					e2:SetValue(RACE_SPELLCASTER)
					tc:RegisterEffect(e2,true)
					local e3=e1:Clone()
					e3:SetCode(EFFECT_ADD_ATTRIBUTE)
					e3:SetValue(ATTRIBUTE_LIGHT)
					tc:RegisterEffect(e3,true)
					local e4=e1:Clone()
					e4:SetCode(EFFECT_SET_BASE_ATTACK)
					e4:SetValue(0)
					tc:RegisterEffect(e4,true)
					local e5=e1:Clone()
					e5:SetCode(EFFECT_SET_BASE_DEFENSE)
					e5:SetValue(0)
					tc:RegisterEffect(e5,true)
					local e6=e1:Clone()
					e6:SetCode(EFFECT_CHANGE_LEVEL)
					e6:SetValue(7)
					tc:RegisterEffect(e6,true)
					--tc:SetStatus(STATUS_EFFECT_ENABLED,true)
					--tc:SetStatus(STATUS_PROC_COMPLETE,true)
					--tc:SetStatus(STATUS_SUMMONING,true)
					if not KOISHI_CHECK then
						local zone=0xff
						if exgc>=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM) then
							local lzone=Duel.GetLinkedZone(tp)
							zone=zone~lzone
						end
						Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP,zone)
					end
				end
				if #spellg>0 and KOISHI_CHECK then
					--summon cost
					local ge0=Effect.CreateEffect(c)
					ge0:SetType(EFFECT_TYPE_FIELD)
					ge0:SetCode(EFFECT_SPSUMMON_COST)
					ge0:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0)
					ge0:SetLabelObject(spellg)
					ge0:SetCost(s.costchk)
					ge0:SetOperation(s.costop)
					Duel.RegisterEffect(ge0,tp)
					spellg:KeepAlive()
				end
				if not KOISHI_CHECK then
					Duel.SpecialSummonComplete()
				end
				--Duel.SpecialSummon(spellg,SUMMON_TYPE_PENDULUM,tp,tp,true,false,POS_FACEUP)
			end
end
function s.costchk(e,c,tp)
	return true
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then 
		for tc in aux.Next(g) do
			if tc:GetFlagEffect(id+2)~=0 then
				tc:SetCardData(CARDDATA_TYPE,tc:GetFlagEffectLabel(id+2))
				tc:ResetFlagEffect(id+2)
			end
		end
	end
	e:Reset()
end
function s.spellfilter(c)
	return c:IsSetCard(0x106e) and c:IsType(TYPE_SPELL)
end
