--战源的人型杀手
function c12057831.initial_effect(c) 
	--nontuner
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCode(EFFECT_NONTUNER)
	e0:SetValue(c12057831.tnval)
	c:RegisterEffect(e0)  
	--sp and pos 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,12057831)  
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c12057831.sptg) 
	e1:SetOperation(c12057831.spop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_REMOVE) 
	c:RegisterEffect(e2)
	--pos 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_TODECK) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,22057831) 
	e3:SetTarget(c12057831.pstg) 
	e3:SetOperation(c12057831.psop) 
	c:RegisterEffect(e3) 
end
function c12057831.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c12057831.spfilter(c,e,tp)
	return c:IsSetCard(0xac2,0x3ac1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and not c:IsCode(12057831)
end 
function c12057831.cpfil(c) 
	return c:IsCanChangePosition() 
end 
function c12057831.ckfil(c,e,tp) 
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT) and c:IsType(TYPE_MONSTER) 
end 
function c12057831.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12057831.ckfil,1,nil,e,tp) and Duel.IsExistingMatchingCard(c12057831.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,LOCATION_MZONE)
end
function c12057831.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
	local g=Duel.SelectMatchingCard(tp,c12057831.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) 
	Duel.ConfirmCards(1-tp,g) 
	local g1=Duel.GetMatchingGroup(c12057831.cpfil,tp,LOCATION_MZONE,0,nil) 
	if g1:GetCount()<=0 then return end 
	Duel.BreakEffect() 
	local sc=g1:Select(tp,1,1,nil):GetFirst() 
	local op=3 
	local ad=0 
	local dd=0 
	if sc:IsPosition(POS_FACEUP_DEFENSE+POS_FACEDOWN_ATTACK) then 
	op=Duel.SelectOption(tp,aux.Stringid(12057827,1),aux.Stringid(12057827,2)) 
	if op==0 then 
	ad=POS_FACEDOWN_DEFENSE 
	du=POS_FACEDOWN_DEFENSE   
	else 
	ad=POS_FACEUP_ATTACK 
	du=POS_FACEUP_ATTACK   
	end 
	end 
	if op==3 then 
	ad=POS_FACEDOWN_ATTACK 
	du=POS_FACEUP_DEFENSE 
	end 
	Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE,ad,du,POS_FACEUP_ATTACK)
	end
end
function c12057831.xcpfil(c) 
	return c:IsCanChangePosition() and c:IsFaceup()
end 
function c12057831.pstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingTarget(c12057831.xcpfil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c12057831.cpfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0) 
end 
function c12057831.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then 
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT) 
	local op=3 
	local ad=0 
	local dd=0 
	if tc:IsPosition(POS_FACEUP_DEFENSE+POS_FACEDOWN_ATTACK) then 
	op=Duel.SelectOption(tp,aux.Stringid(12057827,1),aux.Stringid(12057827,2)) 
	if op==0 then 
	ad=POS_FACEDOWN_DEFENSE  
	du=POS_FACEDOWN_DEFENSE   
	else 
	ad=POS_FACEUP_ATTACK 
	du=POS_FACEUP_ATTACK   
	end 
	end 
	if op==3 then 
	ad=POS_FACEDOWN_ATTACK 
	du=POS_FACEUP_DEFENSE 
	end 
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE,ad,du,POS_FACEUP_ATTACK)
	end 
end 




