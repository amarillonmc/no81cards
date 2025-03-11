-- 七仟陌支援
-- 卡片ID：
local s,id=GetID()
function s.initial_effect(c)
	-- 发动条件检查
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 发动条件：存在「七仟陌」
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
end

-- 超量怪兽过滤器
function s.xyzfilter(c)
	return c:IsFaceup() and c:IsCode(71000100) and c:IsType(TYPE_XYZ)
end

-- 效果处理（操作阶段选择）
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 选择超量怪兽
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_MZONE,0,nil)
	if #xyzg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local xyzc=xyzg:Select(tp,1,1,nil):GetFirst()
	if not xyzc then return end
	
	-- 选择场上的卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanBeOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,xyzc)   
	local tc=g:GetFirst()
	if tc and xyzc:IsType(TYPE_XYZ) then
		-- 作为超量素材附加
		tc:CancelToGrave()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(xyzc,Group.FromCards(tc))
		-- 获取原始代码
		--local code=tc:GetOriginalCodeRule()
		-- 效果无效化处理
		--local e1=Effect.CreateEffect(c)
		--e1:SetType(EFFECT_TYPE_FIELD)
		--e1:SetCode(EFFECT_DISABLE)
		--e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		--e1:SetTarget(s.distg)
		--e1:SetLabel(code)
		--e1:SetReset(RESET_PHASE+PHASE_END,1)
		--Duel.RegisterEffect(e1,tp)
		-- 连锁无效处理
		--local e2=Effect.CreateEffect(c)
		--e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		--e2:SetCode(EVENT_CHAIN_SOLVING)
		--e2:SetCondition(s.discon)
		--e2:SetOperation(s.disop)
		--e2:SetLabel(code)
		--e2:SetReset(RESET_PHASE+PHASE_END,1)
		--Duel.RegisterEffect(e2,tp)	  
	end
end

-- 无效化过滤器
function s.distg(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end

-- 连锁无效条件
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOriginalCodeRule(e:GetLabel())
end

-- 连锁无效操作
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end