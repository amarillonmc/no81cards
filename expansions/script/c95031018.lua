-- 卡片效果：剑技回响（修改版）
local s, id = GetID()

function s.initial_effect(c)
	-- 魔法卡效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 定义剑技字段常量
s.sword_tech_setcode = 0x960

-- 目标设定
function s.thfilter(c)
	return c:IsSetCard(s.sword_tech_setcode) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2500)
	
	-- 检查是否有可回收的剑技卡
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	end
end

-- 效果处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	
	-- 回复3000基本分（必须处理）
	if Duel.Recover(p,d,REASON_EFFECT)>0 then
		-- 检查墓地或除外状态是否有剑技魔法卡
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		
		if #g>0 then
			Duel.BreakEffect()
			-- 让玩家选择是否回收剑技卡
			if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:Select(tp,1,1,nil)
				if #sg>0 then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)									
				end
			end
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetTargetRange(1,0)
					e1:SetTarget(s.distg)
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
		end
	end
end

-- 效果限制：不能发动场上怪兽的效果
function s.distg(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end