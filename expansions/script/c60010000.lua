---@diagnostic disable: param-type-mismatch, duplicate-set-field, undefined-global
--Hello World!

--This is a library of mtc's cards.
--You can add QQ1252425371 to feedback bugs.

--You can view detailed usages below or in mtc's card.
--A few annotations in Chinese are noted below.
--Welcome to use mtc's library.
if mtccreate then return end
mtccreate=1

MTC=MTC or {}
MTC.loaded_metatable_list={}

if not SpaceCheck then
	SpaceCheck={}
	for i=0,1 do
		local g=Duel.GetMatchingGroup(nil,i,LOCATION_HAND+LOCATION_DECK,0,nil)
		if #g==g:GetClassCount(Card.GetCode) then
		   SpaceCheck[i]=true
		end
	end
end
-------------------------------------------------------------------------------------------------------------------------------------
MTC._set_code=Effect.SetCode
Effect.SetCode=function (e,code,...)
	if (code==EFFECT_INDESTRUCTABLE or code==EFFECT_INDESTRUCTABLE_BATTLE or code==EFFECT_INDESTRUCTABLE_EFFECT or code==EFFECT_INDESTRUCTABLE_COUNT or code==EFFECT_CANNOT_BE_BATTLE_TARGET or code==EFFECT_CANNOT_BE_EFFECT_TARGET or code==EFFECT_IGNORE_BATTLE_TARGET or code==EFFECT_IMMUNE_EFFECT or code==EFFECT_CANNOT_SELECT_BATTLE_TARGET or code==EFFECT_CANNOT_SELECT_EFFECT_TARGET) and Duel.GetFlagEffect(tp,60010248)~=0 then
		MTC._set_code(e,nil,...)
	elseif (code==EFFECT_CANNOT_DISABLE or code==EFFECT_CANNOT_DISEFFECT or code==EFFECT_CANNOT_INACTIVATE or code==EFFECT_CANNOT_DISABLE_SUMMON or code==EFFECT_CANNOT_DISABLE_SPSUMMON or code==EFFECT_CANNOT_DISABLE_FLIP_SUMMON) and Duel.GetFlagEffect(tp,60010250)~=0 then
		MTC._set_code(e,nil,...)
	else
		MTC._set_code(e,code,...)
	end
end

MTC._set_chain_limit=Duel.SetChainLimit
Duel.SetChainLimit=function(fil)
	if Duel.GetFlagEffect(tp,60010250)~=0 then
		return MTC._set_chain_limit(true)
	else
		return MTC._set_chain_limit(fil)
	end
end
-------------------------------------------------------------------------------------------------------------------------------------
--系列「传说天」相关函数
--「传说天」次数检定初始化函数
function MTC.LHini(c)
	if not LHini==true then
		LHini=true
		local tp=c:GetOwner()
		--spsm
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(MTC.LHcon1)
		e1:SetOperation(MTC.LHop1)
		Duel.RegisterEffect(e1,tp)
		--spsm
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(MTC.LHcon1)
		e1:SetOperation(MTC.LHop1)
		Duel.RegisterEffect(e1,tp)
	end
end
function MTC.LHfil1(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSetCard(0xa621)
end
function MTC.LHcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(MTC.LHfil1,1,nil,tp)
end
function MTC.LHop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0xa621) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),60010002,RESET_PHASE+PHASE_END,0,1)
			Duel.RaiseEvent(c,EVENT_CUSTOM+60010002,nil,0,tc:GetSummonPlayer(),tc:GetSummonPlayer(),0)
		end
		tc=eg:GetNext()
	end
end
--这个回合，自己把「传说天」怪兽召唤·特殊召唤的次数每有3次，返回值+1
function MTC.LHnum(tp)
	local num=Duel.GetFlagEffect(tp,60010002)
	local ti=0
	while num>=3 do
		num=num-3
		ti=ti+1
	end
	return ti
end
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
--系列「传说天」怪兽通用特招效果
--这张卡可以丢弃num张手卡从手卡特招
function MTC.LHSpS(c,num)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(num)
	e1:SetCondition(MTC.LHcon2)
	e1:SetOperation(MTC.LHop2)
	c:RegisterEffect(e1)
end
function MTC.LHcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()
	local num=e:GetLabel()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,num,c)
