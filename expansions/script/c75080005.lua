--纯白义勇队 夏蓉
function c75080005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c75080005.thtg)
	e1:SetOperation(c75080005.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75080005,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c75080005.lvtg)
	e3:SetOperation(c75080005.lvop)
	c:RegisterEffect(e3)
end
function c75080005.thfilter(c)
	return c:IsSetCard(0x3754) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end
function c75080005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.GetFlagEffect(tp,75080005)==0 and Duel.IsExistingMatchingCard(c75080005.thfilter,tp,LOCATION_DECK,0,1,nil) then sel=sel+1 end
		if Duel.GetFlagEffect(tp,75080006)==0 and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75080005,0))
		sel=Duel.SelectOption(tp,aux.Stringid(75080005,1),aux.Stringid(75080005,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(75080005,1))
	else
		Duel.SelectOption(tp,aux.Stringid(75080005,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		Duel.RegisterFlagEffect(tp,75080005,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.RegisterFlagEffect(tp,75080006,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	end
end
function c75080005.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75080005.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function c75080005.filter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0x3754)
end
function c75080005.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c75080005.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75080005.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c75080005.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c75080005.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local op=0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		if tc:IsLevel(1) and c:IsLevel(1) then
			op=Duel.SelectOption(tp,aux.Stringid(75080005,4))
		else
			op=Duel.SelectOption(tp,aux.Stringid(75080005,4),aux.Stringid(75080005,5))
		end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		if e:GetLabel()==0 then
			e2:SetValue(1)
		else
			e2:SetValue(-1)
		end
		c:RegisterEffect(e2)
	end
end