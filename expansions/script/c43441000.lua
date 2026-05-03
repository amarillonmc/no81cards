--厨卡之力 夏露
local s,id=GetID()
function s.initial_effect(c)
	-- 连接召唤条件: 电子界族怪兽3只
	c:EnableReviveLimit()
	-- 修复召唤：使用最基础的过滤器，确保 3 只素材
	aux.AddLinkProcedure(c,s.mfilter,3,3)
	
	-- 自己对「厨卡之力 夏露」1回合只能有1次特殊召唤
	-- 这是官方处理额外卡组“一回合一次”的标准函数
	c:SetSPSummonOnce(id)

	-- ①：特殊召唤成功的场合，以自己场上1只电子界族连接怪兽为对象发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)

	-- ②：对方效果响应逻辑
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end

-- 素材过滤：电子界族
function s.mfilter(c)
	return c:IsRace(RACE_CYBERSE)
end

-- ① 装备逻辑
function s.eqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if not Duel.Equip(tp,tc,c) then return end
		-- 挂载装备限制效果（防止自动送墓）
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end

-- ② 效果逻辑：响应对方发动
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	-- 获取发动的卡片种类 (1怪兽, 2魔法, 4陷阱)
	local type_bit=bit.band(re:GetActiveType(),0x7)
	-- 同一回合、同一连锁中，相同种类的限制
	return Duel.GetFlagEffect(tp,id+type_bit)==0
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:GetEquipTarget()==c end
	if chk==0 then return Duel.IsExistingTarget(function(c,ec) return c:GetEquipTarget()==ec end,tp,LOCATION_SZONE,0,1,nil,c)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,function(c,ec) return c:GetEquipTarget()==ec end,tp,LOCATION_SZONE,0,1,1,nil,c)
	
	local type_bit=bit.band(re:GetActiveType(),0x7)
	e:SetLabel(type_bit) -- 传递当前应对的种类
	
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local type_bit=e:GetLabel()
	
	-- 记录本回合该种类已发动
	Duel.RegisterFlagEffect(tp,id+type_bit,RESET_PHASE+PHASE_END,0,1)

	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		if rg:GetCount()>0 then
			Duel.BreakEffect()
			if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
				-- 获得对应种类的免疫抗性
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetValue(s.immfilter)
				e1:SetLabel(type_bit) -- 将种类存入 Label
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e1)
			end
		end
	end
end
-- 抗性过滤器：检查对方效果种类
function s.immfilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and bit.band(te:GetActiveType(),e:GetLabel())~=0
end