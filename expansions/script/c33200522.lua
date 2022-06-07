--刑事科巡警 糸锯圭介
function c33200522.initial_effect(c)
	aux.AddCodeList(c,33200500)
	aux.AddCodeList(c,33200501)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c33200522.reptg)
	e1:SetValue(c33200522.repval)
	e1:SetOperation(c33200522.repop)
	c:RegisterEffect(e1)   
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33200522)
	e2:SetCondition(c33200522.tzcon)
	e2:SetTarget(c33200522.tztg)
	e2:SetOperation(c33200522.tzop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c33200522.target)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end

--e1
function c33200522.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and aux.IsCodeListed(c,33200500) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and not c:IsReason(REASON_REPLACE)
end
function c33200522.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c33200522.filter,1,c,tp)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c33200522.repval(e,c)
	return c33200522.filter(c,e:GetHandlerPlayer())
end
function c33200522.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

--e2
function c33200522.exfilter(c)
   return not c:IsPublic()
end
function c33200522.exfilter2(c,typ)
   return c:IsType(typ) and not c:IsPublic() 
end
function c33200522.tzcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetFlagEffect(33200500)>0 and re:IsActiveType(TYPE_MONSTER) and rp==tp
end
function c33200522.tztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
end
function c33200522.tzop(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabel()
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c33200522.exfilter2,tp,0,LOCATION_HAND,1,nil) then return end
	local g=Duel.SelectMatchingCard(c33200522.exfilter2,tp,0,LOCATION_HAND,1,1,nil)
	if g>GetCount()>0 then 
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			tc:RegisterEffect(e1)
		end
	end
end

--e3
function c33200522.target(e,c)
	return c:IsCode(33200501)
end
