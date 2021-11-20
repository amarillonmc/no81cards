--M4A1·伸冤者
function c29065606.initial_effect(c)
	c:SetSPSummonOnce(29065606)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),5,2,c29065606.ovfilter,aux.Stringid(29065606,1))
	c:EnableReviveLimit()
	--Equip
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c29065606.eqcon)
	e1:SetOperation(c29065606.eqop)
	c:RegisterEffect(e1)   
	--Disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065606,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c29065606.descon)
	e3:SetTarget(c29065606.destg)
	e3:SetOperation(c29065606.desop)
	c:RegisterEffect(e3)  
end
function c29065606.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x87ad) and c:IsLevel(4) and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c29065606.eqfil(c,tc)
	return c:GetPreviousEquipTarget()==tc
end
function c29065606.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetMaterial():Filter(Card.IsSetCard,nil,0x7ad):GetCount()>0
end
function c29065606.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial():Filter(Card.IsSetCard,nil,0x7ad)
	if g:GetCount()>Duel.GetLocationCount(tp,LOCATION_SZONE) then
	g=g:Select(tp,Duel.GetLocationCount(tp,LOCATION_SZONE),Duel.GetLocationCount(tp,LOCATION_SZONE),nil)
	end
	local tc=g:GetFirst()
	while tc do 
	Duel.Equip(tp,tc,c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(c)
	e1:SetValue(c29065606.eqlimit)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
end
function c29065606.eqlimit(e,c)
	return c==e:GetLabelObject() 
end
function c29065606.descon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c29065606.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
end
function c29065606.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(-1000)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		tc=g:GetNext()   
	end
	end
end












