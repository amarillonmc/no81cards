--克林德
local s,id=GetID()
function s.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,17337540,s.matfilter,2,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	
	-- ①效果：确认并除外对方手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.rmcost1)
	e1:SetTarget(s.rmtg1)
	e1:SetOperation(s.rmop1)
	c:RegisterEffect(e1)
	
	-- ②效果：解放自身，对方选择除外手卡或受限制
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)  -- 只能在场上发动
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.releasecost)  -- 改为解放cost
	e2:SetTarget(s.handlocktg)
	e2:SetOperation(s.handlockop)
	c:RegisterEffect(e2)
	
	-- ③效果：结束阶段特殊召唤
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+2)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

-- 辅助函数
function s.matfilter(c)
	return c:IsFusionType(TYPE_MONSTER) and c:IsFusionSetCard(0x3f50)
end

function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function s.emtfilter(c)
	return c:IsSetCard(0x3f50) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

-- ①效果：cost处理
function s.rmcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.emtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.emtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

-- ①效果：目标确认
function s.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end

-- ①效果：操作执行
function s.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if #g==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end

-- ②效果：解放自身作为cost
function s.releasecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end

-- ②效果：目标确认
function s.handlocktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_HAND)
end

-- ②效果：操作执行
function s.handlockop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,1-tp,LOCATION_HAND,0,nil)
	local check=false
	if #g>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,1,1,nil)
		if #sg>0 then
			if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)==0 then
				check=true
			end
		end
	else 
		check=true
	end
	
	-- 注册特殊召唤标志
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_RELEASE) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
	
	-- 处理限制效果
	if check or #g<=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,4))  -- 使用新的字符串ID
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(0,1)
		e1:SetTarget(s.handlimit)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
	end
end

function s.handlimit(e,c)
	return c:IsLocation(LOCATION_HAND)
end

-- ③效果：特殊召唤条件
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)>0 and Duel.GetTurnPlayer()==tp
end

-- ③效果：特殊召唤目标
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

-- ③效果：特殊召唤操作
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end