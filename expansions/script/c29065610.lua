--RO635·审判者
function c29065610.initial_effect(c)
	c:SetSPSummonOnce(29065610)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x87ad),2,2)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(29065603)
	c:RegisterEffect(e0)   
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetValue(c29065610.matval)
	c:RegisterEffect(e1) 
	--Equip
	local e2=Effect.CreateEffect(c)   
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c29065610.eqcon)
	e2:SetOperation(c29065610.eqop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c29065610.actcon)
	e3:SetOperation(c29065610.actop)
	c:RegisterEffect(e3)
	--Equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29065610,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,29065610)
	e4:SetCost(c29065610.eqcost1)
	e4:SetTarget(c29065610.eqtg1)
	e4:SetOperation(c29065610.eqop1)
	c:RegisterEffect(e4)		
end
function c29065610.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsLocation,1,nil,LOCATION_SZONE)
end
function c29065610.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMaterial():Filter(Card.IsSetCard,nil,0x87ad):GetCount()>0
end
function c29065610.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial():Filter(Card.IsSetCard,nil,0x87ad)
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
function c29065610.actcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep==tp and rc:IsSetCard(0x87ad) and e:GetHandler():GetLinkedGroup():IsContains(rc) and e:GetHandler():GetSequence()>4
end
function c29065610.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,29065610)
	Duel.SetChainLimit(c29065610.chainlm)
end
function c29065610.chainlm(e,rp,tp)
	return tp==rp
end
function c29065610.eqfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x87ad) 
end
function c29065610.eqtfil(c)
	return c:IsSetCard(0x87ad) 
end
function c29065610.cthfil(c)
	return c:IsSetCard(0x87ad) and c:IsAbleToHand()
end
function c29065610.eqcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065610.cthfil,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c29065610.cthfil,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end
function c29065610.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065610.eqfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c29065610.eqtfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c29065610.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29065610.eqfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c29065610.eqtfil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local ec=g:Select(tp,1,1,nil):GetFirst()
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








