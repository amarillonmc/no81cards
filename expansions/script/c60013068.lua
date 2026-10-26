-- 创造·○
local cm,m,o=GetID()
cm.isSouzou=true	-- 「创造」字段（只含「创造·○」「创造·□」「创造·△」）

function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	-- 卡的发动本身同一连锁只能有1次，不写 EFFECT_COUNT_CODE_CHAIN（会占用连锁计数，卡住别的「同一连锁1次」效果）
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

	-- ②：这张卡在墓地存在的场合才能发动。墓地的这张卡和2张「创造·○」回到卡组，自己抽1张
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetTarget(cm.gytg)
	e2:SetOperation(cm.gyop)
	c:RegisterEffect(e2)
end

function cm.tdfil(c)
	return c:IsAbleToDeck()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
-- ①：回复500；那之后，可以选1张手卡回到卡组，再回复500
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,500,REASON_EFFECT)
	if not Duel.IsExistingMatchingCard(cm.tdfil,tp,LOCATION_HAND,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfil,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 then return end
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end

-- ②：墓地的这张卡和2张同名卡回到卡组，抽1张
function cm.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(function(tc)
			return tc~=c and tc:IsCode(c:GetCode())
		end,tp,LOCATION_GRAVE,0,2,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_GRAVE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,function(tc)
		return tc~=c and tc:IsCode(c:GetCode())
	end,tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()<2 then return end
	g:AddCard(c)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
