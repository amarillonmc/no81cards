local s, id = GetID()

function s.initial_effect(c)
	-- 陷阱卡发动条件
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 发动条件：对方怪兽攻击宣言
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end

-- 目标处理：选择额外卡组1只怪兽
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end

-- 效果处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 从额外卡组除外1只怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g==0 then return end
	local ec=g:GetFirst()
	if Duel.Remove(ec,POS_FACEUP,REASON_EFFECT)==0 then return end
	
	-- 获取攻击怪兽与被除外怪兽的攻击力
	local ac=Duel.GetAttacker()
	local sum=ec:GetAttack()+ac:GetAttack()
		
	if (sum%7)== 0 then
		-- 对方场上/墓地/手卡全部除外
		local rg=Group.CreateGroup()
		
		-- 场上
		local fg=Duel.GetFieldGroup(1-tp,LOCATION_ONFIELD,0)
		rg:Merge(fg)
		
		-- 墓地
		local gg=Duel.GetFieldGroup(1-tp,LOCATION_GRAVE,0)
		rg:Merge(gg)
			  
		
		if #rg>0 then
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end