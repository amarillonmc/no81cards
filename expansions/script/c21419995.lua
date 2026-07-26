--珠泪哀歌族·三界甘露人鱼
--KoishiPRO专用：墓地效果使用Card.SetCardData(CARDDATA_TYPE,...)
--
--性能优化版本说明：
--  1) 所有对 IsSynchroSummonable / IsXyzSummonable / IsLinkSummonable 的调用
--     之前，都先跑一个 O(n) 的位掩码可行性判定（synfeasible / xyzfeasible /
--     linkfeasible）。这些判定是“必要条件”：返回 false 一定不可能成立，
--     返回 true 才付钱调用原生手续。因此不会产生漏解。
--  2) 素材组被压成纯整数数组（frame），并按“组指纹 + epoch”缓存，
--     同一轮融合枚举里 15 张额外卡组怪兽共享同一份 frame。
--  3) CheckSubGroup 的 goal 里先做 O(n) 的精确否决（同调等级和、连接标记和），
--     绝大多数子集不用进原生手续。
--  4) 删除了原来的 groupsignature/ctx.native 缓存（命中率接近 0，纯分配压力）。
--  5) typeadjust 加了脏检查，避免每次 EVENT_ADJUST 全量遍历 + SetCardData。
--  6) s.PROF=true 可开启内置调用计数，s.profdump() 打印。

local s,id,o=GetID()
local SET_TEARLAMENTS=0x0181
local EXTRA_PROC_TYPES=TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK
local ALL_MZONE=0x7f
local MAIN_MZONE=0x1f
local EXTRA_MZONE=0x60
local KOISHI_CARDDATA_TYPE=CARDDATA_TYPE or 4
local MAX_XYZ_MATERIALS=12
--超量素材的启发上界：给到 12 会让核心多枚举好几层且几乎无意义
local XYZ_SOFT_MAX=5

s.type_cache=s.type_cache or {}
s.type_syncing=s.type_syncing or false

--============================================================
-- 轻量计数器（默认关闭，开销接近 0）
--============================================================
s.PROF=false
s.prof=s.prof or {}
function s.pf(k)
	if not s.PROF then return end
	s.prof[k]=(s.prof[k] or 0)+1
end
function s.profreset()
	s.prof={}
end
function s.profdump(tag)
	if not s.PROF then return end
	local ks={}
	for k in pairs(s.prof) do ks[#ks+1]=k end
	table.sort(ks,function(a,b) return s.prof[a]>s.prof[b] end)
	print("==== 三界甘露人鱼 PROF "..tostring(tag).." ====")
	for _,k in ipairs(ks) do
		print(string.format("  %-30s %d",k,s.prof[k]))
	end
	print(string.format("  -- lua mem %.1f KB",collectgarbage("count")))
end

function s.initial_effect(c)
	--①：回到卡组下面，依次特殊召唤或展示素材并融合召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE|LOCATION_REMOVED)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.fuscost)
	e1:SetTarget(s.fustg)
	e1:SetOperation(s.fusop)
	c:RegisterEffect(e1)
	--②●手卡：公开
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,6))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_HAND)
	c:RegisterEffect(e2)
	--②●手卡：自己手卡的怪兽变成天使族
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,6))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetRange(LOCATION_HAND)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(s.racetg)
	e3:SetValue(RACE_FAIRY)
	c:RegisterEffect(e3)
	--②●墓地：授予标准融合框架使用的融合素材手续
	local ge=Effect.CreateEffect(c)
	ge:SetType(EFFECT_TYPE_SINGLE)
	ge:SetCode(EFFECT_FUSION_MATERIAL)
	ge:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE|EFFECT_FLAG_SET_AVAILABLE)
	ge:SetCondition(s.fmcon)
	ge:SetOperation(s.fmop)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,7))
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_GRANT)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(LOCATION_EXTRA,0)
	e4:SetCondition(s.grantcon)
	e4:SetTarget(s.extratg)
	e4:SetLabelObject(ge)
	c:RegisterEffect(e4)
	--②●除外状态：对方发动的怪兽效果处理时，可以改写那个效果
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,8))
	e5:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetCondition(s.chcon)
	e5:SetOperation(s.chop)
	c:RegisterEffect(e5)
	--KoishiPRO：同步额外卡组卡片的数据库种类
	if not s.global_type_effect then
		s.global_type_effect=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.typeadjust)
		Duel.RegisterEffect(ge1,0)
	end
end
s.listed_series={SET_TEARLAMENTS}

--============================================================
-- ①
--============================================================
function s.fuscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
			and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function s.rawmatfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.fmatfilter(c,fc)
	return c~=fc
		and c:IsType(TYPE_MONSTER)
		and not c:IsForbidden()
		and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_FUSION)
end
--取得被Koishi的SetCardData修改前的类型
function s.getbasetype(c)
	local info=s.type_cache[c]
	if info then
		return info.base_type
	end
	return c:GetOriginalType()
end
function s.fusfilter(c,e,tp,mg)
	local bt=s.getbasetype(c)
	if not c:IsSetCard(SET_TEARLAMENTS)
		or bt&TYPE_FUSION==0
		or c:IsForbidden()
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) then
		return false
	end
	if Duel.GetLocationCountFromEx(tp,tp,nil,c,ALL_MZONE)<=0 then
		return false
	end
	local mg2=mg:Filter(s.fmatfilter,nil,c)
	return c:CheckFusionMaterial(mg2,nil,tp)
