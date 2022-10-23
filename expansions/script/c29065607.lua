--SOPMODII·弄臣
function c29065607.initial_effect(c)
	c:SetSPSummonOnce(29065607)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c29065607.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),true)
	--Equip
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c29065607.eqcon)
	e1:SetOperation(c29065607.eqop)
	c:RegisterEffect(e1)	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065607,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c29065607.destg)
	e3:SetOperation(c29065607.desop)
	c:RegisterEffect(e3)
end
function c29065607.ffilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsFusionSetCard(0x87ad)
end
function c29065607.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetHandler():GetMaterial():Filter(Card.IsSetCard,nil,0x7ad):GetCount()>0
end
function c29065607.eqop(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetValue(c29065607.eqlimit)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
end
function c29065607.eqlimit(e,c)
	return c==e:GetLabelObject() 
end
function c29065607.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack())
end
function c29065607.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local dam=tc:GetAttack()
		if dam<0 or tc:IsFacedown() then dam=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
