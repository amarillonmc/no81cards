--邪心英雄 刹龙魔
function c77000423.initial_effect(c)
	aux.AddCodeList(c,94820406)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x6008),aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),true) 
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(function(e,se,sp,st)
	return se:GetHandler():IsCode(94820406)
		or Duel.IsPlayerAffectedByEffect(sp,72043279) and st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION end) 
	c:RegisterEffect(e0) 
	--remove 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c77000423.rmcon)
	e1:SetTarget(c77000423.rmtg)
	e1:SetOperation(c77000423.rmop)
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(0,LOCATION_MZONE) 
	e2:SetValue(function(e) 
	local mg=e:GetHandler():GetMaterial() 
	local tc=mg:Filter(Card.IsRace,nil,RACE_DRAGON):GetFirst()  
	if tc then 
	return -tc:GetLevel()*100 
	else return false end end) 
	c:RegisterEffect(e2)
end
c77000423.material_setcode=0x8
c77000423.dark_calling=true
function c77000423.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and rp==1-tp 
end
function c77000423.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst():IsAbleToRemove() end 
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end 
function c77000423.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then 
		local sg=Group.FromCards(c,tc) 
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
			e1:SetCode(EVENT_PHASE+PHASE_END) 
			e1:SetRange(LOCATION_REMOVED) 
			e1:SetCountLimit(1)   
			e1:SetTarget(c77000423.rsptg) 
			e1:SetOperation(c77000423.rspop) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e1) 
		end 
	end 
end  
function c77000423.rsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c77000423.rspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP) 
	end 
end 






