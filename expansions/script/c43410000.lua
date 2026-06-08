--罗生之蝶 茧状
--罗生之蝶 茧状
local m=43410000
local cm=_G["c"..m]

function cm.initial_effect(c)
	--①：自己·对方的准备阶段，把这张卡解放才能发动。选卡组1只8星以下的「罗生之蝶」怪兽在自己场上特殊召唤。这个效果特殊召唤的怪兽回合结束时返回手卡。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)

	--②：自己抽卡阶段的抽卡前，以自己墓地的「罗生之蝶」怪兽为对象才能发动。作为这个回合进行通常抽卡的代替，作为对象的那只怪兽加入手卡。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	-- 设定为怪兽区和墓地均可发动，以最大程度贴合此类效果的战术需求
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE) 
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end

-- ==========================================
-- ①效果相关函数
-- ==========================================

-- ①的Cost：解放自身
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end

-- ①的过滤：8星以下的「罗生之蝶」(0xfb0) 怪兽
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xfb0) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- ①的发动目标检测
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 使用 GetMZoneCount 判断解放自身后是否还有格子
		return Duel.GetMZoneCount(tp,e:GetHandler())>0
			and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- ①的处理逻辑
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 召唤成功后，注册延迟效果：回合结束时弹回手卡
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		-- 给怪兽贴上标记，确保回手的确实是这只怪兽
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end

function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	-- 确认怪兽还在场上并且身上有我们的标记
	return tc:GetFlagEffect(m)>0
end

function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end

-- ==========================================
-- ②效果相关函数
-- ==========================================

-- ②的发动条件：必须是自己的抽卡阶段，且即将进行通常抽卡
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetDrawCount(tp)>0
end

-- ②的过滤：「罗生之蝶」(0xfb0) 怪兽
function cm.thfilter(c)
	return c:IsSetCard(0xfb0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

-- ②的发动目标检测
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

-- ②的处理逻辑
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	-- 注册规则效果：跳过本回合的通常抽卡
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	e1:SetValue(0)
	Duel.RegisterEffect(e1,tp)
	
	-- 将对象怪兽加入手卡
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end