--命运的王牌
function c25000176.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,25000176)
	e1:SetTarget(c25000176.target)
	e1:SetOperation(c25000176.activate)
	c:RegisterEffect(e1)	
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,05000176)
	e2:SetTarget(c25000176.target1)
	e2:SetOperation(c25000176.activate1)
	c:RegisterEffect(e2)	
end
function c25000176.ckfil(c,e,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c25000176.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c) 
end
function c25000176.spfil(c,e,tp,tc)
	local code=tc:GetCode()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c25000176.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c25000176.ckfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local tc=Duel.SelectTarget(tp,c25000176.ckfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,tc,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c25000176.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c25000176.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,tc) then	 
	local sg=Duel.SelectMatchingCard(tp,c25000176.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c25000176.mgfilter(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc
		and fusc:CheckFusionMaterial(mg,c,PLAYER_NONE,true)
end
function c25000176.xfilter(c)
	local g=c:GetMaterial()
	return c:IsType(TYPE_FUSION) and g:FilterCount(c25000176.mgfilter,nil,e,tp,e:GetHandler(),g)==g:GetCount()
end
function c25000176.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c25000176.xfilter,tp,LOCATION_MZONE,0,1,nil) end
	local tc=Duel.SelectTarget(tp,c25000176.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local mg=tc:GetMaterial()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,mg,mg:GetCount(),tp,LOCATION_GRAVE)
end
function c25000176.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local mg=tc:GetMaterial()
	if mg:FilterCount(c25000176.mgfilter,nil,e,tp,e:GetHandler(),g)==mg:GetCount() then 
	Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)
	if tc:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(mg:GetSum(Card.GetAttack))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	end
	end
end



