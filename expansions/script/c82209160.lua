--炽金战兽 洛迪
local m=82209160
local cm=c82209160
function cm.initial_effect(c)
	--common spsummon effect  
	local e0=Effect.CreateEffect(c)  
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e0:SetCode(EVENT_TO_GRAVE)  
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e0:SetCondition(cm.cmcon)  
	e0:SetTarget(cm.cmtg)  
	e0:SetOperation(cm.cmop)  
	c:RegisterEffect(e0) 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
	--spsummon 2
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,4))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,m+10000)  
	e2:SetTarget(cm.sptg2)  
	e2:SetOperation(cm.spop2)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e3)  
end

--common
function cm.cmcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	return c:IsPreviousLocation(LOCATION_MZONE) 
			and bit.band(c:GetPreviousRaceOnField(),RACE_MACHINE)~=0 
			and c:IsPreviousPosition(POS_FACEUP) 
			and rp==1-tp and c:GetPreviousControler()==tp
end  
function cm.cmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.cmop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then 
			--change race
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,0))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(RACE_BEAST)
			c:RegisterEffect(e1)
			--change base attack
			local atk=c:GetBaseAttack()
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(m,1))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e2:SetValue(atk*2)
			c:RegisterEffect(e2)
			--redirect
			local e3=Effect.CreateEffect(c)  
			e3:SetDescription(aux.Stringid(m,2))
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetType(EFFECT_TYPE_SINGLE)  
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)  
			e3:SetValue(LOCATION_DECKBOT)  
			c:RegisterEffect(e3)  
			Duel.SpecialSummonComplete()
		end
	end  
end  

--spsummon
function cm.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:GetSummonLocation()==LOCATION_GRAVE 
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end

--spsummon 2
function cm.spfilter2(c,e,tp)  
	return c:IsSetCard(0x5294) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  