--神代丰的铁骑 卓殊之翼
function c64800098.initial_effect(c)
	c:SetSPSummonOnce(64800098)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c64800098.lcheck)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64800098,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,64800098)
	e1:SetTarget(c64800098.eqtg)
	e1:SetOperation(c64800098.eqop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c64800098.target)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c64800098.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x641a)
end

--e1
function c64800098.eqfilter(c)
	return c:IsCode(64800097) and not c:IsForbidden()
end
function c64800098.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c64800098.eqfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,nil)
end
function c64800098.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c64800098.eqfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,false) then return end  
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c64800098.eqlimit)
			tc:RegisterEffect(e1)
	end
end
function c64800098.eqlimit(e,c)
	return e:GetOwner()==c
end


--e2
function c64800098.target(e,c)
	return c:IsSetCard(0x641a)
end
