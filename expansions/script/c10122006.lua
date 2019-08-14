--空想的低语
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function c10122006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c10122006.target)
	e1:SetOperation(c10122006.activate)
	c:RegisterEffect(e1)  
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122006,4))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_END_PHASE)   
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c10122006.cost)
	e2:SetTarget(c10122006.settg)
	e2:SetOperation(c10122006.setop)
	c:RegisterEffect(e2)  
end
function c10122006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10122006)==0 end
	e:GetHandler():RegisterFlagEffect(10122006,RESET_CHAIN,0,1)
end
function c10122006.desfilter(c)
	return c:GetSequence()==5 and c:IsDestructable() and c:IsFaceup() and c:IsSetCard(0xc333)
end
function c10122006.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c10122006.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10122006.desfilter,tp,LOCATION_SZONE,0,1,nil) and e:GetHandler():IsSSetable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10122006.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c10122006.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and (c:IsSSetable() or c:IsAbleToHand()) then
	   if c:IsAbleToHand() and (not c:IsSSetable() or not Duel.SelectYesNo(tp,aux.Stringid(10122006,0))) then 
		  Duel.SendtoHand(c,nil,REASON_EFFECT)
	   else
		  Duel.SSet(tp,c)
		  Duel.ConfirmCards(1-tp,c)
	   end
	   e:SetLabel(0)
	   if rsul.thtg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(10122006,3)) then
		  rsul.thop(e,tp,eg,ep,ev,re,r,rp)
	   end
	end
end
function c10122006.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc333)
end
function c10122006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c10122006.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10122006.atkfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10122006.atkfilter,tp,LOCATION_ONFIELD,0,1,2,nil)
end
function c10122006.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	if g:GetCount()<=0 then return end
	for tc in aux.Next(g) do
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetDescription(aux.Stringid(10122006,2))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetOwnerPlayer(tp)
		if Duel.GetTurnPlayer()==tp then
		  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
		  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		end
		e2:SetValue(c10122006.efilter)
		tc:RegisterEffect(e2)
		if not tc:IsImmuneToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_UPDATE_ATTACK)
		   e1:SetReset(RESET_EVENT+0x1fe0000)
		   e1:SetValue(3000)
		   tc:RegisterEffect(e1)
		end
	end
end
function c10122006.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end