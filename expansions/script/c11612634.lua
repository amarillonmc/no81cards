--龙仪巧-仙王流星＝CEP
local m=11612634
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/11610000") end) then require("script/11610000") end
cm.text=zhc_lhq_xw
cm.ts1=zhc_lhq_xw_1
local ts1c=0
cm.ts2=zhc_lhq_xw_2
local count=6
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,12,count*2) 
	c:EnableReviveLimit()
	--
	local e00=fpjdiy.Zhc(c,cm.text)
	--
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(0xff)
	e1:SetOperation(cm.adjustop)
	c:RegisterEffect(e1)

	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SPSUMMON_COST)
	e6:SetCost(cm.e6cost)
	c:RegisterEffect(e6)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	--e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_OVERLAY_RITUAL_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(m)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	--e5:SetCondition(cm.spcon)
	--e5:SetCost(cm.spcost)
	e5:SetTarget(cm.tg)
	e5:SetOperation(cm.op)
	c:RegisterEffect(e5)
	--cannot NegateActivation
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetRange(0x7f)
	e12:SetCode(EFFECT_CANNOT_DISABLE)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e12)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetRange(0x7f)
	e13:SetCode(EFFECT_CANNOT_INACTIVATE)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e13:SetValue(cm.effectfilter)
	c:RegisterEffect(e13)
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetRange(0x7f)
	e14:SetCode(EFFECT_CANNOT_DISEFFECT)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e14:SetValue(cm.effectfilter)
	c:RegisterEffect(e14)
	if not cm.global_flag then
		cm.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not cm.globle_check then
		cm.globle_check=true
		local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,0,0xff,0xff,nil,22398665)
		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(m+1,0)
		end
	end
	e:Reset()
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsSetCard(0x154) and tc:GetSummonType()==SUMMON_TYPE_RITUAL  then
			if Duel.GetFlagEffect(tc:GetSummonPlayer(),11612635)~=0 then
				for _,i in ipairs{Duel.GetFlagEffectLabel(tc:GetSummonPlayer(),11612635)} do
					if i==tc:GetCode() then return end		
				end
			end
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),11612635,0,0,0,tc:GetCode())
			local set={Duel.GetFlagEffectLabel(tp,11612635)}
			if ts1c==0 and (#set)>=count then			 
				fpjdiy.printLines(cm.ts1)
				--Debug.Message(cm.ts1)
				ts1c=1
			elseif ts1c==1 and (#set)>=(count*2) then
				fpjdiy.printLines(cm.ts2)
				--Debug.Message(cm.ts2)
				ts1c=2
			end
		end
	end
end
--
function cm.e6cost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_XYZ  then 
		return false
	elseif bit.band(st,SUMMON_TYPE_XYZ)~=SUMMON_TYPE_XYZ   then
		return true
	else
		return false
	end
end
--
function cm.cfilter(c,tp,sc)
	return  c:IsFaceup() and c:IsLevel(12) and c:IsCanBeXyzMaterial(sc)
end
function cm.cfilter2(c,sc)
	return  c:IsLevel(12) and c:IsType(TYPE_RITUAL) and ( c:IsFaceup() or c:IsLocation(LOCATION_GRAVE) )  and c:IsCanBeXyzMaterial(sc)
end
function cm.cfilter3(c,sc)
	return  c:IsFaceup() and c:IsCanBeXyzMaterial(sc)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local set={Duel.GetFlagEffectLabel(tp,11612635)}
	local zone=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil,tp,c)
	local loc=LOCATION_MZONE
	local loa=0
	if (#set)>=(count) then
		loc=LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED 
		local ag=Duel.GetMatchingGroup(cm.cfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,zone,c)  
		zone:Merge(ag) 
		if (#set)>=(count*2) then
			loa=LOCATION_MZONE 
			local bg=Duel.GetMatchingGroup(cm.cfilter3,tp,0,LOCATION_MZONE,zone,c)
			zone:Merge(bg)
		end
	end 
	local maxc=zone:GetCount()
	if Duel.GetFlagEffect(tp,11612635)==0 or (#set)<1 then return false end
	return maxc>=(count*2)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then
		return true
	end
	local set={Duel.GetFlagEffectLabel(tp,11612635)}
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil,tp,c)
	if (#set)>=(count) then
		local ag=Duel.GetMatchingGroup(cm.cfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,c)  
		mg:Merge(ag)		
	end
	if (#set)>=(count*2) then
		local bg=Duel.GetMatchingGroup(cm.cfilter3,tp,0,LOCATION_MZONE,nil,c)
		mg:Merge(bg)
	end
	local minc=(count*2)
	local maxc=mg:GetCount() 
	if min then
		 if min>minc then minc=min end
		 if max<maxc then maxc=max end
	end
	local sg=Group.CreateGroup()
	while sg:GetCount()<(count*2) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=mg:FilterSelect(tp,aux.TRUE,1,1,sg)
		sg:Merge(g)
	end
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if og and not min then
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg=e:GetLabelObject()
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end
--03
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=c:GetCode()
	getmetatable(c).announce_filter={ TYPE_MONSTER,OPCODE_ISTYPE,code,OPCODE_ISCODE,OPCODE_NOT,TYPE_RITUAL,OPCODE_ISTYPE,OPCODE_AND,OPCODE_AND }
	local ac=Duel.AnnounceCard(tp,table.unpack( getmetatable(c).announce_filter ))
	if rcode~=nil then return false end
	local rc=Duel.CreateToken(tp,ac)
	if  Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		if rc:IsSetCard(0x154) then
			rc:RegisterFlagEffect(ac,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
		end
	end
end