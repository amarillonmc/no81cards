--破碎世界的节制
function c6160201.initial_effect(c)
	  --fusion material  
	aux.AddFusionProcFun2(c,c6160201.mfilter1,c6160201.mfilter2,true)  
	c:EnableReviveLimit()  
	--banish 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160201,0))  
	e1:SetCategory(CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,6160201)  
	e1:SetCondition(c6160201.rmcon)  
	e1:SetTarget(c6160201.rmtg)  
	e1:SetOperation(c6160201.rmop)  
	c:RegisterEffect(e1) 
	 --spsummon  
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e3:SetCode(EVENT_TO_GRAVE)  
	e3:SetCountLimit(1,6160201)  
	e3:SetCondition(c6160201.spcon)  
	e3:SetTarget(c6160201.sptg)  
	e3:SetOperation(c6160201.spop)  
	c:RegisterEffect(e3)	
end
function c6160201.mfilter1(c)  
	return c:IsFusionSetCard(0x616)  
end  
function c6160201.mfilter2(c)  
	return c:IsRace(RACE_SPELLCASTER)  
end  
function c6160201.rmcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)  
end  
function c6160201.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,2,2,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
end
function c6160201.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function c6160201.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)  
end  
function c6160201.filter(c,e,tp)  
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c6160201.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c6160201.filter(chkc,e,tp) and chkc~=e:GetHandler() end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(c6160201.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,c6160201.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function c6160201.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e2)  
	end  
	Duel.SpecialSummonComplete()  
end  