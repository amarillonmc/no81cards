--本条二亚的漫画贩卖竞争
function c33400254.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,33400254)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c33400254.operation)
	c:RegisterEffect(e2)
	 --confirm TP
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,33400254+10000)
	e3:SetOperation(c33400254.operation2)
	c:RegisterEffect(e3)
end
function c33400254.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	local token=Duel.CreateToken(tp,ac)
	local t1=bit.band(token:GetType(),0x7)
	local t2=bit.band(tc:GetType(),0x7)
	if t1==t2  then 
		if Duel.SelectYesNo(tp,aux.Stringid(33400254,0))  then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		   local tc0=Duel.SelectMatchingCard(tp,c33400254.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		   local tc1=tc0:GetFirst()
		   local tc2=Duel.Destroy(tc1,REASON_EFFECT)
			   if tc1:GetControler()==tp and tc2~=0 then 
					 if Duel.SelectYesNo(tp,aux.Stringid(33400254,1)) and Duel.IsExistingTarget(c33400254.thfilter,tp,LOCATION_GRAVE,0,1,nil) then 
						local g3=Duel.SelectTarget(tp,c33400254.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
						Duel.SendtoHand(g3,nil,REASON_EFFECT)
					 end
			   end   
		end
	else 
		   local g4=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		   Duel.SendtoGrave(g4,nil,REASON_EFFECT)
	end
	if tc:IsCode(ac) then 
		if  Duel.IsPlayerCanDraw(tp,1) then 
				local ct=Duel.Draw(tp,1,REASON_EFFECT)
				if ct==0 then return end
				local dc=Duel.GetOperatedGroup():GetFirst()
				Duel.ConfirmCards(1-tp,dc)
				if dc:IsSetCard(0x341) and Duel.SelectYesNo(tp,aux.Stringid(33400254,2)) then
					Duel.BreakEffect()
					Duel.Draw(tp,1,REASON_EFFECT)
					Duel.DiscardHand(tp,nil,1,1,REASON_COST+REASON_DISCARD)
				else
					Duel.MoveSequence(dc,1)
				end
				Duel.ShuffleHand(tp)
		end 
	end
end
function c33400254.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c33400254.thfilter(c)
	return c:IsSetCard(0x6342) and c:IsAbleToHand()
end
function c33400254.operation2(e,tp,eg,ep,ev,re,r,rp)
		local cm=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		if cm>2 then cm=2 end
		local g=Duel.GetDecktopGroup(tp,cm)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,tp,cm)
end