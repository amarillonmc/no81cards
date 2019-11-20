--夜刀神天香 慵懒
function c33400313.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,c33400313.mfilter,4,2,c33400313.ovfilter,aux.Stringid(33400313,0),2,nil)
	c:EnableReviveLimit()
	 --SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400313,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdogcon)
	e2:SetCost(c33400313.spcost)
	e2:SetTarget(c33400313.sptg)
	e2:SetOperation(c33400313.spop)
	c:RegisterEffect(e2)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400313,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33400313)
	e1:SetCondition(c33400313.condition)
	e1:SetTarget(c33400313.oltg)
	e1:SetOperation(c33400313.olop)
	c:RegisterEffect(e1)
end
function c33400313.mfilter(c)
	return c:IsType(TYPE_RITUAL)
end
function c33400313.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3343) and c:IsType(TYPE_RITUAL)
end
function c33400313.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	  local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function c33400313.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400313.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33400313.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33400313.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c33400313.filter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	local tc=sg:GetFirst()
	while tc do 
	  if  Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP) then
		local c=e:GetHandler()
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
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_DEFENSE)	  
		e4:SetValue(0)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
	  end
	 tc=sg:GetNext()
	 end
	 Duel.SpecialSummonComplete()
end
function c33400313.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==1-tp
end
function c33400313.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33400313.cfilter,1,nil,tp)
end
function c33400313.olfilter(c)
	return c:IsSetCard(0x341)
end
function c33400313.oltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33400313.olfilter(chkc)  end
	if chk==0 then return Duel.IsExistingTarget(c33400313.olfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c33400313.olop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400313,3))
	local g=Duel.SelectMatchingCard(tp,c33400313.olfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then	
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end