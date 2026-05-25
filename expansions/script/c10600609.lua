-- 每一天的偶遇
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:SetUniqueOnField(1,0,id)  
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)

	-- ②：对方发动效果需要额外代价
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1) 
	e2:SetCost(s.costchk)
	e2:SetOperation(s.costop)
	c:RegisterEffect(e2)

	-- 用于记录本回合对方效果发动次数以及当前第几次的计数器（重置用）
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(s.resetcount)
	c:RegisterEffect(e3)

	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	
	--indes
	--[[local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)]]--
end
function s.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(Card.IsRace,1,c,c:GetRace())
			and not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end

-- 每回合准备阶段重置计数
function s.resetcount(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then
		e:GetHandler():ResetFlagEffect(0)
	end
end

-- 根据当前是第几次返回需要除外的位置
function s.get_remove_loc(ct)
	if ct==1 or ct==4 then return LOCATION_DECK
	elseif ct==2 or ct==5 then return LOCATION_GRAVE
	elseif ct==3 or ct==6 then return LOCATION_HAND
	else return nil end
end

-- costchk：检查对方是否能支付代价（即对应区域有卡可除外）
function s.costchk(e,te_or_c,tp)
	local c=e:GetHandler()
	local opponent=tp
	local current_count=c:GetFlagEffect(0)  -- 已经发动过的次数
	local next_ct=current_count+1
	if next_ct>3 then return true end 
	local loc=s.get_remove_loc(next_ct)
	if not loc then return true end
	if loc==LOCATION_DECK then
		return Duel.GetFieldGroupCount(opponent,LOCATION_DECK,0)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove, opponent, LOCATION_DECK, 0, 1, nil)
	elseif loc==LOCATION_GRAVE then
		return Duel.GetFieldGroupCount(opponent,LOCATION_GRAVE,0)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove, opponent, LOCATION_GRAVE, 0, 1, nil)
	elseif loc==LOCATION_HAND then
		return Duel.GetFieldGroupCount(opponent,LOCATION_HAND,0)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove, opponent, LOCATION_HAND, 0, 1, nil)
	end
	return false
end

-- costop：执行除外
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opponent=tp 
	local current_count=c:GetFlagEffect(0)
	local next_ct=current_count+1
	if next_ct>3 then return end
	local loc=s.get_remove_loc(next_ct)
	if not loc then return end
	local g=nil
	if loc==LOCATION_DECK then
		g=Duel.GetDecktopGroup(opponent,1)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_COST)
		end
	elseif loc==LOCATION_GRAVE then
		local tg=Duel.GetMatchingGroup(Card.IsAbleToRemove,opponent,LOCATION_GRAVE,0,nil)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,opponent,HINTMSG_REMOVE)
			g=tg:Select(opponent,1,1,nil)
			if #g>0 then
				Duel.Remove(g,POS_FACEUP,REASON_COST)
			end
		end
	elseif loc==LOCATION_HAND then
		local hg=Duel.GetFieldGroup(opponent,LOCATION_HAND,0)
		if hg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,opponent,HINTMSG_REMOVE)
			g=hg:Select(opponent,1,1,nil)
			if #g>0 then
				Duel.Remove(g,POS_FACEUP,REASON_COST)
			end
		end
	end
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end