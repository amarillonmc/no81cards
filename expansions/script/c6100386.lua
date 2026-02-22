-- 创生之苍翼 艾因
-- Genesis Azure Wing Ein
local s,id,o=GetID()
function s.initial_effect(c)
	-- 同调召唤
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)

	--①：守备表示攻击
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--②：无效并破坏 (除外同类卡)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.discon)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)

	--③：结束阶段回收抽卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end

-- === 效果② ===
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
		and Duel.IsChainNegatable(ev)
end

-- 获取效果对应的种类Flag ID和类型Mask
function s.get_type_info(re)
	local rc=re:GetHandler()
	local active_type=re:GetActiveType()
	
	if (active_type & TYPE_MONSTER) ~= 0 then
		return id+100, TYPE_MONSTER
	elseif (active_type & TYPE_SPELL) ~= 0 then
		return id+200, TYPE_SPELL
	elseif (active_type & TYPE_TRAP) ~= 0 then
		return id+300, TYPE_TRAP
	end
	return 0, 0
end

function s.rmfilter(c,ty)
	return c:IsType(ty) and c:IsAbleToRemoveAsCost()
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end

function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local flag_id, type_mask = s.get_type_info(re)
	local c=e:GetHandler()
	
	-- 检查：必须能识别出种类，且该种类尚未被此卡除外过，且有对应的卡可除外
	if chk==0 then 
		return flag_id~=0 
		and c:GetFlagEffect(flag_id)==0 
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,type_mask)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,type_mask)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		local hint_desc=0
		local hint_flag_id=0
		if type_mask == TYPE_MONSTER then 
			hint_desc = aux.Stringid(id,2) 
			hint_flag_id = id + 10 
		end
		if type_mask == TYPE_SPELL then 
			hint_desc = aux.Stringid(id,3) 
			hint_flag_id = id + 20 
		end
		if type_mask == TYPE_TRAP then 
			hint_desc = aux.Stringid(id,4) 
			hint_flag_id = id + 30 
		end
		c:RegisterFlagEffect(flag_id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,hint_desc)
	end
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end

-- === 效果③ ===
function s.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end