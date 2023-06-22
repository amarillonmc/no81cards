local m=53759004
local cm=_G["c"..m]
cm.name="心术魔导 LV10"
cm.Card_Prophecy_LV10=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cm.condition1)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
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
cm.lvup={m+8}
cm.lvdn={m+1,m-3,m-2,m-1}
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x41)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.exc(e)
	local exc=nil
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then exc=e:GetHandler() end
	return exc
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and (not cm.exc(e) or chkc~=cm.exc(e)) and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,cm.exc(e)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,cm.exc(e))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end
function cm.relfilter(c,tp)
	return c:IsSetCard(0x41) and c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c)>0 and c:IsLevel(9,10)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m+8) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.relfilter,1,nil,tp) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.SelectReleaseGroup(tp,cm.relfilter,1,1,nil,tp)
	if rg:GetCount()==0 then return end
	if Duel.Release(rg,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_QUICKPLAY)
end
function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0x41) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
