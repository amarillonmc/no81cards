Satl={}
SUMMON_TYPE_SPLIT=15000001
SUMMON_VALUE_SPLIT=0x15000001
EFFECT_EXTRA_SPLIT_SUMMON=15000002
EFFECT_CANNOT_BE_SPLIT_MATERIAL=15000003
--if not require and dofile then
--	function require(str)
--		require_list=require_list or {}
--		if not require_list[str] then
--			if string.find(str,"%.") then
--				require_list[str]=dofile(str)
--			else
--				require_list[str]=dofile(str..".lua")
--			end
--		end
--		return require_list[str]
--	end
--end
--if not pcall(function() require("expansions/script/c15000000") end) then require("script/c15000000") end
if Satl_Library_Switch then
	return
end
Satl_Library_Switch=true
--为 卡 片 c添 加 裂 解 召 唤 手 续 ,mf为 裂 解 素 材 需 满 足 的 条 件
function Satl.AddSplitProcedure(c,mf)
	if not Satl.PendulumChecklist then
		Satl.PendulumChecklist=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(Satl.SplitReset)
		Duel.RegisterEffect(ge1,0)
	end
	--Split summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15000000,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Satl.SplitCondition())
	e1:SetOperation(Satl.SplitOperation())
	e1:SetValue(SUMMON_TYPE_SPLIT)
	c:RegisterEffect(e1)
	--mf
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(15000001)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(mf)
	c:RegisterEffect(e2)
	if not Satl.global_effect then
		Satl.global_effect=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON)
		ge2:SetCondition(Satl.slkrescon)
		ge2:SetOperation(Satl.slkresop)
		Duel.RegisterEffect(ge2,0)
	end
end
function Satl.SplitReset(e,tp,eg,ep,ev,re,r,rp)
	Satl.SplitChecklist=0
end
function Satl.SplitConditionExtraFilterSpecific(c,e,tp,te)
	if not te then return true end
	local f=te:GetValue()
	return not f or f(te,c,e,tp)
end
function Satl.SplitConditionExtraFilter(c,e,tp,eset)
	for _,te in ipairs(eset) do
		if Satl.SplitConditionExtraFilterSpecific(c,e,tp,te) then return true end
	end
	return false
end
function Satl.SplitLinkConditionFilter(c,e,tp,eset)
	return c.Split_link and c:IsLocation(LOCATION_EXTRA) and c:IsFacedown()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPLIT,tp,false,false)
		and not c:IsForbidden()
		and (Satl.SplitChecklist&(0x1<<tp)==0 or Satl.SplitConditionExtraFilter(c,e,tp,eset))
end
function Satl.SplitLink(c)
	if c.Split_link then return c.Split_link
	else return 0 end
end
function Satl.SplitLinkGroupCheck(g,mc,e,tp,link,c)
	local sum=g:GetSum(Satl.SplitLink)
	local tc=g:GetFirst()
	while tc do
		local mf=tc:IsHasEffect(15000001):GetValue()
		if (mf and (not mf(mc))) then return false end
		tc=g:GetNext()
	end
	return g:GetCount()>1 and sum==link and Duel.GetLocationCountFromEx(tp,tp,mc,TYPE_LINK)>=g:GetCount() and g:IsContains(c)
end
function Satl.SplitLinkMFilter(c,e,tp,sc,eset)
	local link=c:GetLink()
	local sg=Duel.GetMatchingGroup(Satl.SplitLinkConditionFilter,tp,LOCATION_EXTRA,0,nil,e,tp,eset)
	return c:IsType(TYPE_LINK) and c:IsFaceup() and sg:CheckSubGroup(Satl.SplitLinkGroupCheck,2,99,c,e,tp,link,sc) and not c:IsHasEffect(EFFECT_CANNOT_BE_SPLIT_MATERIAL) and not c.Split_link
end
function Satl.SplitLinkMGroupCheck(g,e,tp,c,eset)
	return g:GetCount()==1 and g:IsExists(Satl.SplitLinkMFilter,1,nil,e,tp,c,eset)
end
function Satl.SplitCondition()
	return  function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_SPLIT_SUMMON)}
				if Satl.SplitChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
				return Duel.IsExistingMatchingCard(Satl.SplitLinkMFilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c,eset) and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			end
