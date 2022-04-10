--猩红剧团「绯红歌伶」
function c29010201.initial_effect(c)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29010201,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c29010201.tg)
	e4:SetOperation(c29010201.op)
	c:RegisterEffect(e4)
	if not c29010201.global_check then
		c29010201.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c29010201.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c29010201.filter(c)
	return c:IsSetCard(0x17af) and c:IsType(TYPE_MONSTER)
end
function c29010201.thfilter1(c)
	return c:IsSetCard(0x17af) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c29010201.thfilter2(c)
	return c:IsCode(29010200)
end
function c29010201.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c29010201.filter,tp,LOCATION_GRAVE,0,nil)
	local con1,con3,con5=nil
	if ct>=1 then
		con1=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	end
	if ct>=3 then
		con3=Duel.IsExistingMatchingCard(c29010201.thfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	if ct>=5 then
		con5=Duel.IsExistingMatchingCard(c29010201.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	if chk==0 then return con1 or con3 or con5 end
	local cat=0
	if ct>=1 then cat=cat+CATEGORY_ATKCHANGE end
	if ct>=3 then cat=cat+CATEGORY_SEARCH end
	if ct>=5 then cat=cat+CATEGORY_SEARCH+CATEGORY_TOHAND end
	e:SetCategory(cat)
end
function c29010201.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c29010201.filter,tp,LOCATION_GRAVE,0,nil)
	if ct>=1 then
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
		end
	end
	if ct>=3 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c29010201.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
		end
	end
	if ct>=5 then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g3=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29010201.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g3:GetCount()<=0 then return end
		if g3:GetCount()>0 then
		Duel.SendtoHand(g3,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g3)
		end
		Duel.ResetFlagEffect(tp,29010201)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCondition(c29010201.discon)
		e1:SetValue(c29010201.actlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c29010201.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c29010201.discon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,29010201)==0
end
function c29010201.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsCode,1,nil,29010200) then
		Duel.RegisterFlagEffect(rp,29010201,RESET_PHASE+PHASE_END,0,1)
	end
end