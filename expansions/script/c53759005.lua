local m=53759005
local cm=_G["c"..m]
cm.name="心术魔导 LV2"
cm.Card_Prophecy_LV2=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(0x10002)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	cm.activate_type_effect=e1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.adjustop)
	Duel.RegisterEffect(e2,0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(1,1)
	e3:SetLabelObject(e1)
	e3:SetTarget(cm.actarget)
	e3:SetOperation(cm.costop)
	Duel.RegisterEffect(e3,0)
	SNNM.Global_in_Initial_Reset(c,{e2,e3})
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
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
	if not Card_Prophecy_Cheat_2 then
		Card_Prophecy_Cheat_2=true
		local class=_G["c"..Duel.GetFlagEffectLabel(0,53759099)]
		cm[17]=Card.GetActivateEffect
		Card.GetActivateEffect=function(ac)
			local le={cm[17](ac)}
			local ae=ac.activate_type_effect
			if ae then le={ae} end
			return table.unpack(le)
		end
		cm[18]=Effect.IsHasType
		Effect.IsHasType=function(re,type)
			local res=cm[18](re,type)
			local rc=re:GetHandler()
			local ae=rc.activate_type_effect
			local b=false
			if ae and re==ae then b=true end
			if type&EFFECT_TYPE_ACTIVATE~=0 and b then return true else return res end
		end
		cm[19]=Effect.GetType
		Effect.GetType=function(re)
			local rc=re:GetHandler()
			local ae=rc.activate_type_effect
			local b=false
			if ae and re==ae then b=true end
			if b then return EFFECT_TYPE_ACTIVATE else return cm[19](re) end
		end
		cm[20]=Effect.IsActiveType
		Effect.IsActiveType=function(re,type)
			local res=cm[20](re,type)
			local rc=re:GetHandler()
			local ae=rc.activate_type_effect
			local b=false
			if ae and re==ae then b=true end
			if type&TYPE_QUICKPLAY~=0 and b then return true else return res end
		end
		cm[21]=Effect.GetActiveType
		Effect.GetActiveType=function(re)
			local rc=re:GetHandler()
			local ae=rc.activate_type_effect
			local b=false
			if ae and re==ae then b=true end
			if b then return TYPE_SPELL+TYPE_QUICKPLAY else return cm[21](re) end
		end
		cm[22]=Card.CheckActivateEffect
		Card.CheckActivateEffect=function(ac,...)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local le={cm[22](ac,...)}
			local ae=ac.activate_type_effect
			if ae and (ly>0 or Duel.GetFlagEffectLabel(0,53759000)==0) then
				le={ae}
				if ly>0 then class["Card_Prophecy_Certain_ACST_"..ly]=true end
			end
			return table.unpack(le)
		end
		cm[23]=Card.IsSSetable
		Card.IsSSetable=function(sc,bool)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local b=true
			if sc.Card_Prophecy_LV2 and (ly>0 or Duel.GetFlagEffectLabel(0,53759000)==0) then
				if ly>0 then class["Card_Prophecy_Certain_ACST_"..ly]=true end
			else b=cm[23](sc,bool) end
			return b
		end
		cm[24]=Card.IsType
		Card.IsType=function(sc,int)
			local b=cm[24](sc,int)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_ACST_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if sc.Card_Prophecy_LV2 and (res1 or res2) then b=(int&0x10002~=0) end
			return b
		end
		cm[25]=Card.GetType
		Card.GetType=function(sc)
			local b=cm[25](sc)
			local ly=0
			for i=1,114 do
				if not class["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (class["Card_Prophecy_L_Check_"..ly] or class["Card_Prophecy_Certain_ACST_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			if sc.Card_Prophecy_LV2 and (res1 or res2) then b=0x10002 end
			return b
		end
		cm[26]=Card.IsCanBeEffectTarget
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
			if lv>0 and class["Card_Prophecy_Certain_ACST_"..ly] then b=false else b=cm[26](sc,se) end
			return b
		end
	end
end
cm.lvup={m-4}
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_SET_TURN) or e:GetHandler():IsHasEffect(EFFECT_QP_ACT_IN_SET_TURN)
end
function cm.tdfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x41) and c:IsAbleToDeck()
end
function cm.thfilter(c)
	return c:IsCode(m+1) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m-4) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) and (b1 or b2 or b3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct==0 then return end
		if tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local off=1
		local ops={}
		local opval={}
		if Duel.IsPlayerCanDraw(tp,1) then
			ops[off]=aux.Stringid(m,2)
			opval[off-1]=0
			off=off+1
		end
		if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) then
			ops[off]=aux.Stringid(m,3)
			opval[off-1]=1
			off=off+1
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) then
			ops[off]=aux.Stringid(m,4)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		elseif opval[op]==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		elseif opval[op]==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		end
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local p=te:GetHandlerPlayer()
	local pe={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_ACTIVATE)}
	local ae={Duel.IsPlayerAffectedByEffect(p,EFFECT_ACTIVATE_COST)}
	local t1,t2={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t1,v)
			table.insert(t2,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t1,v)
				table.insert(t2,2)
			end
		end
	end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(0x10002)
	c:RegisterEffect(e0,true)
	local t3,t4={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t3,v)
			table.insert(t4,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t3,v)
				table.insert(t4,2)
			end
		end
	end
	local ret1,ret2={},{}
	for k,v1 in pairs(t1) do
		local equal=false
		for _,v2 in pairs(t3) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret1,v1)
			table.insert(ret2,t2[k])
		end
	end
	local ret3,ret4={},{}
	for k,v1 in pairs(t3) do
		local equal=false
		for _,v2 in pairs(t1) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret3,v1)
			table.insert(ret4,t4[k])
		end
	end
	for k,v in pairs(ret1) do
		if ret2[k]==1 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.chval(val,false,te))
			end
		end
		if ret2[k]==2 then
			local cost=v:GetCost()
			if cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.chtg(aux.TRUE,false,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.chtg(tg,false,te))
				end
			end
		end
	end
	for k,v in pairs(ret3) do
		if ret4[k]==4 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.chval(val,true,te))
			end
		end
		if ret4[k]==5 then
			local cost=v:GetCost()
			if cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.chtg(aux.TRUE,true,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.chtg(tg,true,te))
				end
			end
		end
	end
	e0:Reset()
end
function cm.chval(_val,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _val(e,re,...)
			end
end
function cm.chtg(_tg,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _tg(e,re,...)
			end
end
function cm.actarget(e,te,tp)
	local ce=e:GetLabelObject()
	return te==ce and ce:GetHandler():IsLocation(LOCATION_HAND+LOCATION_SZONE)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(0x10002)
	e0:SetReset(RESET_EVENT+0xfc0000)
	c:RegisterEffect(e0,true)
	if c:IsLocation(LOCATION_SZONE) then
		Duel.ChangePosition(c,POS_FACEUP)
		c:SetStatus(STATUS_EFFECT_ENABLED,false)
	else
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
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
		if not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then rc:CancelToGrave(false) end
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x41) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
		if #sg>0 then Duel.SendtoHand(sg,nil,REASON_EFFECT) end
	end
end
