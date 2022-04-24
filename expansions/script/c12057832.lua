--战源的羽衣
function c12057832.initial_effect(c) 
	--nontuner
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCode(EFFECT_NONTUNER)
	e0:SetValue(c12057832.tnval)
	c:RegisterEffect(e0)   
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_CANNOT_DISABLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_WARRIOR)
	e0:SetRange(0xff)
	c:RegisterEffect(e0) 
	--Equip 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12057832,1))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,12057832)
	e1:SetCondition(c12057832.eqcon)
	e1:SetTarget(c12057832.eqtg)
	e1:SetOperation(c12057832.eqop)
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(12057832,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_REMOVED) 
	e2:SetCountLimit(1,22057832) 
	e2:SetTarget(c12057832.sptg) 
	e2:SetOperation(c12057832.spop)  
	c:RegisterEffect(e2)  
end 
function c12057832.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c12057832.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
end
function c12057832.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsRace,tp,LOCATION_MZONE,0,1,nil,RACE_DRAGON+RACE_WARRIOR) end 
	local g=Duel.SelectTarget(tp,Card.IsRace,tp,LOCATION_MZONE,0,1,1,nil,RACE_DRAGON+RACE_WARRIOR) 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0) 
end
function c12057832.eqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	for i=1,ev do 
	local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) 
	 if tgp~=tp then 
	 local e1=Effect.CreateEffect(c)
	 e1:SetType(EFFECT_TYPE_SINGLE)
	 e1:SetCode(EFFECT_IMMUNE_EFFECT)
	 e1:SetValue(c12057832.efilter)
	 e1:SetLabelObject(te)
	 e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	 e1:SetOwnerPlayer(tp)
	 tc:RegisterEffect(e1)  
	 end 
	end 
	if c:IsRelateToEffect(e) and Duel.Equip(tp,c,tc) then  
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(tc)
	e1:SetValue(c12057832.eqlimit)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()   
	e3:SetCode(EFFECT_UPDATE_DEFENSE) 
	c:RegisterEffect(e3)
	end 
	end 
end
function c12057832.efilter(e,re) 
	return re==e:GetLabelObject()  
end
function c12057832.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c12057832.ckfil(c,e,tp)  
	return c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
end 
function c12057832.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_DRAGON+RACE_WARRIOR) and c:IsLevelBelow(4) 
end 
function c12057832.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return eg:IsExists(c12057832.ckfil,1,nil,e,tp) and Duel.IsExistingMatchingCard(c12057832.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE) 
end  
function c12057832.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c12057832.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if c:IsRelateToEffect(e) and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 then 
	local sg=g:Select(tp,1,1,nil) 
	sg:AddCard(c) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	local tc=sg:GetFirst() 
	while tc do 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c12057832.rmlimit) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057832,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1) 
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	tc:RegisterEffect(e3)
	tc=sg:GetNext() 
	end 
	end 
end 
function c12057832.rmlimit(e,c,tp,r)
	return c==e:GetHandler() and r==REASON_EFFECT
end


