--罗生之蝶 罗生蝶
local m=43410010
local cm=_G["c"..m]

function cm.initial_effect(c)
	--【隐密效果】在特殊召唤成功时，记录它来自的区域（用于支撑②效果的判定）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)

	--①：这张卡被「罗生之蝶」怪兽发动的效果特殊召唤的场合才能发动。
	--自己选卡组1张「罗生之蝶」永续魔法在自己场上表侧表示放置。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.setcon)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)

	--②抗性：以这张卡从 手卡·卡组·墓地 中哪里特召来适用
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)

	--②主动：对方场上1张卡送去对应区域。如果失败，获得反制全连锁的附加效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.sendcon)
	e3:SetTarget(cm.sendtg)
	e3:SetOperation(cm.sendop)
	c:RegisterEffect(e3)

	--③：1回合1次，这张卡被送去墓地的场合才能发动。
	--从卡组把1只「罗生之蝶 罗生蝶」以外的「罗生之蝶」怪兽特殊召唤。
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1) --文本为"1回合1次,这张卡..."属于单体同卡独立结算的Soft-OPT
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end

--=========================
--隐密：记录召唤来源区域
--=========================
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetPreviousLocation()
	--记录位置代码，供后续判定
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,loc)
end

--=========================
--①效果相关函数
--=========================
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	--判断是被效果特召的，且效果来源是本家怪兽
	if not re then return false end
	local rc=re:GetHandler()
	-- 【修复点】：使用兼容旧版核心的写法替换 IsOriginalType
	return rc:IsSetCard(0xfb0) and bit.band(rc:GetOriginalType(),TYPE_MONSTER)~=0
end
function cm.setfilter(c)
	return c:IsSetCard(0xfb0) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

--=========================
--②效果相关函数：被动抗性
--=========================
function cm.efilter(e,re)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)==0 then return false end
	local o_loc=c:GetFlagEffectLabel(m)
	if not o_loc then return false end
	
	local valid_locs=LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE
	--仅对“发动的效果”生效
	if not re:IsHasType(EFFECT_TYPE_ACTIONS) then return false end
	
	--如果从手卡/卡组/墓地特召
	if bit.band(o_loc,valid_locs)~=0 then
		--计算剩余的两个区域
		local rest_locs=valid_locs - bit.band(o_loc,valid_locs)
		if rest_locs==0 then return false end
		--判断起效卡是否在剩余区域发动
		return bit.band(re:GetActivateLocation(),rest_locs)~=0
	else
		--从其它区域(如除外区/额外等)特召，代替为：不受对方发动的效果影响
		return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
	end
end

--=========================
--②效果相关函数：主动送回
--=========================
function cm.sendcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)==0 then return false end
	local o_loc=c:GetFlagEffectLabel(m)
	--仅在从这三大区域特召时才具有此效果
	return o_loc and bit.band(o_loc,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)~=0
end
function cm.sendtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
end
function cm.sendop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local o_loc=c:GetFlagEffectLabel(m)
	if not o_loc then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	
	local real_dest = 0
	if bit.band(o_loc,LOCATION_HAND)~=0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		real_dest=LOCATION_HAND
	elseif bit.band(o_loc,LOCATION_DECK)~=0 then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		real_dest=LOCATION_DECK
	elseif bit.band(o_loc,LOCATION_GRAVE)~=0 then
		Duel.SendtoGrave(tc,REASON_EFFECT)
		real_dest=LOCATION_GRAVE
	end
	
	--检查是否未能送去对应区域（被代破、或者被其它效果强行除外等）
	local is_failed = false
	if real_dest==LOCATION_HAND and not tc:IsLocation(LOCATION_HAND) then is_failed=true end
	--注意：回到卡组可能会去往额外卡组(对于融合同调等怪兽视为成功送达)
	if real_dest==LOCATION_DECK and not tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then is_failed=true end
	if real_dest==LOCATION_GRAVE and not tc:IsLocation(LOCATION_GRAVE) then is_failed=true end
	
	if is_failed and c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,3)) -- 提示：附加反制效果已开启
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,4)) --附加的反制效果
		e1:SetCategory(CATEGORY_DISABLE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.negcon)
		e1:SetTarget(cm.negtg)
		e1:SetOperation(cm.negop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

--=========================
--②效果扩展：反制全连锁
--=========================
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	--对方应对自己卡的效果发动时，连锁2以后
	if ep==tp then return false end
	if ev<=1 then return false end
	--上一个连锁（被应对的那个连锁）必须是自己发动的
	local pre_p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_PLAYER)
	return pre_p==tp
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local o_loc=c:GetFlagEffectLabel(m)
	if not o_loc then return end
	
	local ng=Group.CreateGroup()
	--遍历当前整条连锁链，将上面“所有”对方的卡发动无效
	for i=1,ev do
		local p,re1=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
		if p==1-tp then
			if Duel.NegateActivation(i) then
				local rc=re1:GetHandler()
				if rc:IsRelateToEffect(re1) then
					ng:AddCard(rc)
				end
			end
		end
	end
	
	--无效完毕后，检查被无效的卡是否在对应区域，不在则全送进去
	if ng:GetCount()>0 then
		local tg=Group.CreateGroup()
		for tc in aux.Next(ng) do
			local dest_match=false
			if bit.band(o_loc,LOCATION_HAND)~=0 and tc:IsLocation(LOCATION_HAND) then dest_match=true end
			if bit.band(o_loc,LOCATION_DECK)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then dest_match=true end
			if bit.band(o_loc,LOCATION_GRAVE)~=0 and tc:IsLocation(LOCATION_GRAVE) then dest_match=true end
			
			if not dest_match then
				tg:AddCard(tc)
			end
		end
		if tg:GetCount()>0 then
			if bit.band(o_loc,LOCATION_HAND)~=0 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
			elseif bit.band(o_loc,LOCATION_DECK)~=0 then
				Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
			elseif bit.band(o_loc,LOCATION_GRAVE)~=0 then
				Duel.SendtoGrave(tg,REASON_EFFECT)
			end
		end
	end
end

--=========================
--③效果相关函数：送墓特召
--=========================
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xfb0) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end