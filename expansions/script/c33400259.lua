--本条二亚的惊叹
function c33400259.initial_effect(c)
	 --Activate(effect)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,33400259)
	e1:SetCondition(c33400259.condition)
	e1:SetOperation(c33400259.operation)
	c:RegisterEffect(e1)
	  --confirm 1-TP
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,33400259+10000)
	e3:SetOperation(c33400259.operation2)
	c:RegisterEffect(e3)
end
function c33400259.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6342)
end
function c33400259.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33400259.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)  
		and Duel.IsChainNegatable(ev)
end
function c33400259.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local token=Duel.CreateToken(tp,ac)
	local t1=bit.band(token:GetType(),0x7)
	local t2=bit.band(tc:GetType(),0x7)
	if t1==t2  then 
		 Duel.Damage(1-tp,500,REASON_EFFECT)  
		 if Duel.SelectYesNo(tp,aux.Stringid(33400259,0))  then
		   Duel.NegateEffect(ev)
			if re:GetHandler():IsRelateToEffect(re) then 
			   Duel.Destroy(eg,REASON_EFFECT)
			end
		 end
	end
	if tc:IsCode(ac) then 
		 Duel.Damage(1-tp,1000,REASON_EFFECT)  
		 if Duel.SelectYesNo(tp,aux.Stringid(33400259,1)) and Duel.IsExistingTarget(c33400259.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then 
			 local g3=Duel.SelectTarget(tp,c33400259.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			 Duel.SendtoHand(g3,nil,REASON_EFFECT)   
		 end
		 if tc:IsSetCard(0x341) and Duel.SelectYesNo(tp,aux.Stringid(33400259,2))then 
		 Duel.SendtoGrave(tc,REASON_EFFECT)
		 else  Duel.MoveSequence(tc,1)  
		 end
	end 
end
function c33400259.thfilter(c)
	return c:IsSetCard(0x6342) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33400259.operation2(e,tp,eg,ep,ev,re,r,rp)
		local cm=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		if cm>2 then cm=2 end
		local g=Duel.GetDecktopGroup(1-tp,cm)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,1-tp,cm)
end