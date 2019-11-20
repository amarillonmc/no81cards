--漫画家 本条二亚
function c33400204.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,33400204)
	e2:SetTarget(c33400204.thtg)
	e2:SetOperation(c33400204.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	 --draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,33400204+10000)
	e4:SetTarget(c33400204.drtg)
	e4:SetOperation(c33400204.drop)
	c:RegisterEffect(e4)
end
function c33400204.thfilter(c,tp)
	return c:IsSetCard(0x6342)  and (c:IsAbleToGrave() or not c:IsForbidden()) and (c:GetType()==0x20004 or c:GetType()==0x20002)
end
function c33400204.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400204.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c33400204.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c33400204.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then 
		 if tc:IsForbidden() or Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then  
		   Duel.SendtoGrave(tc,REASON_EFFECT)   
		 end	
		 if not tc:IsAbleToGrave() then 
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
		 end			  
		 if tc:IsAbleToGrave() and not tc:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			local op=Duel.SelectOption(tp,aux.Stringid(33400204,0),aux.Stringid(33400204,1))
			if op==0 then  Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
			if op==1 then  Duel.SendtoGrave(tc,REASON_EFFECT)   end
		 end		  
	end
end
function c33400204.tdfilter(c)
	return c:IsSetCard(0x6342) and c:IsAbleToDeck()
end
function c33400204.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33400204.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c33400204.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33400204.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33400204.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end