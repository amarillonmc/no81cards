local s,id=GetID()

function s.initial_effect(c)
	-- 超量召唤规则：6星「特诺奇」怪兽×2
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5328),6,2)

	-- ①：超量召唤成功的场合，从卡组·墓地放置「特诺奇的羽蛇神庙」
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tfcon)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)

	-- ②：二速拔除任意数量素材，选自己墓地本家卡或对方场上卡弹回手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+10000) -- 这个卡名的②效果1回合只能使用1次
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- ==================== ①效果：放置场地魔法 ====================
function s.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.tffilter(c)
	-- 寻找代码为 33201900 的场地魔法「特诺奇的羽蛇神庙」且不处于被规则禁止的状态
	return c:IsCode(33201900) and not c:IsForbidden()
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)	
	-- 加入王家谷判定，防止顶着王家谷试图从墓地拉场地
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		-- 判定当前场地是否已被占据，如果被占据则通过规则将其送去墓地以腾出位置
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		-- 直接在场地区域表侧表示放置，这不会被当做“卡片的发动”
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end

-- ==================== ②效果：动态拔素材与非取对象弹卡 ====================
function s.thfilter(c,tp)
	-- 有效目标A：自己墓地的「特诺奇」卡
	local b1 = c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x5328) and c:IsAbleToHand()
	-- 有效目标B：对方场上的卡
	local b2 = c:IsControler(1-tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsAbleToHand()
	return b1 or b2
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 计算当前场上/墓地可以被弹回的合法目标数量
	local rt=Duel.GetMatchingGroupCount(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,LOCATION_ONFIELD,nil,tp)
	-- 获取这张卡当前的素材数量
	local ct=c:GetOverlayCount()
	
	if chk==0 then return ct>0 and rt>0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	
	-- 取两者之间的最小值作为上限（防止有3个素材但场上只有2个合法目标导致空发的Bug）
	local max=math.min(ct,rt)
	
	-- 获取取除前的素材数
	local ct1=c:GetOverlayCount()
	-- 系统会弹窗让玩家选择要取除多少个素材（从1到max）
	c:RemoveOverlayCard(tp,1,max,REASON_COST)
	-- 获取取除后的素材数，计算实际取除的差值
	local ct2=c:GetOverlayCount()
	
	-- 将实际取除的数量记录在 Label 中，供后续操作使用
	e:SetLabel(ct1-ct2)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end -- Cost阶段已经做过严谨的预判，直接放行
	-- 由于是不取对象效果，只需要声明将要发生的类别
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	-- 提取刚才实际拔除的素材数量
	local max_ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	
	-- 玩家可以“选” 1 到 max_ct 张卡弹回
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,LOCATION_ONFIELD,1,max_ct,nil,tp)
	if #g>0 then
		Duel.HintSelection(g) -- 在界面上给予对方高亮提示（被你选中的卡闪烁）
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end