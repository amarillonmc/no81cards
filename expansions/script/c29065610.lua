--RO635·审判者
function c29065610.initial_effect(c)
	c:SetSPSummonOnce(29065610)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c29065610.lcheck)
	--Equip
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c29065610.eqcon)
	e1:SetOperation(c29065610.eqop)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065610,0))
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c29065610.eqtg1)
	e2:SetOperation(c29065610.eqop1)
	c:RegisterEffect(e2)		
end
function c29065610.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x87ad)
end
function c29065610.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMaterial():Filter(Card.IsSetCard,nil,0x7ad):GetCount()>0
end
function c29065610.eqop(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetValue(c29065610.eqlimit)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
end

function c29065610.eqlimit(e,c)
	return c==e:GetLabelObject() 
end
function c29065610.ckxfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE)
end
function c29065610.eqtfil(c)
	return c:IsSetCard(0x7ad)
end
function c29065610.cthfil(c)
	return c:GetEquipTarget()~=nil and c:IsAbleToDeck()
end
function c29065610.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065610.ckxfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c29065610.eqtfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c29065610.cthfil,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c29065610.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c29065610.cthfil,tp,LOCATION_SZONE,0,nil)
	if g1:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g1:Select(tp,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	local g2=Duel.GetMatchingGroup(c29065610.ckxfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if g2:GetCount()<=0 then return end
	local tc=Duel.SelectMatchingCard(tp,c29065610.eqtfil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=g2:Select(tp,1,1,nil):GetFirst()
	if Duel.Equip(tp,ec,tc) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(c29065610.eqlimit1)
			ec:RegisterEffect(e1)
	end
end
function c29065610.eqlimit1(e,c)
	return c==e:GetLabelObject() 
end








