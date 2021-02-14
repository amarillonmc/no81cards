local m=15000699
local cm=_G["c"..m]
cm.name="盖理的使徒·拉芒戈"
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,15000699)   
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)
	--spsummon  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetCountLimit(1,15010699)  
	e2:SetCondition(cm.spcon)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)
end
function cm.cfilter(c,race,att)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and bit.band(race,c:GetOriginalRace())==0 and bit.band(att,c:GetOriginalAttribute())==0
end
function cm.tgfilter(c,ft)  
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and ((c:IsLocation(LOCATION_HAND) and ft>0) or c:IsLocation(LOCATION_MZONE))
end 
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local bg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil,e:GetHandler():GetOriginalRace(),e:GetHandler():GetOriginalAttribute())
	return (g:GetCount()==0 or ag:GetCount()==bg:GetCount())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),ft) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not c:IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),ft)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end  
function cm.atkfilter(c)
	return c:IsFaceup() and c:GetRace()~=0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()  
	local tp=e:GetHandler():GetControler()  
	local g=Duel.GetMatchingGroup(cm.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetRace())
		tc=g:GetNext()
	end
	local ct=0
	while att~=0 do
		if bit.band(att,0x1)~=0 then ct=ct+1 end
		att=bit.rshift(att,1)
	end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2+ct end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)  
end  
function cm.thfilter(c,e,tp)  
	return c:IsSetCard(0x3f38) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local tp=e:GetHandler():GetControler() 
	local yg=Duel.GetMatchingGroup(cm.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	local att=0
	local tc=yg:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetRace())
		tc=yg:GetNext()
	end
	local ct=0
	while att~=0 do
		if bit.band(att,0x1)~=0 then ct=ct+1 end
		att=bit.rshift(att,1)
	end
	local count=2+ct
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<count then return end  
	Duel.ConfirmDecktop(tp,count)  
	local g=Duel.GetDecktopGroup(tp,count)  
	ct=g:GetCount()  
	if ct>0 and g:FilterCount(cm.thfilter,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then  
		Duel.DisableShuffleCheck()  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)  
		local sg=g:FilterSelect(tp,cm.thfilter,1,1,nil,e,tp) 
		if sg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not sg:GetFirst():IsAbleToHand() then
			Duel.SpecialSummon(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		end
		if sg:GetFirst():IsAbleToHand() and (Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not sg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)) then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)  
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		if sg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg:GetFirst():IsAbleToHand() then 
			if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.SpecialSummon(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(sg,nil,REASON_EFFECT)  
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			end
		end
		g:RemoveCard(sg:GetFirst()) 
		ct=g:GetCount()
	end  
	if ct>0 then  
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		Duel.ShuffleDeck(tp)  
	end  
end