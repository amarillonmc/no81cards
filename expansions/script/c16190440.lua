local s,id=GetID()
function s.initial_effect(c)
	-- 此卡不能通常召唤
	c:EnableReviveLimit()

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)

	-- 特召规则：把自己场上2只怪兽解放（根据对方发动效果次数递减），让对方场上1~2张表侧表示卡回到手卡·额外卡组
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)

	-- 用于统计对方发动效果的计数器（如果返回 false 则计入计数）
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)

	-- ①：自己把怪兽召唤·特殊召唤之际，让场上这张卡回到卡组发动（必发）。那个无效，那些怪兽回到卡组。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.discon)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)

	-- ②：不能解放
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)

	-- ②：不能作为素材
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(s.fuslimit)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e8)
	local e9=e5:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e9)
	local e10=e5:Clone()
	e10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e10)

	-- ②：攻击力·守备力上升双方手卡数量×100
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(s.adval)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e12)

	-- ③：在同1次的战斗阶段中可以作2次攻击
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_EXTRA_ATTACK)
	e13:SetValue(1)
	c:RegisterEffect(e13)
end

-- ==================== 特召规则与计数 ====================
function s.chainfilter(re,tp)
	return false
end
function s.thfilter(c)
	if not c:IsFaceup() then return false end
	-- 判定是否为额外卡组怪兽，额外卡组怪兽判定 IsAbleToDeckAsCost，主卡组怪兽判定 IsAbleToHandAsCost
	local isExtra = c:IsType(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
	return c:IsAbleToHandAsCost() or (isExtra and c:IsAbleToExtraAsCost())
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local dt=Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)
	local ct=math.max(0,2-dt)
	-- 注意这里改为了 REASON_COST
	local rg=Duel.GetReleaseGroup(tp,false,REASON_COST)
	local bg=Duel.GetMatchingGroup(s.thfilter,tp,0,LOCATION_ONFIELD,nil)
	
	if #bg<1 then return false end
	
	if ct>0 then
		return rg:CheckSubGroup(aux.mzctcheckrel,ct,ct,tp,REASON_COST)
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local dt=Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)
	local ct=math.max(0,2-dt)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_COST)
	local bg=Duel.GetMatchingGroup(s.thfilter,tp,0,LOCATION_ONFIELD,nil)
	
	local sg1=Group.CreateGroup()
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		sg1=rg:SelectSubGroup(tp,aux.mzctcheckrel,true,ct,ct,tp,REASON_COST)
		if not sg1 then return false end
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg2=bg:Select(tp,1,2,nil)
	if not sg2 then return false end
	
	for tc in aux.Next(sg1) do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	
	sg1:Merge(sg2)
	sg1:KeepAlive()
	e:SetLabelObject(sg1)
	return true
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	local rg=Group.CreateGroup()
	local bg=Group.CreateGroup()
	
	for tc in aux.Next(sg) do
		if tc:GetFlagEffect(id)>0 then
			rg:AddCard(tc)
		else
			bg:AddCard(tc)
		end
	end
	-- 执行代价，必须使用 REASON_COST
	if #rg>0 then
		Duel.Release(rg,REASON_COST)
	end
	if #bg>0 then
		-- 引擎中 SendtoHand 指令搭配 REASON_COST 时，会自动将包含的额外卡组怪兽合规地弹回额外卡组
		Duel.SendtoHand(bg,nil,REASON_COST)
	end
	sg:DeleteGroup()
end

-- ==================== 效果①（无效召唤并回到卡组） ====================
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep and Duel.GetCurrentChain()==0
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,#eg,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

-- ==================== 效果②（限制与加成） ====================
function s.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function s.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,LOCATION_HAND)*100
end