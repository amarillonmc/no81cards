local m=53760022
local cm=_G["c"..m]
cm.name="梦魂支配者 哆来咪·苏伊特"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,cm.ffilter,4,99,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.con2)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_EQUIP+TIMING_SSET)
	e4:SetCost(cm.tdcost)
	e4:SetTarget(cm.tdtg)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.reset)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_LEAVE_FIELD_P)
		ge3:SetOperation(cm.op)
		Duel.RegisterEffect(ge3,0)
	end
	--[[if not cm.global_check then
		cm[1]=Duel.IsPlayerAffectedByEffect
		Duel.IsPlayerAffectedByEffect=function(p,code)
			if code==59822133 then
				cm["Drm_BlueEyes_Check_"..p]=true
				if cm["Drm_Sp_Check_"..p] then return true end
			end
			return cm[1](p,code)
		end
		cm[2]=Duel.GetLocationCount
		Duel.GetLocationCount=function(p,loc,up,reason,zone)
			local lb=-1
			for i=0,5 do
				if cm["Drm_Sp_Check_"..p.."_"..i] then
					lb=i
					cm["Drm_Sp_Check_"..p.."_"..i]=false
				end
			end
			local ct=cm[2](p,loc,up,reason,zone)
			cm["Drm_Loc_Check_"..p.."_"..ct]=true
			return ct+1
		end
		cm[4]=Duel.IsPlayerCanSpecialSummonMonster
		Duel.IsPlayerCanSpecialSummonMonster=function(p,code,scode,typ,atk,def,lv,rac,attr,pos,tgp,styp)
			local lb=-1
			for i=0,5 do
				if cm["Drm_Loc_Check_"..p.."_"..i] then
					lb=i
					cm["Drm_Loc_Check_"..p.."_"..i]=false
				end
			end
			local res=cm[4](p,code,...)
			if Duel.ReadCard(code,4)&TYPE_TOKEN==0 then
				if lb<0 then cm["Drm_Sp_Pre_Check_"..p]=true end
				cm["Drm_BlueEyes_Check_"..p]=false
				if cm[2]<=lb then return false end
			else
				if cm["Drm_BlueEyes_Check_"..p] then
				else
					if lb>=0 then

					else
						cm["Drm_Sp_Check_"..p.."_"..lb]=true
			return res
		end
	end--]]
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsType(TYPE_TOKEN) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	cm.chaining=true
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm.chaining=false
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not cm.chaining then return end
	local ct=eg:FilterCount(Card.IsType,nil,TYPE_TOKEN)
	for i=1,ct do Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1) end
end
function cm.con1(e)
	return e:GetHandler():GetSequence()>4
end
function cm.con2(e)
	return cm.con1(e) and Duel.IsExistingMatchingCard(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_NORMAL)
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.tdfilter(c)
	return c:GetSequence()<5 and c:IsAbleToDeck()
end
function cm.pfilter(c,tp)
	return aux.IsSetNameMonsterListed(c,0x9538) and c:GetType()&0x20002==0x20002 and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) and Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,Duel.GetFlagEffect(0,m))
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 or not dg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	aux.GCheckAdditional=aux.dncheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,1,ft)
	aux.GCheckAdditional=nil
	if not sg then return end
	local res=false
	for tc in aux.Next(sg) do if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then res=true end end
	if not res or Duel.GetFlagEffect(0,m)<=0 then return end
	Duel.BreakEffect()
	Duel.Recover(tp,Duel.GetFlagEffect(0,m)*500,REASON_EFFECT)
end
