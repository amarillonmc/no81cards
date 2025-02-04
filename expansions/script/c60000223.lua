-- 矢车菊之暗 (60000223)
local s,id=GetID()
local cm,m,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,60000211) -- 关联拉弥亚·深谣
	
	-- ① 发动时检索本家怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35699,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_FZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.adtg)
	e2:SetOperation(cm.adop)
	c:RegisterEffect(e2)
end

-- 效果①：发动时检索
function s.thfilter(c)
	return c:IsCode(60000211) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.fil2(c)
	return aux.IsCodeListed(c,60000211) and c:IsAbleToHand() and not c:IsCode(m) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b2=false
	if Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	if chk==0 then return b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b2=false
	if Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	if not b2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.fil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
			local tc=g:GetFirst()
			if tc:CheckActivateEffect(true,true,false)==nil then return end
			if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
			local te=tc:CheckActivateEffect(true,true,false)
			e:SetLabelObject(te:GetLabelObject())
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end