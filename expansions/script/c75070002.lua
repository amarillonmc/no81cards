--幻想异闻录#FE “天马骑士”闪耀☆偶像
function c75070002.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c75070002.lcheck)
	c:EnableReviveLimit() 
	--lock 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(c75070002.lktg) 
	e1:SetOperation(c75070002.lkop) 
	c:RegisterEffect(e1)	
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetValue(1)
	c:RegisterEffect(e2) 
	--to ex and sp 
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1) 
	e3:SetTarget(c75070002.tesptg) 
	e3:SetOperation(c75070002.tespop) 
	c:RegisterEffect(e3)  
end 
function c75070002.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_LIGHT) 
end 
function c75070002.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetChainLimit(c75070002.chlimit)
end
function c75070002.chlimit(e,ep,tp)
	return not e:IsActiveType(TYPE_MONSTER) 
end
function c75070002.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	--lock 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_ONFIELD+LOCATION_GRAVE)) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_DECK) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(function(e,c) 
	return c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and not c:IsExtraDeckMonster() end) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
end 
function c75070002.spfil(c,e,tp) 
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end 
function c75070002.tesptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local mg=e:GetHandler():GetMaterial()
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and mg:IsExists(c75070002.spfil,1,nil,e,tp) and Duel.GetMZoneCount(tp,e:GetHandler())>0 end 
	local tc=mg:FilterSelect(tp,c75070002.spfil,1,1,nil,e,tp) 
	Duel.SetTargetCard(tc) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end 
function c75070002.tespop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 






