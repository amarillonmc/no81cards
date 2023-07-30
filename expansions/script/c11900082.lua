--妄想的死神
function c11900082.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,11900082)
	e1:SetTarget(c11900082.sptg) 
	e1:SetOperation(c11900082.spop) 
	c:RegisterEffect(e1) 
end 
function c11900082.spfil(c,e,tp) 
	return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsType(TYPE_TUNER) and (c:IsLevelAbove(1) or c:IsRankAbove(1))  
end 
function c11900082.lvrk(c) 
	if c:IsLevelAbove(1) then 
	return c:GetLevel() 
	elseif c:IsRankAbove(1) then 
	return c:GetRank() 
	else return nil end 
end 
function c11900082.spgck(g) 
	return g:GetClassCount(c11900082.lvrk)==g:GetCount() 
	   and g:GetClassCount(Card.GetOriginalRace)==g:GetCount()
	   and g:GetClassCount(Card.GetOriginalAttribute)==g:GetCount()
	   and g:GetClassCount(Card.GetBaseAttack)==g:GetCount()
	   and g:GetClassCount(Card.GetBaseDefense)==g:GetCount()
end 
function c11900082.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11900082.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if chk==0 then return g:CheckSubGroup(c11900082.spgck,2,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) end  
	local sg=g:SelectSubGroup(tp,c11900082.spgck,false,2,2)
	Duel.SetTargetCard(sg) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0) 
end 
function c11900082.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then 
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(11900082,RESET_EVENT+RESETS_STANDARD,0,1)
		tc=g:GetNext() 
		end 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE) 
		g:KeepAlive() 
		e1:SetLabelObject(g) 
		e1:SetCondition(c11900082.rmcon) 
		e1:SetOperation(c11900082.rmop)
		Duel.RegisterEffect(e1,tp)
	end 
end  
function c11900082.rmcon(e,tp,eg,ep,ev,re,r,rp) 
	local g=e:GetLabelObject() 
	return g:FilterCount(function(c) return c:IsOnField() and c:IsFaceup() end,1,nil)~=2 
end 
function c11900082.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local g=e:GetLabelObject() 
	local xg=g:Filter(function(c) return c:GetFlagEffect(11900082)~=0 end,nil)
	Duel.Hint(HINT_CARD,0,11900082) 
	Duel.Remove(xg,POS_FACEUP,REASON_EFFECT) 
	e:Reset()
end 







