--炽金战兽 奥斯米
local m=82209162
local cm=c82209162
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
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,3))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetCountLimit(1,m)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con1)
	e1:SetCost(cm.spcost)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
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
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not cm.con2(e,tp,eg,ep,ev,re,r,rp)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRace(RACE_BEAST)
end
function cm.cfilter(c,tp)
	return c:IsSetCard(0x5294) and c:IsRace(RACE_MACHINE) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,tp) end 
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,tp)  
	e:SetLabelObject(g:GetFirst())  
	Duel.Release(g,REASON_COST)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x5294) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local exc=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) and chkc~=exc end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,exc,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,exc,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)  
	end  
end  