--爆苍联合 捷豹
local s,id=GetID()
s.named_with_RoaringAzure=1

function s.RoaringAzure(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_RoaringAzure
end

function s.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.pencon)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+2)
	e3:SetCondition(s.pzcon)
	e3:SetTarget(s.pztg)
	e3:SetOperation(s.pzop)
	c:RegisterEffect(e3)

end

s.HULAKAN_CODE=40020569

function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	if not (ac and ac:IsControler(tp) and s.RoaringAzure(ac)) then return false end
	local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if c==pz0 then
		return pz1 and pz1:IsCode(s.HULAKAN_CODE)
	elseif c==pz1 then
		return pz0 and pz0:IsCode(s.HULAKAN_CODE)
	end
	return false
end

function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.DiscardDeck(1-tp,5,REASON_EFFECT)
	end
end

function s.lvfilter(c)
	return s.RoaringAzure(c) and c:IsFaceup() and c:GetLevel()>0
end

function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.lvfilter(chkc) and chkc~=c end
	if chk==0 then return c:GetLevel()>0 
		and Duel.IsExistingTarget(s.lvfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.lvfilter,tp,LOCATION_MZONE,0,1,1,c)
end

function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()

	if c:IsFaceup() and c:IsRelateToEffect(e) and c:GetLevel()>0 then
		local op1=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
		local val1
		if op1==0 then val1=1 else val1=-1 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(val1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetLevel()>0 then
		local op2=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
		local val2
		if op2==0 then val2=1 else val2=-1 end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetValue(val2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

function s.synfilter(c,tp)
	return c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and s.RoaringAzure(c)
end

function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.synfilter,1,nil,tp)
end

function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if not c:IsFaceup() then return false end
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
			return true
		end
		local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		return (pz0 and pz0:IsAbleToHand()) or (pz1 and pz1:IsAbleToHand())
	end
end

function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local pz0=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pz1=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local empty0=(pz0==nil)
	local empty1=(pz1==nil)
	if empty0 and empty1 then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		return
	end 
	if not empty0 and not empty1 then
		local g=Group.CreateGroup()
		if pz0:IsAbleToHand() then g:AddCard(pz0) end
		if pz1:IsAbleToHand() then g:AddCard(pz1) end
		if #g==0 then return end 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local seq=tc:GetSequence()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true,1<<seq)
		return
	end
	local tc = pz0 or pz1
	local seq_card = tc:GetSequence()
	local seq_empty = 1 - seq_card
	if tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true,1<<seq_card)
	else
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true,1<<seq_empty)
	end
end


