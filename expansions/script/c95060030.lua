local s, id = GetID()

function s.initial_effect(c)
	-- 字段绑定 
	
	-- 效果①：手卡特召（无次数限制）
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)		 
	c:RegisterEffect(e1)
	
	-- 效果②：墓地除外无效效果（1回合1次）
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING) -- 响应成为效果对象
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id+1)
	e2:SetCondition(s.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end

--===== 效果①：手卡特召条件 =====--
function s.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x966) and c:IsType(TYPE_MONSTER)
end

function s.spcon(e, c)
	if c == nil then return true end
	local tp = c:GetControler()
	return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_MZONE, 0, 1, nil)
end

--===== 效果②：无效效果处理 =====--
-- 条件：自身在墓地且成为效果对象的是己方场上卡
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER + TYPE_SPELL + TYPE_TRAP) and tc:IsLocation(LOCATION_ONFIELD) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end

	
function s.negtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
end


function s.negop(e, tp, eg, ep, ev, re, r, rp)
	Duel.NegateActivation(ev) 
end