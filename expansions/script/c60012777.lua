-- 神之灵光一闪 凯尔肯
local cm,m,o=GetID()
-- 规则上这张卡的卡名也当作「灵光一闪衍生物」使用；用专属标记把它和别的同名卡区分开
cm.isKelken=true

function cm.initial_effect(c)
	-- 作为永续魔法发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 同一连锁1次
	c:RegisterEffect(e0)

	-- ①：自己把魔法·陷阱卡发动时，掷1次骰子，按数目适用
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(3,m)	-- 这个卡名的①1回合最多3次
	e1:SetCondition(cm.dicecon)
	e1:SetOperation(cm.diceop)
	c:RegisterEffect(e1)

	-- ②：自己的魔法与陷阱区域没有空位的场合，这张卡破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end

-- ①的condition：自己把魔法·陷阱卡发动
function cm.dicecon(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp or not re then return false end
	if re:GetHandler()==e:GetHandler() then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
-- ①的operation
function cm.diceop(e,tp,eg,ep,ev,re,r,rp)
	local dice=Duel.TossDice(tp,1)
	if dice<=2 then
		-- 1·2：丢弃1张手卡
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then return end
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	elseif dice>=4 and dice<=5 then
		-- 4·5：抽1张
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif dice==6 then
		-- 6：抽3张
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
-- ②的operation：满格自毁
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsLocation(LOCATION_SZONE) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
