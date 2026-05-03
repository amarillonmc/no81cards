--绚岚之贤光
--自定义速攻魔法
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
--绚岚 字段
function s.thfilter1(c)
	return c:IsSetCard(0x1d1) or c:IsCode(5318639)
end
--旋风 检索
function s.thfilter2(c)
	return c:IsCode(5318639) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 选项1判断：卡组至少有3张卡，且本回合未选过选项1
	local b1=Duel.GetFlagEffect(tp,id)==0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
	-- 选项2判断：卡组或墓地有「旋风」，且本回合未选过选项2
	local b2=Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	e:SetLabel(op)
	-- 注册选择的选项的每回合1次限制
	if op==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		-- 翻开卡组上面3张卡
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		local tg=g:Filter(s.thfilter1,nil)
		if #tg>0 then
			Duel.DisableShuffleCheck()
			-- 过滤出能加入手卡的卡
			local tc=tg:Filter(Card.IsAbleToHand,nil)
			if #tc>0 then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
				Duel.ShuffleHand(tp)
			end
		end
		-- 剩下的卡按喜欢的顺序回到卡组上面
		g:Sub(tg)
		if #g>0 then
			Duel.SortDecktop(tp,tp,#g)
		end
	else
		-- 从卡组·墓地把1张「旋风」加入手卡
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
-- 被旋风效果破坏条件
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsReason(REASON_EFFECT) or not c:IsReason(REASON_DESTROY) then return false end
	local rc=c:GetReasonCard()
	if not rc and re then rc=re:GetHandler() end
	return rc and rc:IsCode(5318639)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end