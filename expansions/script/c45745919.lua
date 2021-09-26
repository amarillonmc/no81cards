--极翼灵兽 M大比鸟
function c45745919.initial_effect(c)
	aux.AddCodeList(c,45745901)
	--spesm
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x324),7,99,c45745919.ovfilter,aux.Stringid(45745919,2),99,c45745919.xyzop)
	c:EnableReviveLimit() 

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745919,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,45745919)
	e1:SetCondition(c45745919.tgcon)
	e1:SetTarget(c45745919.settg)
	e1:SetOperation(c45745919.setop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45745919,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c45745919.cost)
	e2:SetOperation(c45745919.actlimit)
	c:RegisterEffect(e2)

end
--xyz
function c45745919.ovfilter(c)
	return c:IsFaceup() and c:IsCode(45745901)
end
function c45745919.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x323)
end
function c45745919.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,33200052)==0 
	and Duel.IsExistingMatchingCard(c45745919.xyzfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.RegisterFlagEffect(tp,33200052,nil,EFFECT_FLAG_OATH,1)
end

--e1
function c45745919.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c45745919.setfilter(c)
	return c:IsSetCard(0x881) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) and c:IsSSetable()
end
function c45745919.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45745919.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c45745919.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c45745919.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

--e2
function c45745919.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c45745919.actlimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c45745919.elimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c45745919.elimit(e,te,tp)
	return te:IsActiveType(TYPE_MONSTER)
end