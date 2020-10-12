function c82221041.initial_effect(c)
	aux.EnablePendulumAttribute(c) 
	--summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221041,0))  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SUMMON_PROC)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(c82221041.ntcon)  
	c:RegisterEffect(e1)  
	--spsummon  
	local e2=Effect.CreateEffect(c)   
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SUMMON_SUCCESS)  
	e2:SetTarget(c82221041.sptg)  
	e2:SetOperation(c82221041.spop)  
	c:RegisterEffect(e2) 
	--atk down 
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1)  
	e3:SetTarget(c82221041.deftg)  
	e3:SetOperation(c82221041.defop)  
	c:RegisterEffect(e3)  
end  
function c82221041.ntcon(e,c,minc)  
	if c==nil then return true end  
	return minc==0 and c:IsLevelAbove(5)  
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0  
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function c82221041.filter(c,e,tp)  
	return c:GetLevel()<4 and c:IsSetCard(0x9f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c82221041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82221041.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)  
end  
function c82221041.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82221041.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)  
	local tc=g:GetFirst()  
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+0x1fe0000)  
		tc:RegisterEffect(e1,true)  
		local e2=Effect.CreateEffect(e:GetHandler())  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetReset(RESET_EVENT+0x1fe0000)  
		tc:RegisterEffect(e2,true)  
		local e3=Effect.CreateEffect(e:GetHandler())  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)  
		e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
		e3:SetValue(1)  
		e3:SetReset(RESET_EVENT+0x1fe0000)  
		tc:RegisterEffect(e3,true)  
		local e4=Effect.CreateEffect(e:GetHandler())  
		e4:SetType(EFFECT_TYPE_SINGLE)  
		e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e4:SetReset(RESET_EVENT+RESETS_REDIRECT)  
		e4:SetValue(LOCATION_REMOVED)  
		tc:RegisterEffect(e4,true)   
		Duel.SpecialSummonComplete()
	 end  
end  
function c82221041.deftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.nzatk(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)  
end  
function c82221041.defop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local tc=Duel.GetFirstTarget()  
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(-500)   
		if tc:RegisterEffect(e1) then
			Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end  
end  