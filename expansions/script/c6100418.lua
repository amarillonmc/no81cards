--辉色追忆 八番目的迷宫
local s,id,o=GetID()
function s.initial_effect(c)
	--必须记述的卡号声明
	aux.AddCodeList(c,6100146)

	--发动后继续留在场上
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e0)

	--①：卡片的发动 (二选一)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)

	--②：作为同调素材离场，改星
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3)) -- "变更等级"
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.mtcon)
	e2:SetTarget(s.mttg)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
end

-- === 效果①：条件与目标 ===
function s.rvfilter(c)
	return (c:IsCode(6100146) or (c:IsType(TYPE_SPELL) and aux.IsCodeListed(c,6100146))) and not c:IsPublic()
end
function s.thfilter(c,ec)
	-- 场上其他的魔法·陷阱卡
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c~=ec
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1 = Duel.GetFlagEffect(tp,id)==0 and Duel.IsPlayerCanDraw(tp,1) 
		and Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
	local b2 = Duel.GetFlagEffect(tp,id+1)==0 
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c)
		
	if chk==0 then return b1 or b2 end 
	
	local op=0
	if b1 and b2 then
		local sel=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		op=sel
	elseif b1 then
		Duel.SelectOption(tp,aux.Stringid(id,1))
		op=0
	elseif b2 then
		Duel.SelectOption(tp,aux.Stringid(id,2))
		op=1
	end
	e:SetLabel(op)
	
	if op==0 then
	e:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif op==1 then
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_ONFIELD)
	end
end

-- === 效果①：处理分歧 ===
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	
	if op==0 then
		-- ● 选项1：展示、抽卡、挂载替换监听
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
			if Duel.Draw(tp,1,REASON_EFFECT)>0 then
				-- 注册代替效果追踪器
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAINING)
				e1:SetOperation(s.repop)
				Duel.RegisterEffect(e1,tp)
			end
		end
		
	elseif op==1 then
		-- ● 选项2：这张卡和另外1张魔陷回手 (回收资源)
		if not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,c)
		Duel.HintSelection(g)
		if #g>0 then
			g:AddCard(c)
			c:CancelToGrave() -- 防止速攻魔法在结算后自动进墓地
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

-- 选项1的覆盖效果核心
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	if not re:IsActiveType(TYPE_SPELL) then return end
	if not aux.IsCodeListed(re:GetHandler(), 6100146) then return end
	
	-- 文本为“下次...的场合”，因此只要抓到符合条件的就必须注销这个追踪器
	e:Reset()
	
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then -- "是否代替原本效果，选1张卡回手？"
			Duel.ChangeChainOperation(ev,s.rep_ch_op)
		end
	end
end
function s.rep_ch_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,c)
	Duel.HintSelection(g)
	if #g>0 then
		g:AddCard(c)
		c:CancelToGrave() -- 防止速攻魔法在结算后自动进墓地
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

-- === 效果②：同调素材离场，改星 ===
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsLevelAbove(1) end
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsLevelAbove(1) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsLevelAbove(1) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLevelAbove(1) then
		local b1 = true
		local b2 = tc:GetLevel() > 1
		local op = 0
		
		if b1 and b2 then
			op = Duel.SelectOption(tp,aux.Stringid(id,5),aux.Stringid(id,6))
		elseif b1 then
			Duel.SelectOption(tp,aux.Stringid(id,5))
			op = 0
		else
			return
		end
		
		local max_dec = math.min(3, tc:GetLevel() - 1)
		local lv = 0
		if op == 0 then
			lv = Duel.AnnounceNumber(tp, 1, 2, 3)
		else
			if max_dec == 1 then
				lv = Duel.AnnounceNumber(tp, 1)
			elseif max_dec == 2 then
				lv = Duel.AnnounceNumber(tp, 1, 2)
			else
				lv = Duel.AnnounceNumber(tp, 1, 2, 3)
			end
			lv = -lv
		end
		
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end