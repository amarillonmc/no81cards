--倒悬之树 存在意义的憧憬
local m=43499010
local cm=_G["c"..m]

function cm.initial_effect(c)
	--超量召唤手续
	c:EnableReviveLimit()
	--常规超量：10星×3； 替换超量：符合条件的情况下重叠，重叠超量一回合1次
	aux.AddXyzProcedure(c,nil,10,3,cm.ovfilter,aux.Stringid(m,0),3,cm.xyzop)
	
	--全局监控：「倒悬之树」(0xfb1) 超量怪兽的效果是否发动
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING) --改为判定发动时点
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	
	--①：特殊召唤的场合发动，非本家怪兽卡全送墓
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	
	--②：自己·对方回合，对方场上1张卡弹回卡组
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.tdcost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	
	--③：场上非「倒悬之树」怪兽攻守下降1000
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.debufftg)
	e3:SetValue(-1000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	
	--③：场上非「倒悬之树」怪兽不能对应卡的效果的发动把效果发动
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetValue(cm.actval)
	c:RegisterEffect(e5)
end

--全局监控处理：检测效果发动
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	--只要发动的效果归属于本家超量怪兽，即记录标记
	if rc:IsSetCard(0xfb1) and rc:IsType(TYPE_XYZ) then
		Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
	end
end

--替换超量召唤的条件
function cm.ovfilter(c)
	local tp=c:GetControler()
	return c:IsFaceup() and c:IsSetCard(0xfb1) and c:IsType(TYPE_XYZ) 
		and Duel.GetFlagEffect(0,m)>0 
end
--替换超量召唤的执行（用于注册1回合1次的自肃）
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

--①效果Cost
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

--①效果目标过滤：场上的怪兽卡（包含放在魔陷区、灵摆区的怪兽卡）
function cm.tgfilter(c)
	--兼容点：使用 bit.band 与 GetOriginalType 兼容旧版 YGO 核心
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and not c:IsSetCard(0xfb1) and c:IsAbleToGrave()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--②效果Cost
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

--③效果目标过滤（降攻防）
function cm.debufftg(e,c)
	return not c:IsSetCard(0xfb1)
end

--③效果判断（不能连锁）
function cm.actval(e,re,rp)
	local c=re:GetHandler()
	--如果当前正处于连锁中（>0），则禁止场上的非本家怪兽响应发动效果
	return c:IsLocation(LOCATION_MZONE) and not c:IsSetCard(0xfb1) and Duel.GetCurrentChain()>0
end