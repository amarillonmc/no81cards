--破晓勇者 洛鸿
local s, id = GetID()
s.dawn_set = 0x696d  -- 破晓字段代码

function s.initial_effect(c)
	-- 效果①：特殊召唤时发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.retcon)
	e1:SetTarget(s.rettg)
	e1:SetOperation(s.retop)
	c:RegisterEffect(e1)

	-- 效果②：从卡组送墓「破晓」怪兽并恢复LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.reccost)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end

-- 效果①：无条件触发
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end

function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- 不需要设置目标，操作中处理
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local owner=c:GetOwner()
	local player=c:GetControler()
	-- 尝试将控制权回归原本持有者
	if owner~=player then
		if Duel.GetControl(c,owner) then
			-- 控制权转移成功
		else
			-- 控制权转移失败，仍按原本持有者处理破坏
		end
	end
	-- 原本持有者选择对方场上1张卡破坏
	local opp=1-owner
	local g=Duel.GetMatchingGroup(aux.TRUE,owner,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,owner,HINTMSG_DESTROY)
		local sg=g:Select(owner,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

-- 效果②：代价（从卡组送墓1只「破晓」怪兽）
function s.cfilter(c)
	return c:IsSetCard(s.dawn_set) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and not c:IsCode(id)
end
function s.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetAttack())  -- 记录攻击力
	Duel.SendtoGrave(g,REASON_COST)
end

function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end

function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	if not atk then return end
	Duel.Recover(tp,atk,REASON_EFFECT)
end