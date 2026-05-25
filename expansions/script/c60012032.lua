-- 严酷的奥夜花
--Duel.LoadScript("c.lua")
-- 严酷的奥夜花
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 添加奥夜花系列的卡名记述，方便其他卡识别
	aux.AddCodeList(c,60012030)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	-- 永续魔法的效果，1回合1次
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end

-- 触发条件：自己的手卡是3张以上
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=3
end

-- 检索的怪兽的过滤
function cm.filter_th(c,lv)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==lv and c:IsAbleToHand()
end

-- 目标函数
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter_th,tp,LOCATION_DECK,0,1,nil,0) end
end

-- 效果执行
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 把手卡给对方确认
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,g)
	-- 找手卡中等级相同的怪兽的等级
	local tg=g:Filter(Card.IsMonster,nil)
	local lvs={}
	for tc in aux.Next(tg) do
		lvs[tc:GetLevel()]=(lvs[tc:GetLevel()] or 0)+1
	end
	local lv=0
	for k,v in pairs(lvs) do
		if v>=2 then
			lv=k
			break
		end
	end
	if lv==0 then return end
	-- 从卡组找相同等级的怪兽加入手卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,cm.filter_th,tp,LOCATION_DECK,0,1,1,nil,lv)
	if #sg==0 then return end
	local tc=sg:GetFirst()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	-- 限制：这个回合不能召唤/特殊召唤，效果也不能发动
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTarget(cm.limit_tg)
	e1:SetTargetRange(0X3ff,0)
	e1:SetLabel(tc:GetCode(),lv)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	Duel.RegisterEffect(e3,tp)
end

-- 限制的目标：检索的怪兽，以及同名等级的怪兽
function cm.limit_tg(e,c)
	local code,lv=e:GetLabel()
	return c:GetCode()==code or (c:IsType(TYPE_MONSTER) and c:GetLevel()==lv)
end
