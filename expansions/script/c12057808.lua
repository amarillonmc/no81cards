--教导的蛇妖 琉莎
function c12057808.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()   
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12057808,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12057808) 
	e1:SetCost(c12057808.spcost)
	e1:SetTarget(c12057808.sptg) 
	e1:SetOperation(c12057808.spop) 
	c:RegisterEffect(e1)
	--indes 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057808,4)) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,22057808) 
	e2:SetCost(c12057808.idcost)
	e2:SetTarget(c12057808.idtg) 
	e2:SetOperation(c12057808.idop) 
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(12057808,ACTIVITY_SPSUMMON,c12057808.counterfilter)
end
function c12057808.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or (c:IsSetCard(0x145) or c:IsSetCard(0x16b))
end
function c12057808.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(12057808,tp,ACTIVITY_SPSUMMON)==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c12057808.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c12057808.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x145) and not c:IsSetCard(0x16b) 
end
function c12057808.spfil(c,e,tp) 
	return c:IsSetCard(0x145,0x16b) and c:IsLevelBelow(6) and (c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function c12057808.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057808.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12057808.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12057808.spfil,tp,LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	local op=3 
	local b1=tc:IsAbleToHand()
	local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(12057808,1),aux.Stringid(12057808,2))
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(12057808,1))
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(12057808,2))+1
	end 
	if op==0 then 
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	elseif op==1 then 
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	end
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c12057808.tgcon)
	e2:SetOperation(c12057808.tgop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c12057808.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x145,0x16b) and c:IsAbleToGrave()
end
function c12057808.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12057808.tgfilter,tp,LOCATION_DECK,0,1,nil)
end
function c12057808.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,12057808)
	local g=Duel.GetMatchingGroup(c12057808.tgfilter,tp,LOCATION_DECK,0,nil) 
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c12057808.idcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(12057808,tp,ACTIVITY_SPSUMMON)==0 and e:GetHandler():IsAbleToRemoveAsCost() end 
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c12057808.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c12057808.idtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c12057808.idop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12057808,5))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c12057808.tgtg)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)   
end
function c12057808.tgtg(e,c)
	return c:IsType(TYPE_SYNCHRO) 
end








