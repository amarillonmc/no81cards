--破晓哨兵 莱拉
local s, id = GetID()
s.dawn_set = 0x696d  -- 破晓字段代码

function s.initial_effect(c)
	-- 效果①：特殊召唤时控制权回归并无效对方场上1张卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)

	-- 效果②：主要阶段从卡组检索「破晓」怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 效果①的目标：需要对方场上（相对于原本持有者）有表侧表示的卡可以无效
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local owner=e:GetHandler():GetOwner()
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsFaceup,owner,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-owner,LOCATION_ONFIELD)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
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
		-- 如果无法转移，控制权不变，但后续操作仍由原本持有者执行
	end
	-- 原本持有者选择对方场上1张表侧表示的卡无效化
	local opp=1-owner
	local g=Duel.GetMatchingGroup(Card.IsFaceup,owner,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,owner,HINTMSG_DISABLE)
		local tc=g:Select(owner,1,1,nil):GetFirst()
		if tc then
			-- 无效化效果
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end

-- 效果②：检索「破晓」怪兽
function s.thfilter(c)
	return c:IsSetCard(s.dawn_set) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end