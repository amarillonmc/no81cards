--朦雨的验官·薇斯帕
local s,id,o=GetID()
function s.initial_effect(c)
	--同调召唤
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x613),1)
	c:EnableReviveLimit()
	
	--①：弹回魔陷
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	--②：选2张魔陷，1盖1堆
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.stcon)
	e2:SetTarget(s.sttg)
	e2:SetOperation(s.stop)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.lkfilter(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup()
end

function s.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.stfilter(chkc) end
	-- 获取自己场上连接怪兽数量
	local ct=Duel.GetMatchingGroupCount(s.lkfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 
		and Duel.IsExistingTarget(s.stfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	-- 最多有那个数量
	local g=Duel.SelectTarget(tp,s.stfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

-- === 效果② ===
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK)
end

function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.basefilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function s.setfilter_main(c,tp)
	return s.basefilter(c) and c:IsSSetable()
		and Duel.IsExistingMatchingCard(s.gyfilter_sub,tp,LOCATION_DECK,0,1,c,c:GetCode())
end

function s.gyfilter_sub(c,code)
	return s.basefilter(c) and c:IsAbleToGrave() and not c:IsCode(code)
end

function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(s.setfilter_main,tp,LOCATION_DECK,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function s.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g1=Duel.SelectMatchingCard(tp,s.setfilter_main,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	
	if tc1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,s.gyfilter_sub,tp,LOCATION_DECK,0,1,1,tc1,tc1:GetCode())
		local tc2=g2:GetFirst()
		
		if tc2 then
			Duel.SSet(tp,tc1)
			Duel.SendtoGrave(tc2,REASON_EFFECT)
		end
	end
end