-- 特诺奇的（终端怪兽名称）
local s,id=GetID()

function s.initial_effect(c)
	-- 超量召唤规则：相同阶级的「特诺奇」超量怪兽×2
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.matfilter,s.xyzcheck,2,2)
	--material
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetTarget(s.mttg)
	e0:SetOperation(s.mtop)
	c:RegisterEffect(e0)

	-- ①：自己场上的「特诺奇」怪兽不会成为对方的效果对象
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5328))
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)

	-- ②：其他卡的效果发动时，拔除任意数量素材并触发对应效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.chcon)
	e2:SetCost(s.chcost)
	e2:SetTarget(s.chtg)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
end

function s.mtfilter(c,e)
	return c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(s.mtfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.mtfilter),tp,LOCATION_GRAVE,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end

-- ==================== 超量召唤条件验证 ====================
function s.matfilter(c,xyzc)
	-- 素材必须是表侧表示、超量怪兽，且带有「特诺奇」字段
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x5328)
end
function s.xyzcheck(g)
	-- 验证选出的素材群 (g) 中，阶级种类是否只有1种（即“相同阶级”）
	return g:GetClassCount(Card.GetRank)==1
end

-- ==================== ②效果：动态拔素材与连锁打断 ====================
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 前置检查：是否触发了“这回合不能发动”的自肃（FlagEffect id）
	if c:GetFlagEffect(id)>0 then return false end
	-- 必须是“其他卡”的效果发动
	return re:GetHandler()~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end

function s.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 预判各项选择是否合法（防止没有目标却强行拔素材空发）
	local b1 = c:GetOverlayCount()>=2 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_GRAVE,1,nil)
	local b2 = c:GetOverlayCount()>=3 and Duel.IsChainDisablable(ev)
	local b3 = c:GetOverlayCount()>=4 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0

	if chk==0 then return b1 or b2 or b3 end

	-- 动态构建弹窗选项表
	local ops={}
	local opval={}
	if b1 then table.insert(ops,aux.Stringid(id,1)); table.insert(opval,2) end -- 需在 cdb 添加 [1]: 取除2个素材
	if b2 then table.insert(ops,aux.Stringid(id,2)); table.insert(opval,3) end -- 需在 cdb 添加 [2]: 取除3个素材
	if b3 then table.insert(ops,aux.Stringid(id,3)); table.insert(opval,4) end -- 需在 cdb 添加 [3]: 取除4个素材

	-- 弹出窗口让玩家选择
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op+1]
	
	-- 将玩家实际选择的拔除数量记录在 Label 中
	e:SetLabel(sel)
	-- 执行拔除素材操作
	c:RemoveOverlayCard(tp,sel,sel,REASON_COST)
end

function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sel=e:GetLabel()
	-- 动态汇报 Category 给系统预判（方便应对对方的星尘龙等卡片）
	if sel==3 then
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	else
		e:SetCategory(0)
	end
end

function s.ovfilter(c)
	-- Token（衍生物）不能成为超量素材，必须排除
	return not c:IsType(TYPE_TOKEN)
end

function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	
	if sel==2 then
		-- 【选项A：2个素材】吸收对方墓地1张卡
		if not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_GRAVE,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Overlay(c,g)
		end
		
	elseif sel==3 then
		-- 【选项B：3个素材】无效并破坏
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
		
	elseif sel==4 then
		-- 【选项C：4个素材】吸收对方全场
		if not c:IsRelateToEffect(e) then return end
		-- 抓取对方场上所有非Token的卡片
		local g=Duel.GetMatchingGroup(s.ovfilter,tp,0,LOCATION_ONFIELD,nil)
		if #g>0 then
			Duel.Overlay(c,g)
		end
		-- 核心：为这张卡打上“这回合不能再把效果发动”的系统标记
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end