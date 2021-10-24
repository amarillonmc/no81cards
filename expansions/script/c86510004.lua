--龙嫁
function c86510004.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WIND),3) 
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,86510004)
	e1:SetTarget(c86510004.thtg)
	e1:SetOperation(c86510004.thop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,16510004)
	e2:SetTarget(c86510004.sptg)
	e2:SetOperation(c86510004.spop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c86510004.drtg)
	e3:SetOperation(c86510004.drop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(86510004,ACTIVITY_SPSUMMON,c86510004.counterfilter)
end
function c86510004.counterfilter(c)
	return not c:IsRace(RACE_DRAGON) and not c:IsAttribute(ATTRIBUTE_WATER)
end
function c86510004.ckfil(c)
	return not c:IsType(TYPE_LINK) 
end
function c86510004.thfil(c)
	return c:IsAbleToHand() and (c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_DRAGON)) 
end
function c86510004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial() 
	local x=mg:FilterCount(c86510004.ckfil,nil)
	if chk==0 then return Duel.GetCustomActivityCount(86510004,tp,ACTIVITY_SPSUMMON)==0 and c:IsSummonType(SUMMON_TYPE_LINK) and x>0 and Duel.IsExistingMatchingCard(c86510004.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c86510004.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial() 
	local x=mg:FilterCount(c86510004.ckfil,nil)   
	local g=Duel.GetMatchingGroup(c86510004.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,x,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end
end
function c86510004.ckkfil(c,tp)
	return c:GetSummonPlayer()==tp and c:GetSummonLocation()==LOCATION_EXTRA and c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) 
end
function c86510004.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_DRAGON) 
end
function c86510004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c86510004.ckkfil,1,nil,tp) and Duel.IsExistingMatchingCard(c86510004.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c86510004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c86510004.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c86510004.drfil(c)  
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND) 
end
function c86510004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c86510004.drfil,tp,LOCATION_MZONE,0,1,nil,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c86510004.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end



