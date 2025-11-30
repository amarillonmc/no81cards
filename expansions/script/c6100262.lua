--朦雨的检者·瑠花
local s,id,o=GetID()
function s.initial_effect(c)
	--同调召唤
	-- 调整＋调整以外的「朦雨」怪兽1只以上
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x613),1)
	c:EnableReviveLimit()
	
	--①：有连接怪兽则炸卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	--②：连接状态回收怪兽 + 盖放魔陷
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.setcon)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.lkfilter(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup()
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	-- 自己场上有连接怪兽存在
	return Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

-- === 效果② ===
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	-- 连接状态
	return e:GetHandler():IsLinkState()
end

function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end

function s.tdfilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end

function s.setfilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		-- 选1只回到卡组
		if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
			-- 墓地选魔陷盖放
			local sg=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_GRAVE,0,nil)
			if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local tg=sg:Select(tp,1,1,nil)
				Duel.SSet(tp,tg)
			end
		end
	end
end