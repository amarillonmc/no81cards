--不纯修女 本条二亚
function c33400207.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	 --check card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400207,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33400207)
	e1:SetCondition(c33400207.ckcon)
	e1:SetTarget(c33400207.cktg)
	e1:SetOperation(c33400207.ckop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400207,3))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,33400207+10000)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33400207.descon)
	e2:SetCost(c33400207.descost)
	e2:SetTarget(c33400207.destg)
	e2:SetOperation(c33400207.desop)
	c:RegisterEffect(e2)
end
function c33400207.ckcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400207.cktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK)>0  end
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if chk==0 then return b1 or b2 end
	local op
	if b1 and b2 then 
			 op=Duel.SelectOption(tp,aux.Stringid(33400207,0),aux.Stringid(33400207,1))
			 Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())   
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(33400207,0))
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())   
	else
		op=Duel.SelectOption(tp,aux.Stringid(33400207,1))
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())   
	end
	e:SetLabel(op)
end
function c33400207.ckop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if cm1>3 then cm1=3 end
	if cm2>3 then cm2=3 end
	if op==0 then
		local g=Duel.GetDecktopGroup(tp,cm1)
		Duel.ConfirmCards(tp,g)  
		Duel.SortDecktop(tp,tp,cm1)   
	else 
		  local g=Duel.GetDecktopGroup(1-tp,cm2)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,1-tp,cm2)			 
	end
end
function c33400207.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x6342)
end
function c33400207.descost(e,tp,eg,ep,ev,re,r,rp,chk)
   local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function c33400207.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c33400207.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	local c=e:GetHandler()
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
	end
	if tc:IsCode(ac) then 
		  Duel.Damage(1-tp,1000,REASON_EFFECT)
		  if tc1:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(33400207,4)) then		  
			  Duel.Destroy(tc1,REASON_EFFECT)
		  end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(-500)
			c:RegisterEffect(e1)
	end
end