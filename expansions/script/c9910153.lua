--战车道的探寻
function c9910153.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910153+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910153.target)
	e1:SetOperation(c9910153.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c9910153.reptg)
	e2:SetValue(c9910153.repval)
	e2:SetOperation(c9910153.repop)
	c:RegisterEffect(e2)
end
function c9910153.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0 end
end
function c9910153.xyzfilter(c)
	return c:IsType(TYPE_XYZ)
end
function c9910153.thfilter(c,lv)
	return c:IsSetCard(0x952) and c:GetOriginalLevel()==lv and c:IsAbleToHand()
end
function c9910153.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c9910153.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	if g:GetCount()>0 then
		local tg=g:RandomSelect(1-tp,1)
		Duel.ConfirmCards(1-tp,tg)
		if not tg:IsExists(c9910153.xyzfilter,1,nil) then return end
		local tc=tg:GetFirst()
		local op=0
		local sg=Duel.GetMatchingGroup(c9910153.thfilter,tp,LOCATION_DECK,0,nil,tc:GetRank())
		if sg:GetCount()>0 then op=Duel.SelectOption(tp,aux.Stringid(9910153,0),aux.Stringid(9910153,1))
		else op=Duel.SelectOption(tp,aux.Stringid(9910153,1))+1 end
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ssg=sg:Select(tp,1,1,nil)
			if Duel.SendtoHand(ssg,nil,REASON_EFFECT)==0 then return end
			Duel.ConfirmCards(1-tp,ssg)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
			e1:SetValue(c9910153.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end 
	end
end
function c9910153.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x952) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c9910153.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c9910153.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c9910153.repval(e,c)
	return c9910153.repfilter(c,e:GetHandlerPlayer())
end
function c9910153.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
