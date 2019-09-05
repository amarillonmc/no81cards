--洞彻万物 本条二亚
function c33400202.initial_effect(c)
	 --negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,33400202)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCondition(c33400202.condition1)
	e1:SetCost(c33400202.discost)
	e1:SetTarget(c33400202.target1)
	e1:SetOperation(c33400202.activate1)
	c:RegisterEffect(e1)
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400202,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,33400202+10000)
	e2:SetOperation(c33400202.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c33400202.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c33400202.condition1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev) and bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)==0
end
function c33400202.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c33400202.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsCode(ac) then 
	  Duel.NegateActivation(ev)  
	else if Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil)
		 then Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			  local g=Duel.SelectTarget(1-tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
			  Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		 end
	end
end
function c33400202.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsCode(ac) then 
		 if Duel.SelectYesNo(tp,aux.Stringid(33400202,2)) 
		 then
		 Duel.SendtoHand(tc,nil,REASON_EFFECT)
		 end
	else Duel.Draw(1-tp,1,REASON_EFFECT)
		 if Duel.SelectYesNo(tp,aux.Stringid(33400202,1)) 
		 then Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
		 end  
	end
end