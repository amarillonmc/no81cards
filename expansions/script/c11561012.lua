--马纳历亚的双姬 安和古蕾娅
function c11561012.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_ADD_RACE) 
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_DECK) 
	e1:SetValue(RACE_DRAGON) 
	c:RegisterEffect(e1) 
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCondition(c11561012.hspcon)
	e1:SetOperation(c11561012.hspop)
	c:RegisterEffect(e1) 
	--des and rec 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetCountLimit(1,11561012)
	e2:SetTarget(c11561012.desctg) 
	e2:SetOperation(c11561012.descop) 
	c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11561012)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) end) 
	e2:SetTarget(c11561012.desctg) 
	e2:SetOperation(c11561012.descop) 
	c:RegisterEffect(e2) 
	--xx 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_DESTROY) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE)  
	e3:SetTarget(c11561012.xxtg) 
	e3:SetOperation(c11561012.xxop) 
	c:RegisterEffect(e3) 
end
function c11561012.smril(c)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SYNCHRO+TYPE_FUSION+TYPE_XYZ+TYPE_LINK) 
end
function c11561012.rmgck(g,e,tp) 
	return g:FilterCount(Card.IsType,nil,TYPE_FUSION)==1 
	   and g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)==1 
	   and g:FilterCount(Card.IsType,nil,TYPE_XYZ)==1  
	   and g:FilterCount(Card.IsType,nil,TYPE_LINK)==1   
	   and Duel.GetMZoneCount(tp,g)>0   
end 
function c11561012.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c11561012.smril,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:CheckSubGroup(c11561012.rmgck,4,4,e,tp)
end
function c11561012.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c11561012.smril,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil) 
	local sg=g:SelectSubGroup(tp,c11561012.rmgck,false,4,4,e,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c11561012.desctg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000) 
end 
function c11561012.descop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then 
		Duel.Recover(tp,2000,REASON_EFFECT)   
	end 
end 
function c11561012.tdfil(c,tp) 
	if c:IsType(TYPE_FUSION) then 
	return Duel.GetFlagEffect(tp,11561012)==0   
	elseif c:IsType(TYPE_SYNCHRO) then 
	return Duel.GetFlagEffect(tp,21561012)==0 
	elseif c:IsType(TYPE_XYZ) then 
	return Duel.GetFlagEffect(tp,31561012)==0 
	elseif c:IsType(TYPE_LINK) then 
	return Duel.GetFlagEffect(tp,41561012)==0  
	else return false end   
end 
function c11561012.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11561012.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end 
	local tc=Duel.SelectMatchingCard(tp,c11561012.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst() 
	local flag=0 
	if tc:IsType(TYPE_FUSION) then 
		flag=bit.bor(flag,TYPE_FUSION)
		Duel.RegisterFlagEffect(tp,11561012,RESET_PHASE+PHASE_END,0,1)  
	end 
	if tc:IsType(TYPE_SYNCHRO) then 
		flag=bit.bor(flag,TYPE_SYNCHRO)
		Duel.RegisterFlagEffect(tp,21561012,RESET_PHASE+PHASE_END,0,1)  
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
	end  
	if tc:IsType(TYPE_XYZ) then 
		flag=bit.bor(flag,TYPE_XYZ)
		Duel.RegisterFlagEffect(tp,31561012,RESET_PHASE+PHASE_END,0,1)  
	end  
	if tc:IsType(TYPE_LINK) then 
		flag=bit.bor(flag,TYPE_LINK)   
		Duel.RegisterFlagEffect(tp,41561012,RESET_PHASE+PHASE_END,0,1) 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
	end  
	e:SetLabel(flag) 
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)  
end 
function c11561012.espfil(c,e,tp) 
	return c:IsCode(11561010) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0   
end 
function c11561012.spfil(c,e,tp) 
	return c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)  
end 
function c11561012.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local flag=e:GetLabel() 
	if bit.band(flag,TYPE_SYNCHRO)==TYPE_SYNCHRO then 
		if Duel.IsExistingMatchingCard(c11561012.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) then 
			local sc=Duel.SelectMatchingCard(tp,c11561012.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()  
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)  
			sc:CompleteProcedure()  
		end   
	end   
	if bit.band(flag,TYPE_XYZ)==TYPE_XYZ then 
		for i=1,5 do 
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)   
			if g:GetCount()>0 then 
				local tc=g:RandomSelect(tp,1):GetFirst() 
				local pratk=tc:GetAttack() 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE)  
				e1:SetCode(EFFECT_UPDATE_ATTACK) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(-400)  
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
				tc:RegisterEffect(e1)   
				if pratk~=0 and tc:GetAttack()==0 and aux.NegateEffectMonsterFilter(tc) then 
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					c:RegisterEffect(e1)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e2)
					Duel.AdjustInstantly()
					Duel.NegateRelatedChain(tc,RESET_TURN_SET) 
					Duel.Destroy(tc,REASON_EFFECT)  
				end 
			end   
		end 
	end   
	if bit.band(flag,TYPE_FUSION)==TYPE_FUSION then 
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_DIRECT_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			c:RegisterEffect(e1)			
		end 
	end   
	if bit.band(flag,TYPE_LINK)==TYPE_LINK then 
		if Duel.IsExistingMatchingCard(c11561012.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then  
			local sc=Duel.SelectMatchingCard(tp,c11561012.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()  
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)   
		end 
	end   
end 
















