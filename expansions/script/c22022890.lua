--白骸龙 阿尔比恩
function c22022890.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),10,3)
	c:EnableReviveLimit() 
	--limit 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end) 
	e1:SetOperation(c22022890.limop) 
	c:RegisterEffect(e1) 
	--multi attack
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1) 
	e2:SetCondition(c22022890.mtcon)
	e2:SetOperation(c22022890.mtop)
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE) 
	e3:SetCountLimit(1,22022890) 
	e3:SetTarget(c22022890.sptg) 
	e3:SetOperation(c22022890.spop) 
	c:RegisterEffect(e3)
end
function c22022890.limop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1) 
	e1:SetValue(function(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttackBelow(3900) end) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
end 
function c22022890.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
end
function c22022890.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:Filter(Card.IsType,nil,TYPE_MONSTER):FilterCount(Card.IsSetCard,nil,0xff1)
	Duel.ShuffleDeck(tp)
	if ct>1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct-1)
		c:RegisterEffect(e1)
	elseif ct==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(HALF_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22022890.mgck(g,e,tp) 
	if g:GetCount()==1 then 
	return g:IsExists(Card.IsCode,1,nil,22022850)  
	elseif g:GetCount()==2 then 
	return g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)==2  
	else return false end 
end 
function c22022890.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(function(c,e) return c:IsFaceup() and (c:IsType(TYPE_SYNCHRO) or c:IsCode(22022850)) and c:IsCanBeEffectTarget(e) end,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(c22022890.mgck,1,2,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local mg=g:SelectSubGroup(tp,c22022890.mgck,false,1,2,e,tp) 
	Duel.SetTargetCard(mg) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c22022890.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetCount()>0 then 
		Duel.Overlay(c,g) 
	end 
end 








