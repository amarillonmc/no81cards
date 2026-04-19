--辉色追忆 黄晶之记忆
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

	--②：作为同调素材离场
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4)) -- "攻守变化"
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.mtcon)
	e2:SetTarget(s.mttg)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
end

-- === 效果①：条件与目标 ===
function s.thfilter(c,ec)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c~=ec
end

function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	-- 计算卡组足以支撑几次翻卡 (每破坏1张需翻3张)
	local max_des = math.floor(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)/3)
	if max_des > 2 then max_des = 2 end
	
	-- 判定选项1与选项2的合法性
	local b1 = Duel.GetFlagEffect(tp,id)==0 and max_des > 0 
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)
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
	else
		Duel.SelectOption(tp,aux.Stringid(id,2))
		op=1
	end
	e:SetLabel(op)
	
	if op==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	elseif op==1 then
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_ONFIELD)
	end
end

-- 愚者记述检测过滤器
function s.excfilter(c)
	return aux.IsCodeListed(c,6100146) and c:IsAbleToHand()
end

-- === 效果①：处理分歧 ===
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	
	if op==0 then
		-- ● 选项1：破坏并翻开提取
		local max_des = math.floor(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)/3)
		if max_des > 3 then max_des = 3 end
		if max_des == 0 then return end
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,max_des,c)
		Duel.HintSelection(g)
		if #g>0 then
			local ct = Duel.Destroy(g,REASON_EFFECT)
			if ct>0 then
				local flip_ct = ct * 3
				-- 确保此时卡组的剩余数量足够
				if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) >= flip_ct then
					Duel.BreakEffect()
					Duel.ConfirmDecktop(tp,flip_ct)
					local dg=Duel.GetDecktopGroup(tp,flip_ct)
					local thg=dg:Filter(s.excfilter,nil)
					
					-- 询问是否检索
					if #thg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
						local sg=thg:SelectSubGroup(tp,aux.dncheck,false,1,99)
						Duel.DisableShuffleCheck()
						Duel.SendtoHand(sg,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,sg)
						Duel.ShuffleHand(tp)
						dg:Sub(sg) -- 移出被拿走的卡
					end
					
					-- 剩下的卡排序回到卡组下面
					if #dg>1 then
					Duel.SortDecktop(tp,tp,#dg)
						for i=1,#dg do
						local dg=Duel.GetDecktopGroup(tp,1)
						Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
						end
					end
				end
			end
		end
		
	elseif op==1 then
		-- ● 选项2：这张卡和另外1张魔陷回手
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

-- === 效果②：离场攻守结算 ===
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,TYPE_SPELL)>0 end
end

function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,TYPE_SPELL)
	local val = ct * 300
	if val==0 then return end
	
	local tg1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tg2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(val)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(-val)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end