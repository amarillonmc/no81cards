--龙源精灵-太阳龙
function c12057613.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c12057613.mfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(12057613,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12057613)
	e1:SetCondition(c12057613.tgcon)
	e1:SetTarget(c12057613.tgtg)
	e1:SetOperation(c12057613.tgop)
	c:RegisterEffect(e1)
	--pos
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(12057613,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22057613)
	e3:SetTarget(c12057613.postg)
	e3:SetOperation(c12057613.posop)
	c:RegisterEffect(e3) 
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12057613,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,02057613)
	e4:SetTarget(c12057613.sptg2)
	e4:SetOperation(c12057613.spop2)
	c:RegisterEffect(e4)
end
function c12057613.mfilter(c)
	return c:IsLevelAbove(4) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_TUNER)
end
function c12057613.tgfil(c)
	return c:IsAbleToGrave() and c:IsDefenseAbove(2000) and c:IsRace(RACE_DRAGON)
end
function c12057613.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057613.tgfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c12057613.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12057613.tgfil,tp,LOCATION_HAND+LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)  
	end
end
function c12057613.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) or eg:IsContains(e:GetHandler())
end
function c12057613.posfil(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function c12057613.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057613.posfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c12057613.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12057613.posfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c12057613.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) 
end
function c12057613.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057613.spfil,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 and rp==1-tp end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c12057613.spop2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12057613.spfil,tp,LOCATION_REMOVED,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then 
	Duel.BreakEffect()
	Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
	end
end




