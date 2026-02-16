--被遗忘的研究 星·陨
function c4348050.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,c4348050.lcheck)
	c:EnableReviveLimit()  
	--special summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(4348050)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	c:RegisterEffect(e1) 
	--dd
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,4348050)  
	e2:SetTarget(c4348050.ddtg) 
	e2:SetOperation(c4348050.ddop)  
	c:RegisterEffect(e2) 
	--Special Summon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,4348051)
	e3:SetCondition(c4348050.spcon)
	e3:SetTarget(c4348050.sptg)
	e3:SetOperation(c4348050.spop) 
	c:RegisterEffect(e3)
end
function c4348050.lcheck(g)
	return g:IsExists(function(c) return c:IsLinkSetCard(0x3f13) and c:IsLinkType(TYPE_PENDULUM) end,1,nil)
end 
function c4348050.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end  
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,nil) end 
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,1000)  
end
function c4348050.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then 
		Duel.Damage(1-tp,1000,REASON_EFFECT) 
	end 
end 
function c4348050.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 
end
function c4348050.spfilter(c,e,tp)
	return c:IsCode(4348040) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4348050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c4348050.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c4348050.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c4348050.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true) 
		Duel.SpecialSummonComplete() 
	end
end 








