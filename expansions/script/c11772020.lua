local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- 记述卡名
	aux.AddCodeList(c,11772015,11772030)
	
	-- 融合材质：「11772015」 + 龙族怪兽
	aux.AddFusionProcMix(c,true,true,11772015,s.matfilter)

	-- ①：场上·墓地·除外状态的这张卡的卡名当作「1172015」使用。
	aux.EnableChangeCode(c,11772015,LOCATION_MZONE+LOCATION_REMOVED+LOCATION_GRAVE)

	-- ②：这张卡不会被效果破坏，对方不能把这张卡作为效果的对象。
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)

	-- ③：这张卡特殊召唤的场合才能发动。从自己的卡组·墓地·除外状态把1张有「11772015」卡名记述的魔法·陷阱卡在自己场上盖放。这个效果盖放的卡在盖放的回合也能发动。
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.settg)
	e4:SetOperation(s.setop)
	c:RegisterEffect(e4)

	-- ④：自己的「11772030」连锁对方的卡的效果发动时才能发动。那个效果连锁的卡的效果无效并破坏。
	-- 文本没有提及此效果有1回合1次的限制，故未添加 CountLimit。
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.discon)
	e5:SetTarget(s.distg)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)
end

-- 融合素材过滤：龙族怪兽
function s.matfilter(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp)
end

-- ③ 效果逻辑：盖放魔陷
function s.setfilter(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL)  and aux.IsCodeListed(c,11772015) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	-- NecroValleyFilter 兼容王家长眠之谷裁定
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		-- 只有陷阱卡和速攻魔法盖放当回合不能发动，需要特殊赋予权限
		if tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		elseif tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end

-- ④ 效果逻辑：拦截“被 11772030 连锁的对方效果”
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	-- 判断当前连锁（即刚刚发动的效果）是否是己方的「11772030」
	if ep~=tp or not re:GetHandler():IsCode(11772030) then return false end
	-- 确保当前连锁之前还有一环（即 ev-1 存在），并且前一环是对方发动的效果
	if ev<2 then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	-- 判定被连锁的是否是对方效果，且该效果能够被无效
	return p==1-tp and Duel.IsChainDisablable(ev-1)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- 获取上一环（ev-1）的信息用于设置 Target 标记
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,te:GetHandler(),1,0,0)
	if te:GetHandler():IsDestructable() and te:GetHandler():IsRelateToEffect(te) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,te:GetHandler(),1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	-- 将上一环（被 11772030 连锁的效果）无效并破坏
	if Duel.NegateEffect(ev-1) and te:GetHandler():IsRelateToEffect(te) then
		Duel.Destroy(te:GetHandler(),REASON_EFFECT)
	end
end