end
function MTC.LHop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,num,num,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
--「马纳历亚」次数检定初始化函数
--已废弃
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
--！！暂时无法正常使用！！
--塔隆·血魔类效果初始化
--MTC.CheckEffectSetCode(所使用的表名称,所使用的识别名,不予记录的code,...) ...中记录所需记录效果的event
function MTC.CheckEffectSetCode(tablename,ccode,excode,...)
	local tablename=_G[tablename]
	local ccode=_G[ccode]
	if not ccode then
		ccode=true
		tablename={}
		local events={...}
		local MTCcode=Effect.SetCode --为函数Effect.SetCode增加一段适用前的记录
		Effect.SetCode=function(ue,code,...) 
			local tf=false
			for i=1,#events do   --是否包含...中的某个event
				if code==events[i] then
					tf=true
				end
			end
			if tf==true and ue:GetOwner():GetCode()~=excode then  --符合条件则记录
				local uid=ue:GetOwner():GetCode()
				tablename[uid]={}
				local tf2=false
				local u=1
				while tf2==false do --使用循环记录寻找一个未记录的位置记录该效果
					if not tablename[uid][u] then
						tablename[uid][u]=ue
						tf2=true
					end
					u=u+1
				end
			end
			MTCcode(ue,code,...)
		end
		for tc in aux.Next(Duel.GetMatchingGroup(nil,tp,0x1ff,0x1ff,nil)) do --重载
			local ini=MTC.initial_effect
			MTC.initial_effect=function() end
			tc:ReplaceEffect(m,0)
			MTC.initial_effect=ini
			if tc.initial_effect then tc.initial_effect(tc) end
		end
	end
end

function MTC.filterEffectSetCode(c,tablename)
	local tablename=_G[tablename]
	return tablename[c:GetCode()][1]~=nil
end

--获取区域内有某个event的组（必须先使用MTC.CheckEffectSetCode进行记录）
--MTC.GetGroupEffectSetcode(tp,所使用的表名称,fil,loc1,loc2,除了xxx之外,...)
function MTC.GetGroupEffectSetcode(tp,tablename,fil,loc1,loc2,ex,...) --获取符合条件的卡
	local tablename=_G[tablename]
	local g=Duel.GetMatchingGroup(fil,tp,loc1,loc2,ex,...) 
	local ac=g:GetFirst()
	for i=1,#g do
		if tablename[ac:GetCode()][1]==nil then
			g:RemoveCard(ac)
		end
		ac=g:GetNext()
	end
	return g
end
--适用某张卡的某个event的效果
--MTC.ApplyEffectSetCode(调用该函数的e,调用该函数的tp,需要适用的c,所使用的表名称,...)
function MTC.ApplyEffectSetCode(e,tp,c,tablename,...)
	local tablename=_G[tablename]
	local tf=false
	local i=1
	while tf==false do --利用循环把每一项适用
		if tablename[c:GetCode()][i] then
			MTC.ActivateEffect(tablename[c:GetCode()][i],tp,e)
		end
		if not tablename[c:GetCode()][i+1] then
			tf=true
		end
		i=i+1
	end
end

--MTC.ActivateEffect(需要适用的e,调用该函数的tp,调用该函数的e)
--Thanks to lanpa
function MTC.ActivateEffect(e,tp,oe)
	local c=e:GetHandler()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end
function MTC.ActivateCard(c,tp,oe)
	local e=c:GetActivateEffect()
	if c:IsType(TYPE_FIELD) then
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		Duel.RaiseEvent(c,4179255,e,0,tp,tp,Duel.GetCurrentChain())
	else
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
	
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		Duel.Hint(HINT_CARD,1-tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local fg=g:GetFirst()
			while fg do
				fg:CreateEffectRelation(e)
				fg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			fg=g:GetFirst()
			while fg do
				fg:ReleaseEffectRelation(e)
				fg=g:GetNext()
			end
		end
	end

	if (not (c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_FIELD) or c:IsType(TYPE_EQUIP))) and c:IsRelateToEffect(e) then
		 Duel.SendtoGrave(c,REASON_RULE)
	end
end
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
--对于某个g里的每张卡片依次适用操作op
function MTC.CycleApplyOp(g,op,...)
	local ac=g:GetFirst()
	for i=1,#g do
		local c=ac
		if op then op(...) end
		ac=g:GetNext()
	end
end

