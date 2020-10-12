local m=82208116
local cm=_G["c"..m]
cm.name="辉神兵装 灯影"
function cm.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
 --   c:RegisterEffect(e1) 
	--to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,m+10000)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
  --  c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e3:SetCondition(cm.thcon)  
  --  c:RegisterEffect(e3)
	--cannot attack  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_CANNOT_ATTACK)  
	c:RegisterEffect(e4)  
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return not re:GetHandler():IsSetCard(0x29e)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
		end   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		--disable field  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_FIELD)   
		e1:SetCode(EFFECT_DISABLE_FIELD) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(cm.disop)  
		e1:SetProperty(EFFECT_FLAG_REPEAT)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)  
	end
end
function cm.disfilter(c,seq)
	return c:GetSequence()==seq or (((seq==1 and c:GetSequence()==5) or (seq==3 and c:GetSequence()==6)) and c:IsLocation(LOCATION_MZONE))
end
function cm.disop(e,tp)  
	local c=e:GetHandler()
	local zone=0x1f1f0000
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local tc=g:GetFirst()
	if g:IsExists(cm.disfilter,1,nil,0) then
		zone=zone-0x10100000
	end
	if g:IsExists(cm.disfilter,1,nil,1) then
		zone=zone-0x8080000
	end
	if g:IsExists(cm.disfilter,1,nil,2) then
		zone=zone-0x4040000
	end
	if g:IsExists(cm.disfilter,1,nil,3) then
		zone=zone-0x2020000
	end
	if g:IsExists(cm.disfilter,1,nil,4) then
		zone=zone-0x1010000
	end
	local sg=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_ONFIELD,nil,tp)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_RULE,1-tp)
	end
	return zone
end  
function cm.tgfilter(c,tp) 
	if c:GetColumnGroup():IsExists(Card.IsControler,1,nil,tp) then return false end
	return c:IsAbleToGrave() and c:GetSequence()<5 
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x29e) and c:IsType(TYPE_MONSTER) and not c:IsCode(m) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)  
	local ct=c:GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)  
	if c:IsControler(1-tp) then ct=ct+1 end  
	if chk==0 then return c:IsRelateToEffect(e) and ct>0 and g:GetClassCount(Card.GetCode)>=ct end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)  
	local ct=c:GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)  
	if c:IsControler(1-tp) then ct=ct+1 end  
	if ct<=0 or g:GetClassCount(Card.GetCode)<ct then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local hg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)  
	Duel.SendtoHand(hg,nil,REASON_EFFECT)  
	Duel.ConfirmCards(1-tp,hg)  
end   