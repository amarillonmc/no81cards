--奇术人形 狂月龙
local m=40009744
local cm=_G["c"..m]
cm.named_with_MagiaDoll=1
--cm.named_with_MagiaDollD=1
function cm.initial_effect(c)
	aux.AddCodeList(c,40009730)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.negcon)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1) 
 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.drcon)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)   
end
function cm.MagiaDoll(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_MagiaDoll
end
function cm.MagiaDollD(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_MagiaDollD
end
function cm.tfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsFaceup() and (cm.MagiaDoll(c) or ((cm.MagiaDollD(c) or aux.IsCodeListed(c,40009730)) and c:IsType(TYPE_MONSTER)))
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(cm.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.NegateEffect(ev)
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)
end
function cm.drfilter(c)
	return c:IsFaceup() and cm.MagiaDoll(c) and not c:IsCode(m) and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.drfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