end
function Satl.GetSplitMaterials(tp)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return mg
end
function Satl.SplitOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local mg=Satl.GetSplitMaterials(tp)
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_SPLIT_SUMMON)}
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15000000,1))
				local cancel=Duel.IsSummonCancelable()
				local cg=mg:SelectSubGroup(tp,Satl.SplitLinkMGroupCheck,cancel,1,1,e,tp,c,eset)
				local sc=cg:GetFirst()
				local link=sc:GetLink()
				local tg=nil
				if og then
					tg=og:Filter(Card.IsLocation,nil,LOCATION_EXTRA):Filter(Satl.SplitLinkConditionFilter,nil,e,tp,eset)
				else
					tg=Duel.GetMatchingGroup(Satl.SplitLinkConditionFilter,tp,LOCATION_EXTRA,0,nil,e,tp,eset)
				end

				local ce=nil
				local b1=Satl.SplitChecklist&(0x1<<tp)==0
				local b2=#eset>0
				if b1 and b2 then
					local options={aux.Stringid(15000000,0)}
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
					tg=tg:Filter(Satl.SplitConditionExtraFilterSpecific,nil,e,tp,ce)
				end

				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=tg:SelectSubGroup(tp,Satl.SplitLinkGroupCheck,cancel,2,99,sc,e,tp,link,c)
				if not g then return end
				local jc=g:GetFirst()
				local id=e:GetFieldID()
				while jc do
					jc:SetMaterial(cg)
					jc:RegisterFlagEffect(SUMMON_TYPE_SPLIT,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,id)
					jc=g:GetNext()
				end
				Duel.SendtoGrave(cg,REASON_MATERIAL+SUMMON_TYPE_SPLIT)
				local kc=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK):GetFirst()
				local ct,antizone=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_LINK)
				--force mzone
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_MUST_USE_MZONE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetTargetRange(1,1)
				e1:SetValue(Satl.frcval)
				e1:SetLabel(antizone,SUMMON_TYPE_SPLIT,tp)
				kc:RegisterEffect(e1)
				if ce then
					Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
					ce:UseCountLimit(tp)
				else
					Satl.SplitChecklist=Satl.SplitChecklist|(0x1<<tp)
				end
				sg:Merge(g)
			end
end
function Satl.frcval(e)
	local antizone,x,p=e:GetLabel()
	if p~=e:GetHandler():GetControler() then
		antizone=((antizone&0xffff)<<16)|((antizone>>16)&0xffff)
	end
	return ~antizone
end
function Satl.slkfilter(c)
	local st=c:GetSummonType()
	return st&SUMMON_VALUE_SPLIT>0
end
function Satl.slkrescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(Satl.slkfilter,1,nil)
end
function Satl.slkresop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	local kc=g:GetFirst()
	while kc do
		if kc:IsHasEffect(EFFECT_MUST_USE_MZONE) then
			for _,i in ipairs{kc:IsHasEffect(EFFECT_MUST_USE_MZONE)} do
				local antizone,x,p=i:GetLabel()
				if x and x==SUMMON_TYPE_SPLIT then
					i:Reset()
				end
			end
		end
		kc=g:GetNext()
	end
	if Duel.IsPlayerAffectedByEffect(0,EFFECT_MUST_USE_MZONE) then
		for _,i in ipairs{Duel.IsPlayerAffectedByEffect(0,EFFECT_MUST_USE_MZONE)} do
			local antizone,x,p=i:GetLabel()
			if x and x==SUMMON_TYPE_SPLIT then
				i:Reset()
			end
		end
	end
	if Duel.IsPlayerAffectedByEffect(1,EFFECT_MUST_USE_MZONE) then
		for _,i in ipairs{Duel.IsPlayerAffectedByEffect(1,EFFECT_MUST_USE_MZONE)} do
			local antizone,x,p=i:GetLabel()
			if x and x==SUMMON_TYPE_SPLIT then
				i:Reset()
			end
		end
	end
end
--得 到 与 c同 时 裂 解 召 唤 的 卡 片 组
function Satl.GetSplitGroup(c)
	local id=c:GetFlagEffectLabel(SUMMON_TYPE_SPLIT)
	local g=Duel.GetMatchingGroup(Satl.SplitGroupFilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,id)
	return g
end
function Satl.SplitGroupFilter(c,id)
	return c:GetFlagEffectLabel(SUMMON_TYPE_SPLIT)==id
end

function Satl.AstonishRecordProcedure(c,count,code)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	if count and count~=0 then
		e0:SetCountLimit(count,code)
	end
	e0:SetCondition(Satl.AstonishRecordCon)
	c:RegisterEffect(e0)
