--辉色追忆 破碎之光
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
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)

	--②：作为同调素材，赋予允许速攻手卡发动的光环
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(s.mtcon)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
end

-- === 效果①：条件与目标 ===
function s.setfilter(c)
	return aux.IsCodeListed(c,6100146) and c:IsSSetable()
end
function s.thfilter(c,ec)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c~=ec
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1 = Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil)
	local b2 = Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, c, c)
	
	if chk==0 then return b1 or b2 end 
	
	local op=0
	if b1 and b2 then
		op = Duel.SelectOption(tp, aux.Stringid(id,1), aux.Stringid(id,2))
	elseif b1 then
		Duel.SelectOption(tp, aux.Stringid(id,1))
		op = 0
	else
		Duel.SelectOption(tp, aux.Stringid(id,2))
		op = 1
	end
	e:SetLabel(op)
	
	if op==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
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
		-- ● 选项1：卡组盖放
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		local tc=g:GetFirst()
		
		if tc and Duel.SSet(tp, tc)>0 then
			-- 赋予在盖放回合发动的特权
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCondition(s.actcon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			
			local e2=e1:Clone()
			e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			tc:RegisterEffect(e2,true)

			-- 埋下窃听器：在当回合追踪发动的行为，并在发动时索要“展示代价”
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_CHAINING)
			e3:SetLabelObject(tc)
			e3:SetOperation(s.actcostop)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3, tp)
		end
		
	elseif op==1 then
		-- ● 选项2：这张卡和场上另外1张魔陷回手
		if not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,c)
		Duel.HintSelection(g)
		if #g>0 then
			g:AddCard(c)
			c:CancelToGrave() -- 防止速攻魔法在结算后进入墓地
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

-- 附加特权发动的前提要求
function s.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_SPELL)
end

-- 监听特权的使用，收取额外代价
function s.actcostop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if ep==tp and re:GetHandler()==tc and tc:IsStatus(STATUS_SET_TURN) then
		-- 如果本来就是常态魔法不需要代价，仅拦截由于特权而发动的速攻与陷阱卡
		if tc:IsType(TYPE_TRAP) or tc:IsType(TYPE_QUICKPLAY) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
			local g=Duel.SelectMatchingCard(tp, Card.IsType, tp, LOCATION_HAND, 0, 1, 1, nil, TYPE_SPELL)
			if #g>0 then
				Duel.ConfirmCards(1-tp, g)
				Duel.ShuffleHand(tp)
			end
		end
		e:Reset() -- 该监听用完即卸载
	end
end

-- === 效果②：同调素材附着光环 ===
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if rc then
		-- 允许手发速攻魔法
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.qptg)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2)
		
		-- UI客户端光环提示
		rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end

function s.qptg(e,c)
	-- 判定是否具有对愚者的记述
	return aux.IsCodeListed(c,6100146)
end