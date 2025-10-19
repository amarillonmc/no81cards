-- 魔法卡：魂铸契约
local s, id = GetID()

function s.initial_effect(c)
	-- 卡名一回合只能发动一张
	
	-- 效果：支付500LP检索并可选盖放
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 定义魂铸意志字段
s.soul_setcode = 0x396c

-- 代价：支付500基本分
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end

-- 目标设定
function s.thfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.stfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.rlfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- 效果处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 从卡组把1只「魂铸意志」怪兽加入手卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	
	local tc=g:GetFirst()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		
		-- 可以选择是否解放场上1只「魂铸意志」怪兽
		local rlg=Duel.GetMatchingGroup(s.rlfilter,tp,LOCATION_MZONE,0,nil)
		local stg=Duel.GetMatchingGroup(s.stfilter,tp,LOCATION_DECK,0,nil)
		
		if #rlg>0 and #stg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			
			-- 解放场上1只「魂铸意志」怪兽
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rlc=rlg:Select(tp,1,1,nil)
			if #rlc==0 then return end
			
			if Duel.Release(rlc,REASON_EFFECT)~=0 then
				-- 从卡组把1张「魂铸意志」魔法·陷阱卡在自己场上盖放
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local stc=stg:Select(tp,1,1,nil)
				if #stc>0 then
					local sct=stc:GetFirst()
					Duel.SSet(tp,sct)
				 --   Duel.ConfirmCards(1-tp,sct)
					
					-- 如果是陷阱卡，可以在盖放的回合发动
					if sct:IsType(TYPE_TRAP) then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						--sct:RegisterEffect(e1)
					end
				end
			end
		end
	end
end