--快速单张卡处理
--MTC.SEffect(c,id记述/code==0时无id效果,诱发事件,执行事件,区域,筛选,最小数量,最大数量)
--目前执行事件仅支持 加入手卡&送去墓地(加入手卡==1 送去墓地==2)
function MTC.SEffect(c,code,event,doing,loc,fil,minnum,maxnum)
	local e1=Effect.CreateEffect(c)
	if doing==1 then
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	elseif doing==2 then
		e1:SetCategory(CATEGORY_TOGRAVE)
	end
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(event)
	if code~=0 then
		e1:SetCountLimit(1,code)
	end
	if doing==1 then
		e1:SetTarget(MTC.sitg1)
		e1:SetOperation(MTC.sitg1)
	elseif doing==2 then
		e1:SetTarget(MTC.sitg2)
		e1:SetOperation(MTC.sitg2)
	end
	e1:SetLabel(loc,fil,minnum,maxnum)
	c:RegisterEffect(e1)
end

function MTC.sitg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc,fil,minnum,maxnum=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(fil,tp,loc,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function MTC.sitg1(e,tp,eg,ep,ev,re,r,rp)
	local loc,fil,minnum,maxnum=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,fil,tp,loc,0,minnum,maxnum,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function MTC.sitg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc,fil,minnum,maxnum=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(fil,tp,loc,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,loc)
end
function MTC.sitg2(e,tp,eg,ep,ev,re,r,rp)
	local loc,fil,minnum,maxnum=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,fil,tp,loc,0,minnum,maxnum,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--「无色之白」的手续召唤
function MTC.WhiteSum(c,code,num)
	--summon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(60010000,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetLabel(num)
	e0:SetCondition(MTC.Whitecon)
	e0:SetOperation(MTC.Whiteop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
end

function MTC.Whitefil(c)
	return c:IsSetCard(0x646) and not c:IsPublic()
end
function MTC.Whitecon(e,c)
	local tp=e:GetHandler():GetControler()
	local num=e:GetLabel()
	return Duel.IsExistingMatchingCard(MTC.Whitefil,tp,LOCATION_HAND,0,num,c)
end
function MTC.Whiteop(e,tp,eg,ep,ev,re,r,rp,c)
	local num=e:GetLabel()
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,MTC.Whitefil,tp,LOCATION_HAND,0,num,num,c)
	local oc=g:GetFirst()
	for i=1,num do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60010000,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		oc:RegisterEffect(e1)
		oc=g:GetNext()
	end
end

--「无色之白」的效果回收
function MTC.WhiteBack(c,code)
	Duel.AddCustomActivityCounter(code,ACTIVITY_CHAIN,MTC.Whitecf)
	--back
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60010000,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,code+10000000)
	e3:SetCost(MTC.WhiteZS)
	e3:SetCondition(MTC.Whitecon2)
	e3:SetTarget(MTC.Whitetg2)
	e3:SetOperation(MTC.Whiteop2)
	c:RegisterEffect(e3)
end
function MTC.Whitecf(re,tp,cid)
	return re:GetHandler():IsSetCard(0x646)
end
function MTC.Whitefil2(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) 
end
function MTC.Whitecon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsPublic,tp,LOCATION_HAND,0,nil)
	return eg:IsExists(MTC.Whitefil2,1,nil,tp)
	
end
function MTC.Whitetg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsPublic,tp,LOCATION_HAND,0,nil)
	if chk==0 then return c:IsAbleToHand() and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function MTC.Whiteop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT) then
		local g=Duel.GetMatchingGroup(Card.IsPublic,tp,LOCATION_HAND,0,nil)
		if #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local eset={sc:IsHasEffect(EFFECT_PUBLIC)}
		if #eset>0 then
			for _,ae in pairs(eset) do
				if ae:IsHasType(EFFECT_TYPE_SINGLE) then
					ae:Reset()
				else
					local tg=ae:GetTarget() or aux.TRUE
					ae:SetTarget(function(e,c,...) return tg(e,c,...) and c:GetFlagEffect(m)==0 end)
				end
			end
		end
	end
end