end
function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		s.profreset()
		local mg=Duel.GetMatchingGroup(s.rawmatfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,nil)
		--发动检查时模拟这张卡支付代价后回到主卡组
		mg:AddCard(e:GetHandler())
		local res=Duel.IsExistingMatchingCard(s.fusfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
		s.profdump("fustg")
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.getexzones(tp,sc,allowed)
	allowed=(allowed or ALL_MZONE)&ALL_MZONE
	local ct,unavailable=Duel.GetLocationCountFromEx(tp,tp,nil,sc,allowed)
	if ct<=0 then
		return 0
	end
	return allowed&(~unavailable)&ALL_MZONE
end
function s.getmainzones(tp,allowed)
	allowed=(allowed or MAIN_MZONE)&MAIN_MZONE
	local ct,unavailable=Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_TOFIELD,allowed)
	if ct<=0 then
		return 0
	end
	return allowed&(~unavailable)&MAIN_MZONE
end
--区域选择统一用内置的 HINTMSG_ZONE（“请选择[卡名]的位置”），不再弹自造对话框
function s.selectzone(tp,zones,code)
	if zones==0 then
		return 0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ZONE)
	return Duel.SelectField(tp,1,LOCATION_MZONE,0,(~zones)&ALL_MZONE,code)&ALL_MZONE
end
function s.zoneindex(zone)
	for i=0,6 do
		if zone&(1<<i)~=0 then
			return i
		end
	end
	return -1
end
function s.zonecount(zones)
	local ct=0
	for i=0,6 do
		if zones&(1<<i)~=0 then
			ct=ct+1
		end
	end
	return ct
end
--只有一个合法格子时直接用，不问玩家
function s.pickzone(tp,zones,code)
	if zones==0 then
		return 0
	end
	if s.zonecount(zones)==1 then
		return zones
	end
	return s.selectzone(tp,zones,code)
end
--计算连接怪兽放置到指定区域后，能够新指向的自己主要怪兽区
function s.futurelinkmainzones(c,zone)
	if not c:IsType(TYPE_LINK) then
		return 0
	end
	local seq=s.zoneindex(zone)
	local z=0
	if seq>=0 and seq<=4 then
		if seq>0 and c:IsLinkMarker(LINK_MARKER_LEFT) then
			z=z|(1<<(seq-1))
		end
		if seq<4 and c:IsLinkMarker(LINK_MARKER_RIGHT) then
			z=z|(1<<(seq+1))
		end
	elseif seq==5 then
		if c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then z=z|0x1 end
		if c:IsLinkMarker(LINK_MARKER_BOTTOM) then z=z|0x2 end
		if c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then z=z|0x4 end
	elseif seq==6 then
		if c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then z=z|0x4 end
		if c:IsLinkMarker(LINK_MARKER_BOTTOM) then z=z|0x8 end
		if c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then z=z|0x10 end
	end
	return z&MAIN_MZONE
end
--不考虑保留区，只看素材当前本身能特殊召唤到哪里
function s.getrawmatspzones(c,e,tp)
	local rawzones=0
	local nocheck=false
	if c:IsLocation(LOCATION_EXTRA) then
		rawzones=s.getexzones(tp,c,ALL_MZONE)
		nocheck=true
	elseif c:IsLocation(LOCATION_DECK) then
		rawzones=s.getmainzones(tp,MAIN_MZONE)
	else
		return 0,false
	end
	if rawzones==0
		or not c:IsCanBeSpecialSummoned(e,0,tp,nocheck,false,POS_FACEUP,tp,rawzones) then
		return 0,nocheck
	end
	return rawzones,nocheck
end
--假设素材mc放到zone后，最终融合怪兽fc还能使用哪些区域
function s.getfuturefinalzones(tp,fc,mc,zone)
	local zones=s.getexzones(tp,fc,ALL_MZONE)&(~zone)&ALL_MZONE
	local opened=s.futurelinkmainzones(mc,zone)
	if opened~=0 then
		zones=zones|s.getmainzones(tp,opened)
	end
	return zones&ALL_MZONE
end
--素材可以特殊召唤到的安全格子：
--特殊召唤后必须仍然存在最终融合怪兽可用区域
function s.getsafematspzones(c,e,tp,fc)
	local rawzones,nocheck=s.getrawmatspzones(c,e,tp)
	if rawzones==0 then
		return 0,nocheck
	end
	local zones=0
	for i=0,6 do
		local z=1<<i
		if rawzones&z~=0
			and c:IsCanBeSpecialSummoned(e,0,tp,nocheck,false,POS_FACEUP,tp,z)
			and s.getfuturefinalzones(tp,fc,c,z)~=0 then
			zones=zones|z
		end
	end
	return zones,nocheck
end
--能特殊召唤的素材（用于一次性勾选）
function s.spablefilter(c,e,tp,fc)
	local zones=s.getsafematspzones(c,e,tp,fc)
	return zones~=0
end
--勾选出的素材必须能依次全部特殊召唤：
--逐个占格模拟，避免玩家勾了一组结果中途堵死
function s.spgroupcheck(sg,e,tp,fc)
	local used=0
	for tc in aux.Next(sg) do
		local zones=s.getsafematspzones(tc,e,tp,fc)&(~used)&ALL_MZONE
		if zones==0 then return false end
		--优先占用额外怪兽区以外的格子，尽量给融合怪兽留空间
		local pick=zones&MAIN_MZONE
		if pick==0 then pick=zones end
		used=used|(pick&(-pick))
	end
	return true
