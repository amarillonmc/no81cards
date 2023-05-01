local m=53759012
local cm=_G["c"..m]
cm.name="异次元魔导 因蒂维加尔"
cm.Card_Prophecy_LV12=true
cm.Snnm_Ef_Rst=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	if not Card_Prophecy_Check then
		Card_Prophecy_Check=true
		Duel.RegisterFlagEffect(0,53759000,0,0,0,0)
		Duel.RegisterFlagEffect(0,53759099,0,0,0,m)
		cm[2]=Duel.IsExistingMatchingCard
		Duel.IsExistingMatchingCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=cm[2](...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=cm[2](...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[3]=Duel.SelectMatchingCard
		Duel.SelectMatchingCard=function(sp,f,p,s,o,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			cm[4](f,p,s,o,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=cm[3](sp,f,p,s,o,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[4]=Duel.GetMatchingGroup
		Duel.GetMatchingGroup=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=cm[4](...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=cm[4](...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[5]=Duel.GetMatchingGroupCount
		Duel.GetMatchingGroupCount=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=cm[5](...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=cm[5](...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[6]=Duel.GetFirstMatchingCard
		Duel.GetFirstMatchingCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=cm[6](...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=cm[6](...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[7]=Group.IsExists
		Group.IsExists=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=cm[7](...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=cm[7](...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[8]=Group.Filter
		Group.Filter=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=cm[8](...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=cm[8](...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[9]=Group.FilterCount
		Group.FilterCount=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=cm[9](...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=cm[9](...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[10]=Group.Remove
		Group.Remove=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=cm[10](...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=cm[10](...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[11]=Group.SearchCard
		Group.SearchCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=cm[11](...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=cm[11](...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[12]=Group.FilterSelect
		Group.FilterSelect=function(g,p,f,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			cm[8](g,f,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=cm[12](g,p,f,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[13]=Group.CheckSubGroup
		Group.CheckSubGroup=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=cm[13](...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=cm[13](...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[14]=Group.SelectSubGroup
		Group.SelectSubGroup=function(g,p,f,bool,min,max,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			cm[13](g,f,min,max,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=cm[14](g,p,f,bool,min,max,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[15]=Duel.IsExistingTarget
		Duel.IsExistingTarget=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local b=cm[15](...)
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[16]=Duel.SelectTarget
		Duel.SelectTarget=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local b=cm[16](...)
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[50]=Duel.DiscardHand
		Duel.DiscardHand=function(p,f,min,max,reason,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			cm[4](f,p,LOCATION_HAND,LOCATION_HAND,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=cm[50](p,f,min,max,reason,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[51]=Duel.SelectReleaseGroup
		Duel.SelectReleaseGroup=function(p,f,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			cm[4](f,p,LOCATION_MZONE,LOCATION_MZONE,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=cm[51](p,f,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		cm[52]=Duel.SelectReleaseGroupEx
		Duel.SelectReleaseGroupEx=function(p,f,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			cm[4](f,p,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE+LOCATION_HAND,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=cm[52](p,f,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
	end
	if not Card_Prophecy_Cheat_1 then
		Card_Prophecy_Cheat_1=true
		local class=_G["c"..Duel.GetFlagEffectLabel(0,53759099)]
		cm[17]=Card.IsCanBeSpecialSummoned
		Card.IsCanBeSpecialSummoned=function(sc,se,st,sp,bool1,bool2,spos,stp,sz)
			if not spos then spos=POS_FACEUP end
			if not stp then stp=sp end
			if not sz then sz=0xff end
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			if lv>0 and (ly>0 or Duel.GetFlagEffectLabel(0,53759000)==0) and not sc:IsLocation(LOCATION_MZONE) then
				if lv==12 and not bool1 then b=false end
				local zcheck=false
				for i=0,6 do
					if sz&(1<<i)~=0 and Duel.CheckLocation(stp,LOCATION_MZONE,i) then zcheck=true end
					if sz&(1<<(i+16))~=0 and Duel.CheckLocation(stp,LOCATION_MZONE,i+16) then zcheck=true end
					if zcheck then break end
				end
				if not zcheck then b=false end
				local e1=Effect.CreateEffect(sc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
				sc:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RACE)
				e2:SetValue(RACE_SPELLCASTER)
				sc:RegisterEffect(e2,true)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e3:SetValue(ATTRIBUTE_DARK)
				sc:RegisterEffect(e3,true)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_BASE_ATTACK)
				e4:SetValue(lv*500/2+500)
				sc:RegisterEffect(e4,true)
				local e5=e1:Clone()
				e5:SetCode(EFFECT_SET_BASE_DEFENSE)
				e5:SetValue(lv*500/2+500)
				sc:RegisterEffect(e5,true)
				local e6=e1:Clone()
				e6:SetCode(EFFECT_CHANGE_LEVEL)
				e6:SetValue(lv)
				sc:RegisterEffect(e6,true)
				if sc:IsHasEffect(EFFECT_CANNOT_SPECIAL_SUMMON) then b=false end
				local re={sc:IsHasEffect(EFFECT_SPSUMMON_COST)}
				for _,v in pairs(re) do
					local tg=v:GetTarget()
					if not tg or tg(v,sc,sp) then
						local cost=v:GetCost()
						if cost and not cost(v,sc,sp) then b=false end
					end
				end
				re={Duel.IsPlayerAffectedByEffect(sp,EFFECT_CANNOT_SPECIAL_SUMMON)}
				for _,v in pairs(re) do
					local tg=v:GetTarget()
					if not tg or tg(v,sc,sp,0x4000000,0x4,stp,se) then b=false end
				end
				re={Duel.IsPlayerAffectedByEffect(sp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)}
				for _,v in pairs(re) do
					local tg=v:GetTarget()
					if not tg or tg(v,sc,sp,0x4000000,0x4,stp,se) then b=false end
				end
				local ct=99
				re={Duel.IsPlayerAffectedByEffect(sp,EFFECT_SPSUMMON_COUNT_LIMIT)}
				for _,v in pairs(re) do ct=math.min(ct,v:GetValue()) end
				if Duel.GetActivityCount(sp,ACTIVITY_SPSUMMON)>=ct then b=false end
				e1:Reset()
				e2:Reset()
				e3:Reset()
				e4:Reset()
				e5:Reset()
				e6:Reset()
				if ly>0 then class["Card_Prophecy_Certain_SP_"..ly]=true end
			else b=cm[17](sc,se,st,sp,bool1,bool2,spos,stp,sz) end
			return b
		end
		cm[18]=Duel.SpecialSummon
		Duel.SpecialSummon=function(tg,st,sp,stp,bool1,...)
			tg=Group.__add(tg,tg)
			local g=tg:Filter(function(c)
				for i=4,12,2 do if c["Card_Prophecy_LV"..i] then return true end end
				return false
			end,nil)
			if #g>0 then
				bool1=true
				g:ForEach(Card.AddMonsterAttribute,TYPE_EFFECT)
			end
			return cm[18](tg,st,sp,stp,bool1,...)
		end
		cm[19]=Duel.SpecialSummonStep
		Duel.SpecialSummonStep=function(tc,st,sp,stp,bool1,...)
			local b=false
			for i=4,12,2 do if tc["Card_Prophecy_LV"..i] then b=true end end
			if b then
				bool1=true
				tc:AddMonsterAttribute(TYPE_EFFECT)
			end
			return cm[19](tc,st,sp,stp,bool1,...)
		end
		cm[20]=Card.IsType
		Card.IsType=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int&(TYPE_MONSTER+TYPE_EFFECT)~=0) else b=cm[20](sc,int) end
			return b
		end
		cm[21]=Card.IsSynchroType
		Card.IsSynchroType=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int&(TYPE_MONSTER+TYPE_EFFECT)~=0) else b=cm[21](sc,int) end
			return b
		end
		cm[22]=Card.IsXyzType
		Card.IsXyzType=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int&(TYPE_MONSTER+TYPE_EFFECT)~=0) else b=cm[22](sc,int) end
			return b
		end
		cm[23]=Card.IsLinkType
		Card.IsLinkType=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int&(TYPE_MONSTER+TYPE_EFFECT)~=0) else b=cm[23](sc,int) end
			return b
		end
		cm[24]=Card.GetType
		Card.GetType=function(sc)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=cm[24](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=0x21 end
			return b
		end
		cm[25]=Card.GetSynchroType
		Card.GetSynchroType=function(sc)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=cm[25](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=0x21 end
			return b
		end
		cm[26]=Card.GetXyzType
		Card.GetXyzType=function(sc)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=cm[26](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=0x21 end
			return b
		end
		cm[27]=Card.GetLinkType
		Card.GetLinkType=function(sc)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=cm[27](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=0x21 end
			return b
		end
		cm[28]=Card.IsRace
		Card.IsRace=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int&RACE_SPELLCASTER~=0) else b=cm[28](sc,int) end
			return b
		end
		cm[29]=Card.GetRace
		Card.GetRace=function(sc)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=cm[29](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=RACE_SPELLCASTER end
			return b
		end
		cm[30]=Card.GetLinkRace
		Card.GetLinkRace=function(sc)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=cm[30](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=RACE_SPELLCASTER end
			return b
		end
		cm[31]=Card.IsAttribute
		Card.IsAttribute=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int&ATTRIBUTE_DARK~=0) else b=cm[31](sc,int) end
			return b
		end
		cm[32]=Card.IsNonAttribute
		Card.IsNonAttribute=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int&ATTRIBUTE_DARK==0) else b=cm[32](sc,int) end
			return b
		end
		cm[33]=Card.GetAttribute
		Card.GetAttribute=function(sc)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=cm[33](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=ATTRIBUTE_DARK end
			return b
		end
		cm[34]=Card.GetLinkAttribute
		Card.GetLinkAttribute=function(sc)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=cm[34](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=ATTRIBUTE_DARK end
			return b
		end
		cm[35]=Card.IsLevel
		Card.IsLevel=function(sc,int,...)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int==lv) else b=cm[35](sc,int,...) end
			return b
		end
		cm[36]=Card.IsLevelAbove
		Card.IsLevelAbove=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int<=lv) else b=cm[36](sc,int) end
			return b
		end
		cm[37]=Card.IsLevelBelow
		Card.IsLevelBelow=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int>=lv) else b=cm[37](sc,int) end
			return b
		end
		cm[38]=Card.GetLevel
		Card.GetLevel=function(sc)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=cm[38](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=lv end
			return b
		end
		cm[39]=Card.IsAttack
		Card.IsAttack=function(sc,int,...)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int==lv*500/2+500) else b=cm[39](sc,int,...) end
			return b
		end
		cm[40]=Card.IsAttackAbove
		Card.IsAttackAbove=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int<=lv*500/2+500) else b=cm[40](sc,int) end
			return b
		end
		cm[41]=Card.IsAttackBelow
		Card.IsAttackBelow=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int>=lv*500/2+500) else b=cm[41](sc,int) end
			return b
		end
		cm[42]=Card.GetAttack
		Card.GetAttack=function(sc)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=cm[42](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=lv*500/2+500 end
			return b
		end
		cm[43]=Card.IsDefense
		Card.IsDefense=function(sc,int,...)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int==lv*500/2+500) else b=cm[43](sc,int,...) end
			return b
		end
		cm[44]=Card.IsDefenseAbove
		Card.IsDefenseAbove=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int<=lv*500/2+500) else b=cm[44](sc,int) end
			return b
		end
		cm[45]=Card.IsDefenseBelow
		Card.IsDefenseBelow=function(sc,int)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=true
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=(int>=lv*500/2+500) else b=cm[45](sc,int) end
			return b
		end
		cm[46]=Card.GetDefense
		Card.GetDefense=function(sc)
			local lv=0
			for i=4,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local b=cm[46](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if lv>0 and (res1 or res2) then b=lv*500/2+500 end
			return b
		end
		cm[47]=Card.IsCanBeEffectTarget
		Card.IsCanBeEffectTarget=function(sc,se)
			local b=true
			local lv=0
			for i=2,12,2 do if sc["Card_Prophecy_LV"..i] then lv=i end end
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			if lv>0 and class["Card_Prophecy_Certain_SP_"..ly] then b=false else b=cm[47](sc,se) end
			return b
		end
	end
end
cm.lvup={m-8}
cm.lvdn={m-7,m-11,m-10,m-9,m-8}
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(cm.efilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
end
function cm.efilter(e,te,c)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsSetCard(0x41) and loc&LOCATION_MZONE>0
end
function cm.filter(c,code)
	return c:IsSetCard(0x6e) and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local ag=Group.CreateGroup()
	local codes={}
	for c in aux.Next(g) do
		local code=c:GetCode()
		if not ag:IsExists(Card.IsCode,1,nil,code) then
			ag:AddCard(c)
			table.insert(codes,code)
		end
	end
	table.sort(codes)
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	getmetatable(e:GetHandler()).announce_filter={table.unpack(afilter)}
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
end
function cm.fselect(g,code)
	return g:IsExists(Card.IsCode,1,nil,code)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,4,ac)
	if sg then Duel.Remove(sg,POS_FACEUP,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local opt=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.sptg(c,ac))
	e1:SetOperation(cm.spop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_REMOVED,LOCATION_REMOVED)
	e2:SetTarget(cm.eftg(ac))
	e2:SetReset(RESET_PHASE+PHASE_END,opt+1)
	e2:SetLabelObject(e1)
	e2:SetLabel(Duel.GetTurnCount()+opt)
	e2:SetCondition(cm.efcon)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetOperation(cm.adjustop(c,ac))
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetTargetRange(LOCATION_REMOVED,LOCATION_REMOVED)
	e4:SetTarget(cm.eftg(ac))
	e4:SetReset(RESET_PHASE+PHASE_END,2-opt)
	e4:SetLabelObject(e3)
	e4:SetLabel(Duel.GetTurnCount()+1-opt)
	e4:SetCondition(cm.efcon)
	Duel.RegisterEffect(e4,tp)
end
function cm.efcon(e)
	return Duel.GetTurnCount()==e:GetLabel()
end
function cm.eftg(code)
	return
	function(e,c)
		return c:IsFaceup() and c:IsCode(code)
	end
end
function cm.sptg(owner,code)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and cm.accheck(tp,code,1) end
		cm.account(e:GetHandler(),tp,code,1)
		cm.adup(owner)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function cm.adjustop(owner,code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rse={c:IsHasEffect(m)}
	for _,v in pairs(rse) do
		if v:GetLabelObject():GetLabelObject() then v:GetLabelObject():GetLabelObject():Reset() end
		if v:GetLabelObject() then v:GetLabelObject():Reset() end
		v:Reset()
	end
	local le={c:GetActivateEffect()}
	for _,v in pairs(le) do
		local e1=v:Clone()
		if #le==1 then e1:SetDescription(aux.Stringid(m,4)) end
		e1:SetRange(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local te={Duel.IsPlayerAffectedByEffect(0,m)}
		for _,v2 in pairs(te) do
			local ae=v2:GetLabelObject()
			if ae:GetLabelObject() and ae:GetLabelObject()==v and ae:GetCode() and ae:GetCode()==EFFECT_ACTIVATE_COST then
				local e2=ae:Clone()
				e2:SetRange(LOCATION_REMOVED)
				e2:SetLabelObject(e1)
				e2:SetTarget(cm.actarget)
				local cost=v2:GetCost()
				if not cost then cost=aux.TRUE end
				e2:SetCost(cm.accost(cost,code))
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e2)
				local ex=Effect.CreateEffect(c)
				ex:SetType(EFFECT_TYPE_SINGLE)
				ex:SetCode(m)
				ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				ex:SetLabelObject(e2)
				ex:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(ex)
			end
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ACTIVATE_COST)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_REMOVED)
		e3:SetTargetRange(1,1)
		e3:SetLabelObject(e1)
		e3:SetTarget(cm.actarget)
		e3:SetCost(cm.accost(aux.TRUE,code))
		e3:SetOperation(cm.costop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(m)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetLabelObject(e3)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAINING)
		e5:SetLabelObject(e1)
		e5:SetCondition(cm.negcon)
		e5:SetOperation(cm.negop(owner,code))
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
		local e6=e4:Clone()
		e6:SetLabelObject(e5)
		c:RegisterEffect(e6)
	end
	end
end
function cm.actarget(e,te,tp)
	return te==e:GetLabelObject()
end
function cm.accost(_cost,code)
	return function(e,te,tp)
				if not cm.accheck(tp,code,2) then return false end
				return _cost(e,te,tp)
			end
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	if tc:IsLocation(LOCATION_SZONE) then return end
	local tp=te:GetHandlerPlayer()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	tc:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function cm.negop(owner,code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		cm.adup(owner)
		cm.account(e:GetOwner(),rp,code,2)
	end
end
function cm.adup(c)
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function cm.accheck(tp,code,num)
	local le={Duel.IsPlayerAffectedByEffect(tp,m+33*num)}
	local b=true
	for _,v in pairs(le) do if v:GetLabel()==code then b=false end end
	return b
end
function cm.account(c,tp,code,num)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(m+33*num)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(code)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
