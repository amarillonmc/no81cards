-- 永续魔法卡：交换契约
local s,id=GetID()
function s.initial_effect(c)
	-- 效果①：双方抽卡+交换手卡
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	
	-- 效果②：除外时转移控制权回收
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
end

-- 效果①处理函数
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p1=Duel.Draw(tp,1,REASON_EFFECT)
	local p2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if d1==0 or d2==0 then return end
		-- 对方选择手卡给己方
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #g1>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOHAND)
			local sg1=g1:Select(1-tp,1,1,nil)
			Duel.SendtoHand(sg1,tp,REASON_EFFECT)
		end
		-- 己方选择手卡给对方
		local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if #g2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.SendtoHand(sg2,1-tp,REASON_EFFECT)
		end
end

-- 效果②处理函数
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.GetControl(tc,1-tp)~=0 and c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
