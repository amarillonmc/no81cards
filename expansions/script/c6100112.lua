--映现小队兵装β-尤拉莉雅
local s, id = GetID()

function s.initial_effect(c)
	-- 连接怪兽定义
	aux.AddLinkProcedure(c,nil,2,3,s.lcheck)
	c:EnableReviveLimit()
	
	-- 效果①：连接召唤成功时处理
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.lkcon)
	e1:SetTarget(s.lktg)
	e1:SetOperation(s.lkop)
	c:RegisterEffect(e1)
	
	-- 效果②：从除外区回收后处理
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id)
	e2:SetCondition(s.excon)
	e2:SetTarget(s.extg)
	e2:SetOperation(s.exop)
	c:RegisterEffect(e2)
	
	-- 效果③：怪兽效果发动时除外
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, id+1)
	e3:SetCondition(s.discon)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetPreviousLocation()==LOCATION_REMOVED then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
-- 连接素材条件：包含"小队"怪兽

function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x61c)
end
-- 效果①：连接召唤成功条件
function s.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function s.lkfilter(c)
	return c:IsSetCard(0xa61c) and c:IsAbleToRemove()
end

-- 效果①：目标设置
function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end

-- 效果①：操作处理
function s.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 从卡组除外1张映现小队卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.lkfilter,tp,LOCATION_DECK,0,1,1,nil,0xa61c)
	if #g>0 then 
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	
	-- 对方场上有怪兽时可以回收1张除外的小队卡
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_REMOVED,0,1,1,nil,0x61c)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	end
end

-- 效果②：条件检查 - 本回合有从除外区回收卡
function s.excon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end

-- 效果②：目标设置
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,nil,0xa61c) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_HAND)
end

function s.exfilter(c)
	return c:IsSetCard(0xa61c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0xa61c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 效果②：操作处理
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 选择手卡任意数量映现小队怪兽除外
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_HAND,0,1,99,nil)
	if #g==0 then return end
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	
	-- 除外3张以上可以特召1只除外的映现小队怪兽
	if ct>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

-- 效果③：条件检查 - 怪兽效果发动时
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_ONFIELD)
end

-- 效果③：目标设置
function s.disfilter(c)
	return c:IsSetCard(0xa61c) and c:IsAbleToDeck()
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_REMOVED,0,1,nil)
		and rc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,0,0)
end

-- 效果③：操作处理
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	-- 选择除外的1只映现小队怪兽返回卡组
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if #g==0 then return end
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local ct=Duel.GetCurrentPhase()<=PHASE_STANDBY and 2 or 1
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,ct)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
		e2:SetLabelObject(tc)
		e2:SetCountLimit(1)
		e2:SetCondition(s.retcon)
		e2:SetOperation(s.retop)
		e2:SetLabel(Duel.GetTurnCount())
		Duel.RegisterEffect(e2,tp)
	end
end

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(id)~=0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end