--朦雨的巡长·阿斯特拉
local s,id,o=GetID()
function s.initial_effect(c)
	--同调召唤
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x613),1)
	c:EnableReviveLimit()
	
	--①：自己回合双方不能除外
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(s.limcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	--②：对方发动效果时送墓
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.gycon)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
	
	--③：结束阶段回收抽卡（不取对象）
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end

-- === 效果① ===
function s.limcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end

-- === 效果② ===
function s.lkfilter(c)
	return c:IsType(TYPE_LINK) and c:IsLinkAbove(3) and c:IsFaceup()
end

function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	local loc=re:GetActivateLocation()
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) 
		and (loc==LOCATION_HAND or loc==LOCATION_MZONE)
		and Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsRelateToEffect(re) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,re:GetHandler(),1,0,0)
end

function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.SendtoDeck(rc,nil,REASON_EFFECT)
	end
end

-- === 效果③ ===
function s.tdfilter(c)
	return c:IsSetCard(0x613) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	-- 在效果处理时选卡（不取对象）
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		-- 提示选择的卡
		Duel.HintSelection(g)
		-- 回到卡组最下面 (SEQ_DECKBOTTOM = 1)
		if Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end