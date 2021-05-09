--DD宣言
function c16200001.initial_effect(c)
	aux.AddCodeList(c,16200003)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c16200001.target)
	e1:SetOperation(c16200001.activate)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(c16200001.efilter1)
	c:RegisterEffect(e2)
	--imm
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c16200001.efilter1)
	e3:SetValue(c16200001.efilter2)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16200001,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,16200001)
	e4:SetTarget(c16200001.tg1)
	e4:SetOperation(c16200001.op1)
	c:RegisterEffect(e4)
	--RemoveCard
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(16200001,1))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,16200001+100)
	e5:SetTarget(c16200001.tg2)
	e5:SetOperation(c16200001.op2)
	c:RegisterEffect(e5)
	--sum limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c16200001.splimit)
	c:RegisterEffect(e6)
end
function c16200001.splimit(e,c,tp,sumtp,sumpos)
	return c:GetOriginalCode()~=16200003
end
function c16200001.efilter(e,c)
	return aux.IsCodeListed(c,16200003) and c:IsFaceup()
end
function c16200001.efilter1(e,c)
	return aux.IsCodeListed(c,16200003) and c:IsFaceup()
end
function c16200001.efilter2(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c16200001.tfilter1(c)
	return c:IsAbleToDeck() and aux.IsCodeListed(c,16200003)
end
function c16200001.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingMatchingCard(c16200001.tfilter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) end
	local num=Duel.GetMatchingGroupCount(c16200001.tfilter1,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,c16200001.tfilter1,tp,LOCATION_GRAVE,0,1,num,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
--
function c16200001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c16200001.activate(e,tp,eg,ep,ev,re,r,rp)
end
function c16200001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gn=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if gn:GetCount()<1 then return end
	Duel.SendtoDeck(gn,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	Duel.ShuffleDeck(tp)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==gn:GetCount() then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c16200001.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if aux.IsCodeListed(e:GetHandler(),16200003) then return end
	Duel.RegisterFlagEffect(tp,16200001,RESET_PHASE+PHASE_END,0,0)
end
--
function c16200001.tfilter2(c)
	return c:IsDestructable() and aux.IsCodeListed(c,16200003) and c:IsFaceup()
end
function c16200001.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingMatchingCard(c16200001.tfilter2,tp,LOCATION_ONFIELD,0,1,c) and Duel.IsPlayerCanDraw(tp,2) end
	local num=Duel.GetMatchingGroupCount(c16200001.tfilter2,tp,LOCATION_ONFIELD,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectTarget(tp,c16200001.tfilter2,tp,LOCATION_ONFIELD,0,1,num,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
--
function c16200001.tfilter3(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT)
end
function c16200001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gn=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if gn:GetCount()<1 then return end
	local num=Duel.Destroy(gn,REASON_EFFECT)
	if num<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c16200001.tfilter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,num,nil,tp)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end