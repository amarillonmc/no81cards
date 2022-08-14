--依存之心罪·匹诺曹
function c29010413.initial_effect(c)
	--sp 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010413,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c29010413.spcon)
	e1:SetTarget(c29010413.sptg)
	e1:SetOperation(c29010413.spop)
	c:RegisterEffect(e1) 
	--th 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29010413,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c29010413.thcon)
	e2:SetTarget(c29010413.thtg)
	e2:SetOperation(c29010413.thop)
	c:RegisterEffect(e2)   
	c29010413.battle_effect=e2
end
function c29010413.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsSetCard(0x7a1) and not c:IsSetCard(0x47a1)
end
function c29010413.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end
function c29010413.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end 
end 
function c29010413.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c29010413.thfil(c,tp) 
	return c:IsSetCard(0x7a1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,c:GetCode()) 
end 
function c29010413.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29010413.thfil,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_GRAVE)  
end 
function c29010413.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29010413.thfil,tp,LOCATION_GRAVE,0,nil,tp)
	if g:GetCount()<=0 then return end 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
end 



