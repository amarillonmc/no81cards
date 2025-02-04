-- 深溟涡动 (60000219)
local s,id=GetID()

function s.initial_effect(c)
	-- 添加卡名记述
	aux.AddCodeList(c,60000211)
	
	-- 效果1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	
	-- 效果2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.thcost)
	e2:SetCondition(s.thcon) -- 添加发动条件
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 效果1目标
function s.filter(c)
	return c:IsFaceup() and c:IsCode(60000211)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end

-- 效果1操作
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=tp
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_REMOVED,0,nil)
	if ct>0 then
		local dr=Duel.Draw(p,ct,REASON_EFFECT)
		if dr>0 and Duel.GetLP(p)<4000 then
			Duel.SetLP(p,4000)
		end
	end
end

-- 效果2条件(不能在送墓回合发动)
function s.thcon(e)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end

-- 效果2cost
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end

-- 效果2目标
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

-- 效果2操作
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end