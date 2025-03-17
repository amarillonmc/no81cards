local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：除外盖卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(2,id)
	e1:SetCost(s.excost1)
	e1:SetTarget(s.extg)
	e1:SetOperation(s.exop)
	c:RegisterEffect(e1)
	
	 --效果②：回收与LP操作
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(2,id)
	e2:SetCost(s.excost2)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end

--===== 效果①处理 =====--
function s.excost1_filter(c)
	return c:IsAbleToRemove() and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_ONFIELD))  and c:IsSetCard(0xe73)
end

function s.excost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.excost1_filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)
			and c:IsAbleToRemove()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.excost1_filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:FilterCount(Card.IsSetCard,nil,0xe73)) 
end

function s.filter(c)
	return c:IsSetCard(0xe73) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end

function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
end

function s.exop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local c=e:GetHandler()
	if #g>0 then
		local tc=Duel.SSet(tp,g:GetFirst())
			  Duel.Recover(tp,700,REASON_EFFECT)
			  Duel.Damage(1-tp,300,REASON_EFFECT)
		-- 如果除外了七仟陌卡则允许当回合发动
		if e:GetLabel()>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			c:RegisterEffect(e2)
		end
	end
end
--===== 效果②处理 =====--
function s.excost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():IsSetCard(0xe73) and 1 or 0)
end

function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
  --  Duel.SetPossibleOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,700)
end

function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		if e:GetLabel()>0 then
			Duel.Recover(tp,700,REASON_EFFECT)
			Duel.Damage(1-tp,300,REASON_EFFECT)
		end
	end
end