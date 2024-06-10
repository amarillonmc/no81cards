--星海航线 空元行者
function c11560720.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c11560720.mfilter,c11560720.xyzcheck,2,99)   
	--xx
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetValue(RACE_SPELLCASTER)
	c:RegisterEffect(e0) 
	--ov	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11560720.ovcon) 
	e1:SetOperation(c11560720.ovop) 
	c:RegisterEffect(e1)
	--def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,c)
	return c:GetOverlayCount()*400 end)
	c:RegisterEffect(e1) 
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval) 
	e2:SetCondition(function(e) 
	local seq=e:GetHandler():GetSequence()
	return seq==0 or seq==1 end)
	c:RegisterEffect(e2)
	--ov	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11560720.xovcon) 
	e2:SetOperation(c11560720.xovop) 
	c:RegisterEffect(e2)
	--r d
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11560720.rdcon) 
	e2:SetOperation(c11560720.rdop) 
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,11560720+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c11560720.spcon)
	e3:SetTarget(c11560720.sptg)
	e3:SetOperation(c11560720.spop)
	c:RegisterEffect(e3)
end
c11560720.SetCard_SR_Saier=true
function c11560720.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,1)
end
function c11560720.xyzcheck(g)
	return g:GetClassCount(Card.GetRace)==g:GetCount() and g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function c11560720.ovfil(c,tp) 
	return c:IsType(TYPE_MONSTER) and c:IsControler(1-tp)
end 
function c11560720.ovcon(e,tp,eg,ep,ev,re,r,rp) 
	local g=eg:Filter(c11560720.ovfil,nil,tp)
	return g:GetCount()>0 and e:GetHandler():IsType(TYPE_XYZ) and r&0x20000==0
end 
function c11560720.ovop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=eg:Filter(c11560720.ovfil,nil,tp)
	if g:GetCount()>0 and c:IsType(TYPE_XYZ) then 
		Duel.Hint(HINT_CARD,0,11560720)  
		local tc=g:GetFirst() 
		while tc do 
		local og=tc:GetOverlayGroup()
		local oc=Duel.GetFieldGroup(tp,LOCATION_DECK,LOCATION_DECK):GetFirst()
		if og:GetCount()>0 then
			--Duel.SendtoGrave(og,REASON_RULE+REASON_RETURN)
			if oc then
				Duel.Overlay(oc,og)
			else
				Duel.Overlay(c,og)
			end
		end 
		Duel.Overlay(c,tc)
		tc=g:GetNext() 
		end 
		if c:GetSequence()==2 then 
			c11560720.xovop(e,tp,eg,ep,ev,re,r,rp) 
		end 
		if c:GetSequence()==3 or c:GetSequence()==4 then 
			c11560720.rdop(e,tp,eg,ep,ev,re,r,rp) 
		end 
	end 
end  
function c11560720.xovfil(c) 
	return c:IsCanOverlay() and c:IsType(TYPE_XYZ) and c:IsFaceup() and c:GetOverlayCount()==0 
end 
function c11560720.xovcon(e,tp,eg,ep,ev,re,r,rp) 
	local seq=e:GetHandler():GetSequence()
	local g1=Duel.GetMatchingGroup(c11560720.xovfil,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetOverlayGroup(tp,0,1) 
	g1:Merge(g2)
	return re:GetHandler()==e:GetHandler() and e:GetHandler():IsType(TYPE_XYZ) and g1:GetCount()>0 and seq==2 
end 
function c11560720.xovop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(c11560720.xovfil,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetOverlayGroup(tp,0,1) 
	g1:Merge(g2)
	if g1:GetCount()>0 and c:IsType(TYPE_XYZ) then 
		Duel.Hint(HINT_CARD,0,11560720)  
		local xoc=g1:Select(tp,1,1,nil):GetFirst() 
		local oc=xoc:GetOverlayTarget()
		Duel.Overlay(c,xoc) 
		if oc then 
			Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
			Duel.RaiseEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0) 
		end 
	end 
end  
function c11560720.rdcon(e,tp,eg,ep,ev,re,r,rp) 
	local seq=e:GetHandler():GetSequence() 
	return re:GetHandler()==e:GetHandler() and (seq==3 or seq==4) 
end 
function c11560720.rdop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()  
	Duel.Hint(HINT_CARD,0,11560720)  
	Duel.Damage(1-tp,400,REASON_EFFECT) 
	Duel.Recover(tp,400,REASON_EFFECT)
end 
function c11560720.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()>0 and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp) 
end
function c11560720.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end
function c11560720.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE) 
		e1:SetCountLimit(1) 
		e1:SetOperation(c11560720.rmop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1) 
	end
end
function c11560720.rmop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()  
	Duel.Hint(HINT_CARD,0,11560720)  
	local og=c:GetOverlayGroup() 
	if og:GetCount()>0 and og:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)==og:GetCount() and Duel.Remove(og,POS_FACEDOWN,REASON_EFFECT)~=0 then 
	else 
		Duel.Destroy(c,REASON_EFFECT) 
	end 
end 





