-- 特诺奇的猎手
local s,id=GetID()

function s.initial_effect(c)
	-- 超量召唤规则：4星「特诺奇」怪兽×2
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5328),4,2)

	-- ①：同纵列的对方卡的效果无效化
	-- 1.1 无效卡片效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_ONFIELD) -- 影响对方全场
	e1:SetTarget(s.distg)
	c:RegisterEffect(e1)
	-- 1.2 无效已经在场上发动的效果（包括起动、诱发等）
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e2)
	-- 1.3 顺带无效陷阱怪兽的怪兽属性
	local e3=e1:Clone()
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	c:RegisterEffect(e3)

	-- ②：在场上·墓地存在的场合，将自身塞给自己的超量怪兽作为素材
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetCountLimit(1,id) -- 这个卡名的②效果1回合只能使用1次
	e4:SetTarget(s.mattg)
	e4:SetOperation(s.matop)
	c:RegisterEffect(e4)

	-- ③：因战斗·效果以外送去墓地的场合，破坏对方1张魔陷
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,id+10000) -- 这个卡名的③效果1回合只能使用1次
	e5:SetCondition(s.descon)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
end

-- ==================== ①效果：同纵列无效 ====================
function s.distg(e,c)
	-- 获取这张卡所在的纵列，并判断对方的卡(c)是否在这个纵列中
	return e:GetHandler():GetColumnGroup():IsContains(c)
end

-- ==================== ②效果：自身变素材 ====================
function s.matfilter(c,e,tp)
	-- 对象合法性：自己场上表侧表示的超量怪兽，且不能是发动效果的这张卡自己
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c~=e:GetHandler()
end
function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.matfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.matfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.matfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	-- 虽然是把怪兽移动到超量素材区，但这不属于改变控制权也不属于送墓，不需写入 Category
end
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	-- 必须确保目标怪兽还在场上，且这张卡还在发动效果的区域（场上或墓地）
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local sg=c:GetOverlayGroup()
		if sg then Duel.SendtoGrave(sg,REASON_RULE) end
		Duel.Overlay(tc,c)
	end
end

-- ==================== ③效果：炸后场 ====================
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 必须是因战斗·效果以外送去墓地（例如：被拔除素材、连接同调素材、送墓Cost等）
	return not c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_EFFECT)
end
function s.desfilter(c)
	-- 目标必须是魔法·陷阱卡（不论表侧还是里侧）
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and s.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end