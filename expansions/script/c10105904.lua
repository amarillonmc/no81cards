--虫融姬战国·芦牛角丸
function c10105904.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetRange(LOCATION_DECK) 
	e1:SetCondition(c10105904.dspcon) 
	e1:SetOperation(c10105904.dspop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10105904) 
	e2:SetCost(c10105904.thcost)
	e2:SetTarget(c10105904.thtg)
	e2:SetOperation(c10105904.thop)
	c:RegisterEffect(e2) 
	--race 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE) 
	e3:SetCode(EFFECT_ADD_RACE)  
	e3:SetValue(RACE_BEAST)
	e3:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_MZONE) end)
	c:RegisterEffect(e3) 
	--negate
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,20105904)
	e4:SetCondition(c10105904.discon)
	e4:SetCost(c10105904.discost)
	e4:SetTarget(c10105904.distg)
	e4:SetOperation(c10105904.disop)
	c:RegisterEffect(e4)
end
function c10105904.dsck(c) 
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x8cdd)   
end 
function c10105904.dspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10105904.dsck,1,nil) and Duel.GetFlagEffect(tp,10105904)==0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0   
end 
function c10105904.dspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,10105904)==0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(10105904,0)) then 
		Duel.RegisterFlagEffect(tp,10105904,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,10105904)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end
function c10105904.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end 
function c10105904.thfil1(c,e,tp)
	return c:IsAbleToHand() and c:IsSetCard(0x8cdd) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c10105904.thfil2,tp,LOCATION_DECK,0,1,c)
end
function c10105904.thfil2(c,e,tp)
	return c:IsAbleToHand() and c:IsLevelBelow(4) and c:IsRace(RACE_INSECT)
end
function c10105904.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105904.thfil1,tp,LOCATION_DECK,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK) 
end
function c10105904.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.SelectMatchingCard(tp,c10105904.thfil1,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc1 then  
		local tc2=Duel.SelectMatchingCard(tp,c10105904.thfil2,tp,LOCATION_DECK,0,1,1,c):GetFirst()  
		local sg=Group.FromCards(tc1,tc2)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end 
end
function c10105904.fckfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x8cdd) and c:IsType(TYPE_FUSION) 
end 
function c10105904.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex,g,gc,dp,dv=Duel.GetOperationInfo(ev,CATEGORY_TOHAND) 
	local b1=re:IsHasCategory(CATEGORY_SEARCH) 
	local b2=re:IsHasCategory(CATEGORY_DRAW) 
	local b3=ex and bit.band(dv,LOCATION_DECK)==LOCATION_DECK 
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and (b1 or b2 or b3) and Duel.IsExistingMatchingCard(c10105904.fckfil,tp,LOCATION_MZONE,0,1,nil)
end
function c10105904.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST) 
end
function c10105904.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_HAND)
end
function c10105904.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_HAND,1,1,nil):GetFirst()
	if tc then 
		Duel.Destroy(tc,REASON_EFFECT) 
	end 
end



