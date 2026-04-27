--绽放的自我·艾米
local s,id,o=GetID()
function s.initial_effect(c)
	--同调召唤
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,s.mfilter1,s.mfilter2,nil,aux.NonTuner(nil),1,99)

	--①：同调召唤成功时，根据同调素材数量捞卡与抢额外
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	-- 素材检测黑科技
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)

	--②：魔法卡发动时，根据位置触发相应效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.efcon)
	e3:SetTarget(s.eftg)
	e3:SetOperation(s.efop)
	c:RegisterEffect(e3)
end

-- === 同调素材检测 ===
function s.mfilter1(c)
	return c:IsType(TYPE_SYNCHRO) and (c:IsType(TYPE_TUNER) or c:IsHasEffect(EFFECT_TUNER))
end

function s.mfilter2(c)
	return c:IsType(TYPE_TUNER) or c:IsHasEffect(EFFECT_TUNER)
end

function s.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(Card.IsType, nil, TYPE_SYNCHRO)
	e:GetLabelObject():SetLabel(ct)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct==0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,ct,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		
		local cg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		if #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
			Duel.BreakEffect()
			Duel.ConfirmCards(tp,cg)
			
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			-- 根据刚刚成功捞回手的卡片数量，夺取相应数量的额外卡组怪兽
			local sg=cg:Select(tp,1,#g,nil)
			if #sg>0 then
				Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
			end
		end
	end
end

-- === 效果②：魔法卡发动时反制 ===
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsActiveType(TYPE_SPELL) or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	
	-- 核心修复：检查发动源卡片身上是否带有“从手卡发动”的状态标记
	local is_from_hand = re:GetHandler():IsStatus(STATUS_ACT_FROM_HAND)
	
	local b1 = is_from_hand and Duel.GetFlagEffect(tp,id)==0
	local b2 = not is_from_hand and Duel.GetFlagEffect(tp,id+1)==0
	
	return b1 or b2
end

function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local is_from_hand = re:GetHandler():IsStatus(STATUS_ACT_FROM_HAND)
	local c=e:GetHandler()
	
	if chk==0 then
		if is_from_hand then
			-- 如果是从手卡发动，对方手卡必须有卡
			return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		else
			-- 如果是从场上（盖放状态）发动，对方场上必须有攻击表示怪兽
			return Duel.IsExistingMatchingCard(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil)
		end
	end
	
	-- 记录发动位置供 Operation 分歧使用
	e:SetLabel(is_from_hand and 1 or 0)
	
	if is_from_hand then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
	end
end

function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local is_from_hand = (e:GetLabel() == 1)
	local c=e:GetHandler()
	if is_from_hand then
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #hg>0 then
			Duel.ConfirmCards(tp,hg)
			local mg=hg:Filter(Card.IsType, nil, TYPE_MONSTER)
			if #mg>0 then
				-- 将选择权交给对方 (1-tp)
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
				local rg=mg:Select(1-tp,1,1,nil)
				local tc=rg:GetFirst()
				if tc and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)>0 then
					-- 设定结束阶段返回手卡
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetLabelObject(tc)
					e1:SetCountLimit(1)
					e1:SetOperation(s.retop)
					Duel.RegisterEffect(e1,tp)
				end
			end
			Duel.ShuffleHand(1-tp)
		end
		
	else
		-- ●场上：得到对方场上1只攻击表示怪兽的控制权 (不取对象)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.GetControl(g:GetFirst(),tp)
		end
	end
end

-- 里侧除外结束阶段回手
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end