end
--得 到 tp的 loc区 域（ 只 能 是 MZONE或 SZONE）没 有 使 用 而 不 能 使 用 的 格 子 数 量
function Satl.CannotZoneCheck(tp,loc)
	--得 到 不 能 使 用 的 主 要 怪 兽 区 域
	local ct,cannotzone=Duel.GetLocationCount(tp,loc)
	--得 到 不 能 使 用 的 主 要 怪 兽 区 域 中 已 存 在 的 卡
	local zg=Duel.GetMatchingGroup(Satl.zonefilter,tp,loc,0,nil,tp,cannotzone,loc)
	--得 到 不 能 使 用 的 主 要 怪 兽 区 域 中 已 被 使 用 的 主 要 怪 兽 区 域
	local alreadyzone=0
	local zc=zg:GetFirst()
	while zc do
		alreadyzone=alreadyzone|aux.SequenceToGlobal(tp,loc,zc:GetSequence())
		zc=zg:GetNext()
	end
	--得 到 没 有 使 用 而 不 能 使 用 的 主 要 怪 兽 区 域
	local czone=cannotzone~alreadyzone
	--转 化 为 二 进 制 数（ 被 视 为 十 进 制 ）
	local x=0
	if loc==LOCATION_MZONE then x=1100000 end
	local cz=Satl.dec2bin(czone)-x
	--得 到 这 些 区 域 的 格 子 数 量（ 即 这 个 十 进 制 数 中 1的 个 数 ）
	local czt=0
	local m=0
	while cz~=0 do
		m=cz%10
		cz=math.floor(cz/10)
		if m~=0 then
			czt=czt+1
		end
	end
	return czt
end
function Satl.zonefilter(c,tp,cannotzone,loc)
	return c:GetSequence()<5 and aux.SequenceToGlobal(tp,loc,c:GetSequence())&cannotzone~=0
end
function Satl.dec2bin(n)
	local t={}
	for i=31,0,-1 do
		t[#t+1]=math.floor(n/2^i)
		n=n%2^i
	end
	return table.concat(t)
end
function Satl.AstonishRecordCon(e,c)
	if c==nil then return true end
	local zct=Satl.CannotZoneCheck(c:GetControler(),LOCATION_MZONE)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and zct>=2
end
--「 异 闻 鸣 」怪 兽 的 效 果 追 加
function Satl.AddHearogenehirpAdding(c)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAIN_SOLVING)
	ge1:SetCondition(Satl.Hearogenehirpcon)
	ge1:SetOperation(Satl.Hearogenehirpop)
	Duel.RegisterEffect(ge1,0)
	--
	_HearogenehirpChainOperation=Duel.ChangeChainOperation
	function Duel.ChangeChainOperation(ev,f)
		local e,p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
		local rc=e:GetHandler()
		if (rc:IsSetCard(0xaf3e) or (rc:IsType(TYPE_FLIP) and e:IsActiveType(TYPE_MONSTER))) and bit.band(loc,LOCATION_ONFIELD)~=0 and f then
			local e1=Effect.CreateEffect(rc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(15005031)
			e1:SetTargetRange(1,0)
			e1:SetOperation(f)
			e1:SetLabelObject(e)
			e1:SetReset(RESET_CHAIN+RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,p)
			local HearogenehirpSolvingf=f
			f=function(e,tp,eg,ep,ev,re,r,rp)
				HearogenehirpSolvingf(e,tp,eg,ep,ev,re,r,rp)
				if Satl.GetHearogenehirpSolvingCount(e,tp)~=0 and Duel.SelectYesNo(tp,aux.Stringid(15000000,4)) then Satl.AddHearogenehirpSolving(e,tp) end
			end
		end
		return _HearogenehirpChainOperation(ev,f)
	end
end
function Satl.GetHearogenehirpSolvingCount(e,tp)
	local g=Group.CreateGroup()
	local code=15005050
	while code<15005070 do
		if Duel.GetFlagEffect(tp,code)~=0 then
			local tg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,code)
			local tc=tg:GetFirst()
			if tc.chacon and tc.chacon(e,tp) then
				g:AddCard(tc)
			end
		end
		code=code+1
	end
	return #g