function MTC.WhiteZS(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetHandler():GetCode()
	if chk==0 then return Duel.GetCustomActivityCount(code,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(MTC.Whiteacl)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function MTC.Whiteacl(e,re,tp)
	return not re:GetHandler():IsSetCard(0x646)
end

--random
function getrand()
	local result=0
	local g=Duel.GetDecktopGroup(0,5)
	local tc=g:GetFirst()
	while tc do
		result=result+tc:GetCode()
		tc=g:GetNext()
	end
	math.randomseed(result)
end

function MTC.SOSZS(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetHandler():GetCode()
	if chk==0 then return Duel.GetCustomActivityCount(code,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(MTC.SOSac1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function MTC.SOSac1(e,re,tp)
	return not re:GetHandler():IsSetCard(0x6623)
end

--创建化身效果
Avatar={}

function MTC.AvatarCreate(c,code,loc)
	
	local tp=c:GetControler()

	c:EnableCounterPermit(0x62a,LOCATION_ONFIELD)
	c:SetCounterLimit(0x62a,14)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(loc)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabel(code)
	e1:SetOperation(MTC.Avatarop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e3)
	local e3=e1:Clone()
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e3)
end
function MTC.Avatarfil(c,code)
	return c:IsCode(code) and c:CheckActivateEffect(false,false,false)~=nil
end
function MTC.Avatarop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	local cnum=c:GetCounter(0x62a)
	local r=math.random(1,15)
	if r+cnum>=15 and c:GetFlagEffect(60010225)==0 and Duel.IsExistingMatchingCard(MTC.Avatarfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,code) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_CARD,0,c:GetCode()) 
		local tc=Group.CreateGroup()
		if Duel.IsExistingMatchingCard(MTC.Avatarfil,tp,LOCATION_DECK,0,1,nil,code) then 
			tc=Duel.GetMatchingGroup(MTC.Avatarfil,tp,LOCATION_DECK,0,nil,code):RandomSelect(tp,1):GetFirst()
		else
			tc=Duel.GetMatchingGroup(MTC.Avatarfil,tp,LOCATION_GRAVE,0,nil,code):RandomSelect(tp,1):GetFirst()
		end
		
		c:RemoveCounter(tp,0x62a,c:GetCounter(0x62a),REASON_EFFECT)
		
		MTC.ActivateCard(tc,tp,e)
		
		c:RegisterFlagEffect(60010225,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_REDIRECT,0,1)
		
		Duel.RaiseEvent(c,EVENT_CUSTOM+60010225,nil,0,tp,tp,0)
	else
		if c:IsLocation(LOCATION_ONFIELD) then
			c:AddCounter(0x62a,1)
		end
	end
end

--翁法罗斯：揭示真名
function MTC.realname(tp,code1,code2)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,1,0,nil)
	for tc in aux.Next(g) do
		if tc:GetOriginalCodeRule()==code1 then
			tc:SetEntityCode(code2,true)
			tc:ReplaceEffect(code2,0,0)
		end
	end
end


function MTC.StrinovaPUS(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(MTC.StrinovaPUScon)
	e2:SetTarget(MTC.StrinovaPUStg)
	e2:SetOperation(MTC.StrinovaPUSop)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(MTC.StrinovaPUSreg)
	c:RegisterEffect(e3)
end
function MTC.StrinovaChangeZone(c,czop)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetCost(MTC.StrinovaChangeZonecost)
	e0:SetCondition(MTC.StrinovaChangeZonecon)
	e0:SetOperation(czop)
	c:RegisterEffect(e0)
end
function MTC.StrinovaPUScon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,c,TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function MTC.StrinovaPUStg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,c,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=rg:Select(tp,1,1,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function MTC.StrinovaPUSop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 and g:GetFirst():IsSetCard(0x9623) then
		Duel.Draw(tp,1,REASON_SPSUMMON)
	end
	g:DeleteGroup()
end
function MTC.StrinovaPUSreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetOperation(MTC.StrinovaPUSretop)
	c:RegisterEffect(e1)
end
function MTC.StrinovaPUSretop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function MTC.StrinovaChangeZonecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if not (c:IsPublic() or c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) then Duel.ConfirmCards(1-tp,c) end
end
function MTC.StrinovaChangeZonecon(e,tp,eg,ep,ev,re,r,rp)
	local tf=false
	local c=e:GetHandler()
	local loc=0
	if c:IsLocation(LOCATION_MZONE) then 
		loc=1 
	elseif c:IsLocation(LOCATION_SZONE) then 
		loc=2
	end
	if e:GetLabel()==0 or loc==0 then
		tf=false
	elseif e:GetLabel()~=loc then
		tf=true
	end
	e:SetLabel(loc)
	return tf
end