end
--处理素材：先一次性勾选要特殊召唤的，其余自动给对方观看。
--不预选最终融合怪兽格子，只保证特殊召唤后不会堵死最终融合召唤。
function s.processmaterials(e,tp,fc,mat)
	--可以特殊召唤的素材
	local spg=mat:Filter(s.spablefilter,nil,e,tp,fc)
	local sg=nil
	if spg:GetCount()>0 then
		--一次性勾选，可以全部不选
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=spg:SelectSubGroup(tp,s.spgroupcheck,true,0,spg:GetCount(),e,tp,fc)
	end
	--剩下的素材（未勾选 + 特殊召唤失败的）统一给对方观看
	local rg=mat:Clone()
	--逐张特殊召唤勾选的素材；只在有多个合法格子时才问区域
	if sg and sg:GetCount()>0 then
		Duel.HintSelection(sg)
		for tc in aux.Next(sg) do
			local zones,nocheck=s.getsafematspzones(tc,e,tp,fc)
			if zones~=0 then
				local zone=s.pickzone(tp,zones,tc:GetCode())
				if zone~=0
					and tc:IsCanBeSpecialSummoned(e,0,tp,nocheck,false,POS_FACEUP,tp,zone)
					and Duel.SpecialSummon(tc,0,tp,tp,nocheck,false,POS_FACEUP,zone)>0 then
					rg:RemoveCard(tc)
				end
			end
		end
	end
	if rg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
		Duel.ConfirmCards(1-tp,rg)
	end
	rg:DeleteGroup()
	if sg then sg:DeleteGroup() end
	spg:DeleteGroup()
end
function s.fusop(e,tp,eg,ep,ev,re,r,rp)
	s.profreset()
	local mg=Duel.GetMatchingGroup(s.rawmatfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,nil)
	local fg=Duel.GetMatchingGroup(s.fusfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	s.profdump("fusop-candidates")
	if fg:GetCount()==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fc=fg:Select(tp,1,1,nil):GetFirst()
	if not fc then
		return
	end
	local mg2=mg:Filter(s.fmatfilter,nil,fc)
	if not fc:CheckFusionMaterial(mg2,nil,tp) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local mat=Duel.SelectFusionMaterial(tp,fc,mg2,nil,tp)
	if not mat or mat:GetCount()==0 then
		return
	end
	s.processmaterials(e,tp,fc,mat)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	local fzones=s.getexzones(tp,fc,ALL_MZONE)
	if fzones==0 then
		return
	end
	local fzone=s.pickzone(tp,fzones,fc:GetCode())
	if fzone==0 then
		return
	end
	--特殊召唤或展示本身就是素材处理；这里只登记素材组。
	fc:SetMaterial(mat)
	if not fc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false,POS_FACEUP,tp,fzone) then
		fc:SetMaterial(nil)
		return
	end
	Duel.Hint(HINT_CARD,0,fc:GetCode())
	if Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP,fzone)>0 then
		fc:CompleteProcedure()
	else
		fc:SetMaterial(nil)
	end
end

--============================================================
-- ②●手卡
--============================================================
function s.racetg(e,c)
	return c:IsType(TYPE_MONSTER)
end

--============================================================
-- ②●墓地：Koishi类型同步
--============================================================
function s.gravesourcefilter(c)
	return c:IsCode(id) and not c:IsDisabled()
end
function s.hassource(tp)
	return Duel.IsExistingMatchingCard(s.gravesourcefilter,tp,LOCATION_GRAVE,0,1,nil)
