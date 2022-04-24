--仓院流灵媒道 绫里真宵
function c33200514.initial_effect(c)
	aux.AddCodeList(c,33200511)
	aux.AddCodeList(c,33200500)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200514,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,33200514)
	e1:SetTarget(c33200514.thtg)
	e1:SetOperation(c33200514.thop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200514,0))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,33200515)
	e2:SetTarget(c33200514.eqtg)
	e2:SetOperation(c33200514.eqop)
	c:RegisterEffect(e2)
end

--e1
function c33200514.thfilter(c)
	return c:IsCode(33200511) and c:IsAbleToHand()
end
function c33200514.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200514.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33200514.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33200514.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--e2
function c33200514.filter(c)
	return aux.IsCodeListed(c,33200500) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and not c:IsCode(33200514)
end
function c33200514.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33200514.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c33200514.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c33200514.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c33200514.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		tc:RegisterFlagEffect(33200514,RESET_EVENT+RESETS_STANDARD,0,1)  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c33200514.eqlimit)
		tc:RegisterEffect(e1)
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(33200515,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,fid)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCondition(c33200514.descon)
		e2:SetOperation(c33200514.desop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e2:SetCountLimit(1)
		e2:SetLabel(Duel.GetTurnCount())
		tc:RegisterEffect(e2,true)
		local code=tc:GetOriginalCodeRule()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_CHANGE_CODE)
		e3:SetValue(code)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e3)
		local cid2=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_ADJUST)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e4:SetLabelObject(e3)
		e4:SetLabel(cid2)
		e4:SetOperation(c33200514.rstop)
		c:RegisterEffect(e4)
		Duel.BreakEffect()
		--active effect
		if tc:GetOriginalCode()==33200501 and Duel.IsExistingMatchingCard(c33200501.thfilter,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_CARD,tp,33200501)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c33200501.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
		if tc:GetOriginalCode()==33200503 then 
			Duel.Hint(HINT_CARD,tp,33200503)
			Duel.RegisterFlagEffect(tp,33200503,RESET_PHASE+PHASE_END,0,2)
		end
		if tc:GetOriginalCode()==33200511 and Duel.IsExistingMatchingCard(c33200511.thfilter,tp,LOCATION_DECK,0,1,nil) then 
			Duel.Hint(HINT_CARD,tp,33200511)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c33200511.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c33200514.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end

--ef
function c33200514.rstfilter(c)
	return c:GetFlagEffect(33200514)>=1
end
function c33200514.rstop(e,tp,eg,ep,ev,re,r,rp)
	local eg=e:GetHandler():GetEquipGroup()
	local ecg=eg:Filter(c33200514.rstfilter,nil)
	if ecg:GetCount()>=1 then return end
	local c=e:GetHandler()
	local cid2=e:GetLabel()
	if cid2~=0 then
		c:ResetEffect(cid2,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e3=e:GetLabelObject()
	e3:Reset()
	e:Reset()
end

--Destroy
function c33200514.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c33200514.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