end
function Satl.AddHearogenehirpSolving(e,tp)
	local code=15005050
	local g=Group.CreateGroup()
	while code<15005070 do
		if Duel.GetFlagEffect(tp,code)~=0 then
			local tg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,code)
			local tc=tg:GetFirst()
			if tc.chacon and tc.chacon(e,tp) then
				g:AddCard(tc)
			end
		end
		code=code+1
	end
	while #g~=0 do
		g:Clear()
		local list={}
		local code=15005050
		while code<15005070 do
			if Duel.GetFlagEffect(tp,code)~=0 then
				local tg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,code)
				local tc=tg:GetFirst()
				if tc.chacon and tc.chacon(e,tp) then
					g:AddCard(tc)
					table.insert(list,code)
				end
			end
			code=code+1
		end
		if #g==0 then break end
		local list2={}
		for _,i in ipairs{table.unpack(list)} do
			table.insert(list2,aux.Stringid(i,7))
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15000000,2))
		local op=Duel.SelectOption(tp,table.unpack(list2))
		local cardcode=table.concat(list,",",op+1,op+1)
		Duel.Hint(HINT_CARD,1-tp,cardcode)
		local tc=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,cardcode):GetFirst()
		tc.chaop(e,tp)
		g:RemoveCard(tc)
		Duel.ResetFlagEffect(tp,tc:GetOriginalCodeRule())
		for _,i in ipairs{Duel.IsPlayerAffectedByEffect(tp,cardcode)} do
			if i:GetDescription()==aux.Stringid(cardcode,1) then
				i:Reset()
			end
		end
		g:Clear()
		local code=15005050
		while code<15005070 do
			if Duel.GetFlagEffect(tp,code)~=0 then
				local tg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,code)
				local tc=tg:GetFirst()
				if tc.chacon and tc.chacon(e,tp) then
					g:AddCard(tc)
				end
			end
			code=code+1
		end
		if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(15000000,3)) then
			break
		end
	end
end
function Satl.Hearogenehirpcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local p,loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	return (rc:IsSetCard(0xaf3e) or (rc:IsType(TYPE_FLIP) and re:IsActiveType(TYPE_MONSTER)))
		and bit.band(loc,LOCATION_ONFIELD)~=0 and re:GetOperation()
end
function Satl.Hearogenehirpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local rc=re:GetHandler()
	local op=re:GetOperation()
	local p,loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	if p~=re:GetHandler():GetControler() then return end
	local se3=Duel.IsPlayerAffectedByEffect(p,15005029)
	if se3 then
		for _,i in ipairs{Duel.IsPlayerAffectedByEffect(p,15005029)} do
			i:Reset()
		end
		return
	end
	if op then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(15005030)
		e1:SetTargetRange(1,0)
		e1:SetOperation(op)
		e1:SetLabelObject(re)
		e1:SetLabel(id)
		e1:SetReset(RESET_CHAIN+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,p)
		local se2=Duel.IsPlayerAffectedByEffect(p,15005031)
		local x=1
		if se2 then
			for _,i in ipairs{Duel.IsPlayerAffectedByEffect(p,15005031)} do
				if i:GetLabelObject()==re and x~=0 then
					i:Reset()
					x=0
				end
			end
		end
		if x==1 then
			Duel.ChangeChainOperation(ev,Satl.Hearogenehirpchaop)
		end
	end
end
function Satl.Hearogenehirpchaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local id=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local se=Duel.IsPlayerAffectedByEffect(tp,15005030)
	local rop=nil
	if se then
		for _,i in ipairs{Duel.IsPlayerAffectedByEffect(tp,15005030)} do
			if i:GetLabelObject()==e and i:GetLabel()==id and (not rop) then
				rop=i:GetOperation()
				i:Reset()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(15005029)
				e1:SetTargetRange(1,0)
				e1:SetReset(RESET_CHAIN+RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,p)
			end
		end
	end
	rop(e,tp,eg,ep,ev,re,r,rp)
	--if Satl.GetHearogenehirpSolvingCount(e,tp)~=0 and Duel.SelectYesNo(tp,aux.Stringid(15000000,4)) then Satl.AddHearogenehirpSolving(e,tp) end
end

function Satl.AddHearogenehirpXyzProcedureLevelFree(c,f,gf,minc,maxc)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Satl.HearogenehirpXyzLevelFreeCondition(f,gf,minc,maxc))
	e1:SetTarget(Satl.HearogenehirpXyzLevelFreeTarget(f,gf,minc,maxc))
	e1:SetOperation(Satl.HearogenehirpXyzLevelFreeOperation(f,gf,minc,maxc))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function Satl.XyzLevelFreeFilter(c,xyzc,f)
	return (not c:IsOnField() or c:IsFaceup() or (c:IsFacedown() and c:IsSetCard(0xaf3e))) and c:IsCanBeXyzMaterial(xyzc) and (not f or f(c,xyzc) or (c:IsFacedown() and c:IsSetCard(0xaf3e)))
end
function Satl.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function Satl.HearogenehirpXyzLevelFreeCondition(f,gf,minct,maxct)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(Satl.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Satl.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Satl.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function Satl.HearogenehirpXyzLevelFreeTarget(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(Satl.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Satl.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,Satl.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					local ag=g:Filter(Card.IsFacedown,nil)
					if #ag~=0 then Duel.ConfirmCards(1-tp,ag) end
					return true
				else return false end
			end
end
function Satl.HearogenehirpXyzLevelFreeOperation(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end