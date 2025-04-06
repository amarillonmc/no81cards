--闪术兵器 — 澪矢
function c11513054.initial_effect(c)
	--to deck 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOEXTRA+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_LEAVE_FIELD) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11513054)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsReason(REASON_MATERIAL) and e:GetHandler():IsReason(REASON_LINK) and e:GetHandler():GetReasonCard():IsSetCard(0x1115) end) 
	e1:SetTarget(c11513054.tdtg) 
	e1:SetOperation(c11513054.tdop) 
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_CHAIN_NEGATED) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21513054)
	e2:SetCondition(c11513054.spcon)  
	e2:SetTarget(c11513054.sptg) 
	e2:SetOperation(c11513054.spop) 
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_CHAIN_DISABLED) 
	c:RegisterEffect(e3) 
end
function c11513054.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsType(TYPE_SPELL) and c:IsDiscardable() end,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsType(TYPE_SPELL) and c:IsDiscardable() end,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end 
function c11513054.tdfil(c) 
	return c:IsAbleToDeck() and c:IsFaceupEx()  
end 
function c11513054.tdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c11513054.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>=5 and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end 
function c11513054.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11513054.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil) 
	if #g>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,5,5,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end 
end 
function c11513054.spcon(e,tp,eg,ep,ev,re,r,rp) 
	local tc=re:GetHandler()
	return tc:IsControler(tp) and tc:IsSetCard(0x1115)  
end 
function c11513054.sctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPELL) 
end  
function c11513054.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11513054.sctfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c11513054.sctfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end 
function c11513054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c11513054.espfil(c,e,tp) 
	return c:IsLinkSummonable(nil,e:GetHandler()) and c:IsSetCard(0x1115)  
end 
function c11513054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c11513054.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(11513054,1)) then 
		 Duel.BreakEffect() 
		 local sc=Duel.SelectMatchingCard(tp,c11513054.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
		 Duel.LinkSummon(tp,sc,nil,c)
	end 
end 







