-- 紧急遮蔽
local cm,m,o=GetID()

function cm.initial_effect(c)
	-- 作为反击陷阱发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m)	-- 卡文（效果外）：「这个卡名的卡的效果1回合只能使用1次」
	e1:SetCondition(cm.con)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end

-- 「失格狙击手 席琳娜」
function cm.cfilter(c)
	return c:IsCode(60013075) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
-- ①：那个发动无效并除外
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
