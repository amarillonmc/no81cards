--祈祷者 本条二亚
function c33400209.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()
   --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400209,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,33400209)
	e2:SetCondition(c33400209.thcon)
	e2:SetTarget(c33400209.thtg)
	e2:SetOperation(c33400209.thop)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400209,1))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33400209+10000)
	e3:SetCost(c33400209.dmcost)
	e3:SetOperation(c33400209.dmop)
	c:RegisterEffect(e3)
end
function c33400209.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c33400209.thfilter(c)
	return c:IsSetCard(0x341) and c:IsAbleToHand()
end
function c33400209.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c33400209.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400209.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c33400209.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33400209.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c33400209.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function c33400209.dmop(e,tp,eg,ep,ev,re,r,rp)
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
	   Duel.Damage(1-tp,500,REASON_EFFECT) 
		 if Duel.SelectYesNo(tp,aux.Stringid(33400209,0)) then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			 local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
			 Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		 end	 
	end
	if tc:IsCode(ac) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
			e:SetLabel(Duel.AnnounceType(tp))
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAINING)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)	  
			e2:SetOperation(c33400209.regop)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_CHAIN_SOLVED)
			e3:SetReset(RESET_PHASE+PHASE_END)   
			e3:SetCondition(c33400209.damcon)
			e3:SetOperation(c33400209.damop)
			Duel.RegisterEffect(e3,tp)
	end
end
function c33400209.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(33400209,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c33400209.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=e:GetLabel()
	return ((opt==0 and re:IsActiveType(TYPE_MONSTER)) or (opt==1 and re:IsActiveType(TYPE_SPELL)) or (opt==2 and re:IsActiveType(TYPE_TRAP))) and ep~=tp and c:GetFlagEffect(33400209)~=0
end
function c33400209.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33400209)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end