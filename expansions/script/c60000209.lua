-- 显龙气 (60000209)
local s,id=GetID()

function s.initial_effect(c)
	aux.AddCodeList(c,60000196)  -- 蒲牢·华钟
	
	-- 效果1：回复+可选破坏
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	
	-- 效果2：墓地除外效果
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end

-- 蒲牢存在检查
function s.pulao_filter(c)
	return c:IsCode(60000196) and c:IsFaceup()
end

function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end

function s.op1(e,tp,eg,ep,ev,re,r,rp)
	-- 先处理回复
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)>0 then
		-- 在效果处理时动态检查所有条件
		local check_pulao = Duel.IsExistingMatchingCard(s.pulao_filter,tp,LOCATION_MZONE,0,1,nil)
		local check_counter = Duel.IsCanRemoveCounter(tp,1,0,0x62b,1,REASON_EFFECT)
		local enemy_monsters = Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		
		-- 满足全部条件时询问
		if check_pulao and check_counter and #enemy_monsters>0 then
			local destroy_question = aux.Stringid(id,0)
			if Duel.SelectYesNo(tp,destroy_question) then
				if Duel.RemoveCounter(tp,1,0,0x62b,1,REASON_EFFECT) then
					Duel.Destroy(enemy_monsters,REASON_EFFECT)
				end
			end
		end
	end
end

-- 效果2的cost
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

-- 效果2操作
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end