end
--多张同名卡在墓地时，只让最早进入墓地的1张授予手续，避免重复授予
function s.grantcon(e)
	local c=e:GetHandler()
	if c:IsDisabled() then
		return false
	end
	local g=Duel.GetMatchingGroup(s.gravesourcefilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local first=nil
	for tc in aux.Next(g) do
		if not first or tc:GetFieldID()<first:GetFieldID() then
			first=tc
		end
	end
	return first==c
end
function s.extratg(e,c)
	return s.getbasetype(c)&EXTRA_PROC_TYPES~=0
end
s.adjust_state=s.adjust_state or {}
function s.synctypeplayer(tp)
	local active=s.hassource(tp)
	--脏检查：状态没变就直接返回，避免每次 ADJUST 全量遍历 + SetCardData
	local st=s.adjust_state[tp]
	local exct=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	if st and st.active==active and st.exct==exct then
		return
	end
	local present={}
	if active then
		local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		for tc in aux.Next(g) do
			local info=s.type_cache[tc]
			local bt=info and info.base_type or tc:GetOriginalType()
			if bt&EXTRA_PROC_TYPES~=0 then
				if info then
					present[tc]=true
				elseif bt&TYPE_FUSION==0 then
					s.type_cache[tc]={player=tp,base_type=bt}
					tc:SetCardData(KOISHI_CARDDATA_TYPE,bt|TYPE_FUSION)
					present[tc]=true
				end
			end
		end
	end
	for tc,info in pairs(s.type_cache) do
		if info.player==tp
			and (not active or not tc:IsLocation(LOCATION_EXTRA) or not present[tc]) then
			tc:SetCardData(KOISHI_CARDDATA_TYPE,info.base_type)
			s.type_cache[tc]=nil
		end
	end
	s.adjust_state[tp]={active=active,exct=exct}
end
function s.typeadjust(e,tp,eg,ep,ev,re,r,rp)
	if s.type_syncing then
		return
	end
	s.type_syncing=true
	--任何调整都可能改变场况，让 frame / fmcon 缓存失效
	s.epoch=(s.epoch or 0)+1
	s.synctypeplayer(0)
	s.synctypeplayer(1)
	s.type_syncing=false
end

--============================================================
-- 快速手续判定：frame + 位掩码可行性
--============================================================
--这些 EFFECT 常量在不同版本里未必都有，用 rawget 保护
local WEIRD_CODES={}
for _,n in ipairs({
		"EFFECT_SYNCHRO_LEVEL","EFFECT_XYZ_LEVEL","EFFECT_RANK_LEVEL","EFFECT_RANK_LEVEL_S",
		"EFFECT_DOUBLE_XMATERIAL","EFFECT_EXTRA_LINK_MATERIAL","EFFECT_XYZ_MIN_COUNT",
		"EFFECT_TUNE_MAGICIAN_F","EFFECT_TUNE_MAGICIAN_X","EFFECT_NONTUNER"}) do
	local v=rawget(_G,n)
	if v then WEIRD_CODES[#WEIRD_CODES+1]=v end
end
local MIXC=0x9E3779B97F4A7C15

s.epoch=s.epoch or 0
s.frame=nil
s.frame_epoch=-1
s.frame_fp=nil
s.concache=s.concache or {}
s.concache_epoch=-1

function s.cardkey(c)
	local fid=c:GetFieldID()
	if not fid or fid==0 then
		fid=c:GetCode()*64+c:GetLocation()*8+c:GetSequence()+1
	end
	return fid
end
--与遍历顺序无关的组指纹
function s.groupfp(g)
	local h=0
	local ct=0
	for tc in aux.Next(g) do
		ct=ct+1
		h=h~(s.cardkey(tc)*MIXC)
	end
	return h,ct
end
--把素材组压成纯整数数组
function s.buildframe(mg)
	s.pf("buildframe")
	local f={cards={},lv={},link={},lvcount={},n=0,
		weird=false,haslinkmat=false,linkslack=0,onfield=0}
	for tc in aux.Next(mg) do
		local n=f.n+1
		f.n=n
		f.cards[n]=tc
		local lv=tc:GetLevel()
		f.lv[n]=lv
		if lv>0 then f.lvcount[lv]=(f.lvcount[lv] or 0)+1 end
		local lk=(tc:IsType(TYPE_LINK) and tc:GetLink()) or 0
		f.link[n]=lk
		if lk>1 then
			f.haslinkmat=true
			f.linkslack=f.linkslack+lk-1
		end
		if tc:IsOnField() then f.onfield=f.onfield+1 end
		if not f.weird then
			if tc:IsType(TYPE_PENDULUM) or tc:GetHandSynchro()~=0 then
				f.weird=true
			else
				for i=1,#WEIRD_CODES do
					if tc:IsHasEffect(WEIRD_CODES[i]) then
						f.weird=true
						break
					end
				end
			end
		end
	end
	return f
end
--按“指纹 + epoch”缓存 frame，同一轮枚举里所有 fc 共享
function s.getframe(mg)
	local fp,ct=s.groupfp(mg)
	if s.frame and s.frame_epoch==s.epoch and s.frame_fp==fp and s.frame.n==ct then
		s.pf("frame-hit")
		return s.frame
	end
	s.frame=s.buildframe(mg)
	s.frame_epoch=s.epoch
	s.frame_fp=fp
	return s.frame
end

--同调：位掩码子集和。
--普适约束是“素材等级总和 == 融合怪兽等级，且至少含 1 只调整”，
--对所有同调手续（含多调整、SynMix）都成立，因此不会漏解。
--返回 可行?, 最小调整等级
function s.synfeasible(f,fc)
	s.pf("synfeasible")
	local lv=fc:GetLevel()
	if lv<=1 or f.n<2 then return false,0 end
	local mask=(1<<(lv+1))-1
	local rT=0    --使用了至少1只调整时的可达等级和
	local rN=1    --非调整的可达等级和（含空集）
	local mintlv=99
	for i=1,f.n do
		local l=f.lv[i]
		if l>0 and l<=lv then
			if f.cards[i]:IsTuner(fc) then
				rT=(rT|((rT|1)<<l))&mask
				if l<mintlv then mintlv=l end
			else
				rN=(rN|(rN<<l))&mask
			end
		end
	end
	if rT==0 then return false,0 end
	for a=1,lv do
		if (rT>>a)&1==1 and (rN>>(lv-a))&1==1 then
			return true,mintlv
		end
	end
	return false,0
end
--超量：标准手续要求 ≥2 只同（阶级对应的）等级素材。
--f.weird 时退化为只判张数，保证不漏解。
function s.xyzfeasible(f,fc)
	s.pf("xyzfeasible")
	if f.n<2 then return false end
	if f.weird then return true end
	local rk=fc:GetRank()
	if rk<=0 then return true end
	return (f.lvcount[rk] or 0)>=2
end
--连接：每张素材贡献 1 或自身 link 值，做 1/link 背包
function s.linkfeasible(f,fc)
	s.pf("linkfeasible")
	local lk=fc:GetLink()
	if lk<=0 or f.n<=0 then return false end
	if not f.haslinkmat then
		--没有连接素材时，标记和恒等于张数
		return f.n>=lk
	end
	local mask=(1<<(lk+1))-1
	local r=1
	for i=1,f.n do
		local b=f.link[i]
		local nr=(r<<1)&mask
		if b>1 then nr=nr|((r<<b)&mask) end
		r=(r|nr)&mask
	end
	return (r>>lk)&1==1
end

--调用原生手续时需要临时清掉外部的 GCheckAdditional / SelectedCard
function s.protectedcall(fn,a,b,c,d)
	local saved_gcheck=Auxiliary.GCheckAdditional
	local saved_selected=Duel.GrabSelectedCard()
	Auxiliary.GCheckAdditional=nil
	local res=fn(a,b,c,d)
	Duel.GrabSelectedCard()
	Auxiliary.GCheckAdditional=saved_gcheck
	if saved_selected and saved_selected:GetCount()>0 then
		Duel.SetSelectedCard(saved_selected)
	end
	return res
end
function s.callsyn(fc,mg,mn,mx)
	s.pf("native:Synchro")
	return fc:IsSynchroSummonable(nil,mg,mn,mx)
end
function s.callxyz(fc,mg,mn,mx)
	s.pf("native:Xyz")
	return fc:IsXyzSummonable(mg,mn,mx)
end
function s.calllink(fc,mg,mn,mx)
	s.pf("native:Link")
	return fc:IsLinkSummonable(mg,nil,mn,mx)
end

--连接手续里 LCheckGoal 每个子集都会调 GetLocationCountFromEx。
--若没有任何素材在场上，这个值与子集无关，可以提前一次性判死。
function s.exzoneblocked(tp,fc,f)
	if f.onfield>0 then return false end
	return Duel.GetLocationCountFromEx(tp,tp,nil,fc)<=0
end

--快速存在性检查：先 O(n) 否决，再调原生手续
function s.checknativeany_fast(fc,mg,f,tp)
	local bt=s.getbasetype(fc)
	if bt&TYPE_SYNCHRO~=0 then
		local ok,mintlv=s.synfeasible(f,fc)
		if ok then
			--非调整素材数上界 = 等级 - 最小调整等级
			local maxn=math.min(f.n-1,fc:GetLevel()-mintlv)
			if maxn>=1 and s.protectedcall(s.callsyn,fc,mg,1,maxn) then
				return true
			end
		end
	end
	if bt&TYPE_XYZ~=0 and s.xyzfeasible(f,fc) then
		local maxc=math.min(f.n,XYZ_SOFT_MAX,MAX_XYZ_MATERIALS)
		if maxc>=2 and s.protectedcall(s.callxyz,fc,mg,2,maxc) then
			return true
		end
	end
	if bt&TYPE_LINK~=0 and s.linkfeasible(f,fc) and not s.exzoneblocked(tp,fc,f) then
		local lk=math.max(1,fc:GetLink())
		--没有连接素材时张数被锁死，CheckSubGroup 的 goal 调用次数大幅下降
		local minc=lk
		if f.haslinkmat then minc=math.max(1,lk-f.linkslack) end
		local maxc=math.min(f.n,lk)
		if maxc>=minc and s.protectedcall(s.calllink,fc,mg,minc,maxc) then
			return true
		end
	end
	return false
end

--============================================================
-- 整组精确判定（CheckSubGroup 的 goal 内层用）
--============================================================
--O(n) 的精确否决：返回 true 表示“这组一定不行”。
--同调看等级总和，连接看标记和，都是必要且（对普通素材）充分的强条件。
function s.quickreject(fc,sg)
	s.pf("quickreject")
	local bt=s.getbasetype(fc)
	local n=sg:GetCount()
	if n==0 then return true end
	if bt&TYPE_SYNCHRO~=0 then
		local sum=0
		local ht=false
		local bad=false
		for tc in aux.Next(sg) do
			local l=tc:GetLevel()
			if l<=0 then bad=true break end
			sum=sum+l
			if not ht and tc:IsTuner(fc) then ht=true end
		end
		if not bad and ht and n>=2 and sum==fc:GetLevel() then
			return false
		end
	end
	if bt&TYPE_XYZ~=0 and n>=2 then
		return false
	end
	if bt&TYPE_LINK~=0 then
		local lk=fc:GetLink()
		local need=lk-n
		if need>=0 then
			if need==0 then return false end
			local mask=(1<<(need+1))-1
			local r=1
			for tc in aux.Next(sg) do
				local b=(tc:IsType(TYPE_LINK) and tc:GetLink()) or 0
				if b>1 then r=(r|(r<<(b-1)))&mask end
			end
			if (r>>need)&1==1 then return false end
		end
	end
	return true
end
--用一整组sg检查原本的同调·超量·连接手续。
--精确限定素材张数，因此成功时原则上就是使用整个sg。
function s.checknativegroup(fc,sg)
	local bt=s.getbasetype(fc)
	local n=sg:GetCount()
	if n==0 then return false end
	if s.quickreject(fc,sg) then return false end
	local res=false
	if bt&TYPE_SYNCHRO~=0 and n>=2 then
		--不写死“恰好1只调整”：按组内实际调整数尝试
		local tct=0
		for tc in aux.Next(sg) do
			if tc:IsTuner(fc) then tct=tct+1 end
		end
		local maxt=math.min(tct,n-1,3)
		for t=1,maxt do
			if s.protectedcall(s.callsyn,fc,sg,n-t,n-t) then
				res=true
				break
			end
		end
	end
	if not res and bt&TYPE_XYZ~=0 then
		res=s.protectedcall(s.callxyz,fc,sg,n,n)
	end
	if not res and bt&TYPE_LINK~=0 then
		res=s.protectedcall(s.calllink,fc,sg,n,n)
	end
	return res
end

--============================================================
-- 素材计划（plan）
--   SelectSubGroup 会把 goal 调用成百上千次，每次都跑原生手续太贵。
--   这里用 O(n) 次原生“单卡探针”把手续的规则学出来：
--     连接：IsLinkSummonable(og,lmat,...) 的 lmat 可以强制某张卡参与
--     同调：IsSynchroSummonable(smat,mg,...) 的 smat 同理
--   学完以后 goal 就退化成“查表 + 加法”，完全不碰原生手续。
--   最后再用抽样验证 + 选定后的一次确认兜底，保证不会出非法组合。
--============================================================
function s.calllinkm(fc,mg,lmat,k)
	s.pf("probe:Link")
	return fc:IsLinkSummonable(mg,lmat,k,k)
end
function s.callsynm(fc,mg,smat,maxn)
	s.pf("probe:Synchro")
	return fc:IsSynchroSummonable(smat,mg,1,maxn)
end
--从 list 里按偏移取 k 张，做抽样验证用
function s.takewitness(list,k,off)
	local n=#list
	if n<k then return nil end
	local t,seen={},{}
	for i=1,k do
		local tc=list[((off+i-1)%n)+1]
		if seen[tc] then return nil end
		seen[tc]=true
		t[i]=tc
	end
	return Group.FromCards(table.unpack(t))
end
--在 ok 集合里找一组等级和恰好为 target、且含调整的组合
function s.synwitness(plan,skip)
	local cards={}
	for i=1,#plan.list do
		local tc=plan.list[i]
		if tc~=skip then cards[#cards+1]=tc end
	end
	local n=#cards
	local target=plan.target
	local res=nil
	local cur={}
	local function dfs(i,sum,ht)
		if sum==target and ht and #cur>=2 then
			res=Group.FromCards(table.unpack(cur))
			return
		end
		if sum>=target or i>n then return end
		for j=i,n do
			local tc=cards[j]
			local l=plan.lv[tc]
			if l and l>0 and sum+l<=target then
				cur[#cur+1]=tc
				dfs(j+1,sum+l,ht or plan.tuner[tc])
				cur[#cur]=nil
				if res then return end
			end
		end
	end
	dfs(1,0,false)
	return res
end
--抽样验证：计划算出来的组合，拿几组去问原生手续。
--全部一致才敢信任；有一组不一致说明这只怪兽的手续带组级约束（gf），退回精确路径。
function s.validateplan(plan,fc)
	local samples={}
	if plan.kind=="synchro" then
		local w=s.synwitness(plan,nil)
		if not w then return false end
		samples[#samples+1]=w
		local w2=s.synwitness(plan,plan.list[1])
		if w2 then samples[#samples+1]=w2 end
	else
		for k in pairs(plan.sizes) do
			local a=s.takewitness(plan.list,k,0)
			if a then samples[#samples+1]=a end
			local b=s.takewitness(plan.list,k,#plan.list-1)
			if b then samples[#samples+1]=b end
		end
	end
	if #samples==0 then return false end
	for i=1,#samples do
		if not s.checknativegroup(fc,samples[i]) then
			s.pf("plan-reject")
			return false
		end
	end
	return true
end
function s.buildplan(fc,mg,f,tp)
	s.pf("buildplan")
	local bt=s.getbasetype(fc)
	local plan={ok={},lv={},tuner={},list={},sizes={},kind=nil,target=0}
	if bt&TYPE_LINK~=0 and not f.haslinkmat then
		--有连接素材做素材时张数不固定，规则复杂，不建计划
		if not s.linkfeasible(f,fc) then return nil end
		local lk=math.max(1,fc:GetLink())
		if f.n<lk then return nil end
		for i=1,f.n do
			local tc=f.cards[i]
			if s.protectedcall(s.calllinkm,fc,mg,tc,lk) then
				plan.ok[tc]=true
				plan.list[#plan.list+1]=tc
			end
		end
		if #plan.list<lk then return nil end
		plan.kind="link"
		plan.sizes[lk]=true
		plan.target=lk
	elseif bt&TYPE_SYNCHRO~=0 then
		local ok,mintlv=s.synfeasible(f,fc)
		if not ok then return nil end
		local lv=fc:GetLevel()
		local maxn=math.min(f.n-1,lv-mintlv)
		if maxn<1 then return nil end
		local ht=false
		for i=1,f.n do
			local tc=f.cards[i]
			local l=f.lv[i]
			if l>0 and l<lv and s.protectedcall(s.callsynm,fc,mg,tc,maxn) then
				plan.ok[tc]=true
				plan.lv[tc]=l
				local t=tc:IsTuner(fc)
				plan.tuner[tc]=t
				if t then ht=true end
				plan.list[#plan.list+1]=tc
			end
		end
		if #plan.list<2 or not ht then return nil end
		plan.kind="synchro"
		plan.target=lv
	elseif bt&TYPE_XYZ~=0 then
		if f.n<2 then return nil end
		local rk=fc:GetRank()
		local okg=Group.CreateGroup()
		for i=1,f.n do
			local tc=f.cards[i]
			if tc:IsCanBeXyzMaterial(fc) and (rk<=0 or tc:IsXyzLevel(fc,rk)) then
				plan.ok[tc]=true
				plan.list[#plan.list+1]=tc
				okg:AddCard(tc)
			end
		end
		if #plan.list<2 then return nil end
		local any=false
		for k=2,math.min(#plan.list,XYZ_SOFT_MAX) do
			if s.protectedcall(s.callxyz,fc,okg,k,k) then
				plan.sizes[k]=true
				any=true
			end
		end
		if not any then return nil end
		plan.kind="xyz"
	else
		return nil
	end
	plan.trusted=s.validateplan(plan,fc)
	if not plan.trusted then return nil end
	return plan
end
s.plancache=s.plancache or {}
s.plancache_epoch=-1
function s.getplan(fc,mg,f,tp)
	if s.plancache_epoch~=s.epoch then
		s.plancache={}
		s.plancache_epoch=s.epoch
	end
	local key=s.cardkey(fc).."|"..tostring(s.frame_fp)
	local p=s.plancache[key]
	if p==nil then
		p=s.buildplan(fc,mg,f,tp) or false
		s.plancache[key]=p
	else
		s.pf("plan-hit")
	end
	return p or nil
end
--纯整数运算的 goal
function s.plangoal(plan,sg)
	s.pf("plangoal")
	local n=sg:GetCount()
	if plan.kind=="synchro" then
		if n<2 then return false end
		local sum,ht=0,false
		for tc in aux.Next(sg) do
			if not plan.ok[tc] then return false end
			sum=sum+plan.lv[tc]
			if sum>plan.target then return false end
			if not ht and plan.tuner[tc] then ht=true end
		end
		return sum==plan.target and ht
	end
	if not plan.sizes[n] then return false end
	for tc in aux.Next(sg) do
		if not plan.ok[tc] then return false end
	end
	return true
end
function s.planbounds(plan,f)
	if plan.kind=="synchro" then
		return 2,math.min(f.n,plan.target)
	end
	local mn,mx=99,0
	for k in pairs(plan.sizes) do
		if k<mn then mn=k end
		if k>mx then mx=k end
	end
	if mx==0 then return 1,0 end
	return mn,math.min(mx,f.n)
end

--============================================================
-- ②●墓地：标准融合框架用融合素材手续
--============================================================
--粗检测用：只判断文本意义上“可能是允许的素材”
function s.fmfastcandidate(c,fc)
	return c:IsFusionType(TYPE_MONSTER)
		and c:IsFusionSetCard(SET_TEARLAMENTS)
end
--精确选择用：真正进入融合素材选择时才检查能否作为当前怪兽的融合素材
function s.fmcandidate(c,fc,notfusion)
	local checktype=notfusion and SUMMON_TYPE_SPECIAL or SUMMON_TYPE_FUSION
	return c:IsFusionType(TYPE_MONSTER)
		and c:IsFusionSetCard(SET_TEARLAMENTS)
		and c:IsCanBeFusionMaterial(fc,checktype)
end
function s.getnativebounds(fc,f)
	local bt=s.getbasetype(fc)
	local maxc=f.n
	local minc=1
	if bt&TYPE_LINK~=0 then
		local lk=math.max(1,fc:GetLink())
		maxc=math.min(maxc,lk)
		minc=lk
		if f.haslinkmat then minc=math.max(1,lk-f.linkslack) end
	elseif bt&TYPE_SYNCHRO~=0 then
		maxc=math.min(maxc,math.max(2,fc:GetLevel()))
		minc=2
	elseif bt&TYPE_XYZ~=0 then
		maxc=math.min(maxc,XYZ_SOFT_MAX,MAX_XYZ_MATERIALS)
		minc=2
	end
	return minc,maxc
end
function s.notingroup(c,g)
	return not g:IsContains(c)
end
function s.getforcedmaterial(tp,gc,mg)
	local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_FMATERIAL):Clone()
	if gc then
		fg:AddCard(gc)
	end
	if fg:IsExists(s.notingroup,1,nil,mg) then
		fg:DeleteGroup()
		return nil
	end
	return fg
end
function s.hasexactfusionconstraint(tp,fc,gc,chkfnf,mg)
	if gc then
		return true
	end
	local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_FMATERIAL)
	if fg and fg:GetCount()>0 then
		return true
	end
	if Auxiliary.GCheckAdditional
		or Auxiliary.FCheckAdditional
		or Auxiliary.FGoalCheckAdditional then
		return true
	end
	local notfusion=chkfnf&(0x100|0x200)~=0
	if not notfusion
		and Auxiliary.TuneMagicianCheckX
		and mg:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,mg,EFFECT_TUNE_MAGICIAN_F) then
		return true
	end
	local chkf=chkfnf&0xff
	if chkf~=PLAYER_NONE then
		local z=s.getexzones(tp,fc,ALL_MZONE)
		if z&EXTRA_MZONE==0 then
			return true
		end
	end
	return false
end
function s.fmgoal(sg,fc,tp,gc,chkfnf,plan)
	chkfnf=chkfnf or PLAYER_NONE
	--先做最便宜的判定
	if gc and not sg:IsContains(gc) then
		return false
	end
	--有计划时：纯整数运算，完全不碰原生手续
	if plan then
		if not s.plangoal(plan,sg) then return false end
	elseif s.quickreject(fc,sg) then
		return false
	end
	if not Auxiliary.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then
		return false
	end
	local notfusion=chkfnf&(0x100|0x200)~=0
	if not notfusion
		and Auxiliary.TuneMagicianCheckX
		and sg:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then
		return false
	end
	local chkf=chkfnf&0xff
	if chkf~=PLAYER_NONE
		and Duel.GetLocationCountFromEx(tp,tp,sg,fc)<=0 then
		return false
	end
	if Auxiliary.FCheckAdditional
		and not Auxiliary.FCheckAdditional(tp,sg,fc) then
		return false
	end
	if Auxiliary.FGoalCheckAdditional
		and not Auxiliary.FGoalCheckAdditional(tp,sg,fc) then
		return false
	end
	if plan then
		return true
	end
	--没有计划时才走昂贵的原生手续
	return s.checknativegroup(fc,sg)
end
function s.fmcon(e,g,gc,chkfnf)
	s.pf("fmcon")
	chkfnf=chkfnf or PLAYER_NONE
	if not g then
		return false
	end
	local fc=e:GetHandler()
	local tp=fc:GetControler()
	--粗候选：不检查每张卡能否作为当前怪兽的融合素材
	local fastmg=g:Filter(s.fmfastcandidate,nil,fc)
	local f=s.getframe(fastmg)
	local minc,maxc=s.getnativebounds(fc,f)
	if maxc<minc then
		return false
	end
	--最常见路径：没有额外融合组限制时，只做原本召唤手续的存在性检查。
	if not s.hasexactfusionconstraint(tp,fc,gc,chkfnf,fastmg) then
		--同一 epoch 内，(fc, 组指纹, chkfnf) 相同则直接复用结果
		if s.concache_epoch~=s.epoch then
			s.concache={}
			s.concache_epoch=s.epoch
		end
		local key=s.cardkey(fc).."|"..tostring(s.frame_fp).."|"..chkfnf
		local v=s.concache[key]
		if v==nil then
			v=s.checknativeany_fast(fc,fastmg,f,tp)
			s.concache[key]=v
		else
			s.pf("fmcon-hit")
		end
		return v
	end
	--存在gc、必须融合素材、外部组限制或区域依赖时，仍然用粗候选做可能性枚举。
	local forced=s.getforcedmaterial(tp,gc,fastmg)
	if not forced then
		return false
	end
	minc=math.max(minc,forced:GetCount())
	if maxc<minc then
		forced:DeleteGroup()
		return false
	end
	--这条路径要枚举子集，尽量用计划把 goal 压成整数运算
	local plan=s.getplan(fc,fastmg,f,tp)
	if plan then
		local pmn,pmx=s.planbounds(plan,f)
		minc=math.max(minc,pmn)
		maxc=math.min(maxc,pmx)
		if maxc<minc then
			forced:DeleteGroup()
			return false
		end
	end
	local saved_selected=Duel.GrabSelectedCard()
	if forced:GetCount()>0 then
		Duel.SetSelectedCard(forced)
	end
	s.pf("fmcon-subgroup")
	local res=fastmg:CheckSubGroup(s.fmgoal,minc,maxc,fc,tp,gc,chkfnf,plan)
	Duel.GrabSelectedCard()
	if saved_selected and saved_selected:GetCount()>0 then
		Duel.SetSelectedCard(saved_selected)
	end
	forced:DeleteGroup()
	return res
end
function s.fmop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	chkfnf=chkfnf or PLAYER_NONE
	local fc=e:GetHandler()
	local notfusion=chkfnf&(0x100|0x200)~=0
	--真正选择素材时使用精确候选
	local mg=eg:Filter(s.fmcandidate,nil,fc,notfusion)
	local f=s.getframe(mg)
	local forced=s.getforcedmaterial(tp,gc,mg)
	if not forced then
		Duel.SetFusionMaterial(Group.CreateGroup())
		return
	end
	local minc,maxc=s.getnativebounds(fc,f)
	minc=math.max(minc,forced:GetCount())
	--选择阶段是 goal 调用量最大的地方，优先建计划
	local plan=s.getplan(fc,mg,f,tp)
	if plan then
		local pmn,pmx=s.planbounds(plan,f)
		minc=math.max(minc,pmn)
		maxc=math.min(maxc,pmx)
	end
	if maxc<minc then
		forced:DeleteGroup()
		Duel.SetFusionMaterial(Group.CreateGroup())
		return
	end
	local saved_selected=Duel.GrabSelectedCard()
	if forced:GetCount()>0 then
		Duel.SetSelectedCard(forced)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local cancel=notfusion and Duel.GetCurrentChain()==0
	local sg=mg:SelectSubGroup(tp,s.fmgoal,cancel,minc,maxc,fc,tp,gc,chkfnf,plan)
	--计划兜底：选出来的组再用原生手续确认一次。
	--正常情况下必然通过；万一手续带了抽样没覆盖到的组级约束，
	--就作废计划、清缓存、退回精确路径重选一次。
	if sg and plan and not s.checknativegroup(fc,sg) then
		s.pf("plan-miss")
		s.plancache={}
		s.plancache_epoch=-1
		local mn,mx=s.getnativebounds(fc,f)
		mn=math.max(mn,forced:GetCount())
		if mx>=mn then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			sg=mg:SelectSubGroup(tp,s.fmgoal,cancel,mn,mx,fc,tp,gc,chkfnf,nil)
		else
			sg=nil
		end
	end
	Duel.GrabSelectedCard()
	if saved_selected and saved_selected:GetCount()>0 then
		Duel.SetSelectedCard(saved_selected)
	end
	forced:DeleteGroup()
	if sg then
		Duel.SetFusionMaterial(sg)
	else
		Duel.SetFusionMaterial(Group.CreateGroup())
	end
	s.profdump("fmop")
end

--============================================================
-- ②●除外状态：改写对方怪兽效果
--============================================================
--里侧·表侧除外状态都算，调整以外的水族·天使族
function s.chfilter(c)
	return c:IsRace(RACE_AQUA|RACE_FAIRY)
		and c:IsType(TYPE_MONSTER)
		and not c:IsType(TYPE_TUNER)
		and c:IsAbleToHand()
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=1-rp
	return c:IsFaceup()
		and rp==1-tp
		and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(s.chfilter,p,LOCATION_REMOVED,0,1,nil)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=1-rp
	if not c:IsFaceup()
		or not c:IsLocation(LOCATION_REMOVED)
		or rp~=1-tp
		or not re:IsActiveType(TYPE_MONSTER) then
		return
	end
	if not Duel.IsExistingMatchingCard(s.chfilter,p,LOCATION_REMOVED,0,1,nil) then
		return
	end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,8)) then
		return
	end
	--原效果不再处理原来的对象
	Duel.ChangeTargetCard(ev,Group.CreateGroup())
	--把那个怪兽效果的处理改成：
	--“对方里侧·表侧除外状态的调整以外的水族·天使族怪兽全部回到手卡”
	Duel.ChangeChainOperation(
		ev,
		function(e,tp,eg,ep,ev,re,r,rp)
			s.repop(p)
		end
	)
end
function s.repop(p)
	local g=Duel.GetMatchingGroup(s.chfilter,p,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,g)
	end
end