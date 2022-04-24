--逆转辩护士 希月心音
function c33200525.initial_effect(c)
	aux.AddCodeList(c,33200511)
	aux.AddCodeList(c,33200500)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--show
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,33200525)
	e1:SetTarget(c33200525.tztg)
	e1:SetOperation(c33200525.tzop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c33200525.pentg)
	e2:SetOperation(c33200525.penop)
	c:RegisterEffect(e2)
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(33200525,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,33200526)
	e3:SetCondition(c33200525.thcon)
	e3:SetTarget(c33200525.thtg)
	e3:SetOperation(c33200525.thop)
	c:RegisterEffect(e3)
end

--e1
function c33200525.exfilter(c)
   return not c:IsPublic()
end
function c33200525.exfilter2(c,typ)
   return not c:IsPublic() and not c:IsType(typ)
end
function c33200525.tztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200501.exfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c33200525.tzop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c33200501.exfilter,tp,LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
	local typ=Duel.AnnounceType(1-tp)
	if Duel.IsExistingMatchingCard(c33200525.exfilter2,tp,LOCATION_HAND,0,1,nil,typ) and Duel.SelectYesNo(tp,aux.Stringid(33200525,2)) then
		local g=Duel.SelectMatchingCard(tp,c33200525.exfilter2,tp,LOCATION_HAND,0,1,1,nil,typ)
		if g:GetCount()>0 then 
			local exc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			exc:RegisterEffect(e1)
		end
	end
end

--e2
function c33200525.penfilter(c)
	return aux.IsCodeListed(c,33200501) and c:IsType(TYPE_PENDULUM) and not c:IsCode(33200525) and not c:IsForbidden()
end
function c33200525.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c33200525.penfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c33200525.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c33200525.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end

--e3
function c33200525.thcfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and aux.IsCodeListed(c,33200511)  and c~=e:GetHandler()
end
function c33200525.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33200525.thcfilter,1,nil,e,tp)
end
function c33200525.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c33200525.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end