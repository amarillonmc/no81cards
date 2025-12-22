--展现于破碎世界之巅的辩护
local s,id,o=GetID()
function s.initial_effect(c)
	--①：加防 + 条件送墓
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--②：复制墓地陷阱效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.cpcost)
	e2:SetTarget(s.cptg)
	e2:SetOperation(s.cpop)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.filter(c)
	return c:IsSetCard(0x616) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsFaceup()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	
	-- 检查连锁情况，记录上一连锁的效果
	local chain_len=Duel.GetCurrentChain()
	if chain_len>1 then
		local p,loc,eff=Duel.GetChainInfo(chain_len-1,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_EFFECT)
		-- 连锁对方的手卡·场上的卡的效果
		if p==1-tp and ((loc==LOCATION_HAND) or (loc==LOCATION_ONFIELD)) then
			e:SetLabelObject(eff)
			e:SetLabel(1) -- 标记满足连锁条件
		else
			e:SetLabelObject(nil)
			e:SetLabel(0)
		end
	else
		e:SetLabelObject(nil)
		e:SetLabel(0)
	end
end

-- 计算“破碎世界”魔法卡种类
function s.countfilter(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_SPELL)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetMatchingGroup(s.countfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		-- 守备力上升1000
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		
		-- 检查追加效果
		-- 条件1: 种类4种以上
		-- 条件2: 连锁条件满足 (Label==1)
		if ct>=4 and e:GetLabel()==1 then
			local te=e:GetLabelObject()
			if te then
				local te_c=te:GetHandler()
				-- 把那张对方的卡送去墓地 (需检查该卡是否关联且在场/手卡/墓地等可被送墓区域)
				if te_c:IsRelateToEffect(te) then
					Duel.BreakEffect()
					Duel.SendtoGrave(te_c,REASON_EFFECT)
				end
			end
		end
	end
end

-- === 效果② ===
function s.cfilter(c)
	return c:IsSetCard(0x616) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function s.cpfilter(c)
	return c:IsSetCard(0x616) and c:GetType()==TYPE_TRAP
		and c:CheckActivateEffect(false,true,false)~=nil
end

function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,r,rp=g:GetFirst():CheckActivateEffect(false,true,true)
	
	-- 模拟目标卡的发动Target
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,r,rp,1) end
	
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0) -- 清除可能的残留Info
end

function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end