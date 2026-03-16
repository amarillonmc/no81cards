--特诺奇的仪祝使
local s,id=GetID()

function s.initial_effect(c)
	-- ①：1回合1次，送去手卡·场上1张卡，从手卡特殊召唤（规则特召，不入连锁）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	-- 文本限定“①的方法的特殊召唤1回合只能有1次”，必须用 EFFECT_COUNT_CODE_OATH
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- ②：起动效果，提升本家怪兽攻击力
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+10000) -- 这个卡名的②效果1回合只能使用1次
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	-- ②：因战斗·效果以外送墓时，全场效破抗性 + 视情况回收墓地
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+20000) -- 这个卡名的②效果1回合只能使用1次
	e3:SetCondition(s.gycon)
	e3:SetTarget(s.gytg)
	e3:SetOperation(s.gyop)
	c:RegisterEffect(e3)
	
	-- 【全局监听】：记录本回合双方发动怪兽效果的动作
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

-- ==================== 全局监听逻辑 ====================
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	-- 如果发动的是怪兽的效果，给发动效果的玩家（rp）打上一个标记
	if re:IsActiveType(TYPE_MONSTER) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end

-- ==================== ①效果：规则特召 ====================
function s.spcfilter(c,tp,ft)
	if not c:IsAbleToGraveAsCost() then return false end
	-- 如果怪兽区有空位，手卡和场上任意卡都能送墓
	if ft>0 then return true end
	-- 如果怪兽区满格子了，必须强迫玩家送墓自己主要怪兽区的怪兽来腾出1个空位
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and c:IsControler(tp)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	-- 寻找除了自己以外的，符合条件的卡
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp,ft)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	-- 让玩家选择Cost
	local g=Duel.SelectMatchingCard(tp,s.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp,ft)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end

-- ==================== ②效果：按素材数量加攻 ====================
function s.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5328)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetOverlayCount(tp,1,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ct=Duel.GetOverlayCount(tp,1,0)
		if ct>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end

-- ==================== ②效果：效破抗性 + 墓地回收 ====================
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 必须是因战斗·效果以外送去墓地
	return not c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_EFFECT)
end
function s.gythfilter(c)
	-- 从墓地回收「特诺奇的蛇神信徒」以外的「特诺奇」怪兽
	return c:IsSetCard(0x5328) and c:IsType(TYPE_MONSTER) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 这个效果的基础收益是给全场上Buff，所以发动条件默认成立（不需要墓地有对象就能发动）
	if chk==0 then return true end
	-- 判断此时对方是否已经发动过怪兽效果，以给系统预判可能发生的回收
	if Duel.GetFlagEffect(1-tp,id)>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 收益1：赋予自己场上的「特诺奇」怪兽不会被效果破坏的抗性
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5328))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
	-- 收益2：如果对方已经发动过怪兽效果，可以回收墓地
	-- 检查给对方(1-tp)打上的怪兽效果记录标记
	if Duel.GetFlagEffect(1-tp,id)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.gythfilter),tp,LOCATION_GRAVE,0,nil)
		-- 可选效果，需弹窗询问玩家
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then -- 务必在cdb加上 "[2] 是否从墓地把1只本家怪兽加入手卡？"
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end