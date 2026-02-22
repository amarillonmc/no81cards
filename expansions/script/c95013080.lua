--破晓助手 布兰
local s, id = GetID()
s.dawn_set = 0x696d  -- 破晓字段代码

function s.initial_effect(c)
	-- 效果①：特殊召唤时控制权回归并选对方场上怪兽回手
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.returntg)
	e1:SetOperation(s.returnop)
	c:RegisterEffect(e1)

	-- 效果②：主要阶段从墓地回收「破晓」魔法卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 效果①的目标：需要检查对方场上（相对于原本持有者）是否有怪兽可回手
function s.returntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local owner=e:GetHandler():GetOwner()
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToHand,owner,0,LOCATION_MZONE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-owner,LOCATION_MZONE)
end

function s.returnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local owner=c:GetOwner()
	local player=c:GetControler()
	-- 如果当前控制者不是原本持有者，尝试将控制权回归
	if owner~=player then
		-- 检查原本持有者场上是否有空位
		if Duel.GetLocationCount(owner,LOCATION_MZONE)>0 then
			Duel.GetControl(c,owner)
		end
		-- 如果无法转移，控制权不变，但后续仍由原本持有者操作
	end
	-- 原本持有者选择对方场上1只怪兽回到手卡
	local opp=1-owner
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,owner,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,owner,HINTMSG_RTOHAND)
		local sg=g:Select(owner,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end

-- 效果②：回收墓地「破晓」魔法卡
function s.thfilter(c)
	return c:IsSetCard(s.dawn_set) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end