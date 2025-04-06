local s,id=GetID()
function s.initial_effect(c)
	-- 效果①：丢弃手卡堆墓+盖卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
   -- e1:SetRange(LOCATION_HAND)
  --  e1:SetCountLimit(1,id)
	e1:SetCost(s.discost)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	
	-- 效果②：墓地除外赋予抗性
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
   -- e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.immcon)
	e2:SetCost(s.immcost)
	e2:SetOperation(s.immop)
	c:RegisterEffect(e2)
end

-- ===== 效果①处理 =====
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SendtoGrave(Duel.GetFieldGroup(tp,LOCATION_HAND,0),REASON_COST+REASON_DISCARD)
end

function s.tgfilter(c)
	return c:IsSetCard(0xb) and c:IsType(TYPE_MONSTER)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,2,nil)
			and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,66957584)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	-- 送墓2只永火怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,2,2,nil)
	if #g1==2 and Duel.SendtoGrave(g1,REASON_EFFECT)==2 then
		-- 盖放永火炮
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g2=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,66957584)
		if g2 then
			Duel.SSet(tp,g2)
		end
	end
end

-- ===== 效果②处理 =====
function s.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end

function s.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function s.immop(e,tp,eg,ep,ev,re,r,rp)
	-- 效果发动不可无效
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
	-- 效果处理不可无效
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetValue(s.efilter)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function s.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler():IsSetCard(0xb) and te:GetHandlerPlayer()==p
end