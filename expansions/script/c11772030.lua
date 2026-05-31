local s,id=GetID()
function s.initial_effect(c)
	-- 记述卡名
	aux.AddCodeList(c,11772015)

	-- 自己场上有「11772015」存在的场合，这张卡在对方回合也能从手卡发动。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetCondition(s.handcon)
	c:RegisterEffect(e1)

	-- ①：自己从卡组抽1张并选1张手卡丢弃。那之后，手卡里没有有「11772015」卡名记述的卡的场合，自己的手卡全部丢弃。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end

-- 手卡发动条件过滤
function s.handfilter(c)
	return c:IsFaceup() and c:IsCode(11772015)
end
function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.handfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end

-- 发动时的不可连锁设定与目标确立
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	
	-- 对方不能对应这张卡的效果把卡的效果发动。
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(s.chlimit)
	end
end
function s.chlimit(e,ep,tp)
	return tp==ep
end

-- 记述卡名过滤
function s.checkfilter(c)
	return aux.IsCodeListed(c,11772015)
end

-- ① 效果逻辑处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 自己从卡组抽1张
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		-- 选1张手卡丢弃
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
			local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			-- 如果手卡还有剩余，系统自动进行隐式判定
			if #hg>0 then
				Duel.BreakEffect()
				-- 如果手卡里没有符合条件的卡，则触发全部丢弃惩罚
				-- 如果有，则静默通过，不需要展示
				if not hg:IsExists(s.checkfilter,1,nil) then
					Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
				end
			end
		end
	end
end