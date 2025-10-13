-- 永续陷阱卡：雷电结界
local s, id = GetID()

function s.initial_effect(c)
	-- 在自己场上只能有1张表侧表示存在
	c:SetUniqueOnField(1,0,id)
	
	-- 永续陷阱卡
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	-- 效果①：相同纵列的其他卡的效果无效化
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(s.distg)
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e3)
	
	-- 效果②：对方怪兽被破坏时给予伤害并可破坏卡片
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCondition(s.damcon)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end

-- 效果①：相同纵列判断
function s.distg(e,c)
	local tp=e:GetHandlerPlayer()
	local seq=c:GetSequence()
	local cseq=e:GetHandler():GetSequence()
	if c==e:GetHandler() then
	   return false
	end
	-- 魔法陷阱区域判断
	if c:IsLocation(LOCATION_SZONE) then
		-- 同一纵列的魔法陷阱卡
		return seq==cseq
	end
	
	-- 怪兽区域判断
	if c:IsLocation(LOCATION_MZONE) then
		-- 同一纵列的怪兽卡
		local loc_seq = c:GetSequence()
		if c:IsControler(tp) then
			-- 自己场上的怪兽
			if loc_seq<5 and cseq<5 then
				return loc_seq==cseq
			end
		else
			-- 对方场上的怪兽
			if loc_seq<5 and cseq<5 then
				return 4-loc_seq==cseq
			end
		end
	end
	
	return false
end
-- 雷电将军筛选器
function s.raidenfilter(c)
	return c:IsFaceup() and c:IsCode(95075030)
end
-- 效果②：条件判断（对方怪兽被破坏）
function s.cfilter(c,tp,e)
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_MZONE) and 
		   (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)) and
		   not (c:IsReason(REASON_EFFECT) and c:GetReasonEffect() and c:GetReasonEffect():GetHandler()==e:GetHandler())
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp,e)
end

-- 效果②：目标设定
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
-- 效果②：操作处理
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 给予200伤害
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	
	-- 检查是否有雷电将军
	local g=Duel.GetMatchingGroup(s.raidenfilter,tp,LOCATION_MZONE,0,nil)
	local pg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 and pg:GetCount()>0 then
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #dg>0 then
				Duel.BreakEffect()
				Duel.HintSelection(dg)
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end