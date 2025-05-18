--甘城猫猫的嘲笑
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,id-70000000)
	e2:SetCost(s.spcost)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.tgfilter(c)
	return c:IsSetCard(0x52c4) and c:IsAbleToGrave()
end
function s.rmfilter(c)
	return c:IsSetCard(0x52c4) and c:IsAbleToRemove()
end
function s.thfilter(c)
	return c:IsSetCard(0x52c4) and c:IsAbleToHand() and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local b1=Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
	local b3=Duel.IsExistingTarget(s.thfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_REMOVED,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,3)
		opval[off]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,sel+1))
	if sel==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
	 elseif sel==1 then 
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
	elseif sel==2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_REMOVED,1,1,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local sel=e:GetLabel()
	if #g>0 then
		if sel==0 then 
			Duel.SendtoGrave(g,REASON_EFFECT)
		elseif sel==1 then 
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		elseif sel==2 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x52c4)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x52c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	local lab=0
	if re:IsHasCategory(CATEGORY_ATKCHANGE) or re:IsHasCategory(CATEGORY_DEFCHANGE) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
		lab=1
	end
	e:SetLabel(lab)
end
function s.tfilter(c)
	return c:IsCode(id) and c:IsAbleToHand()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(s.tfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.tfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end