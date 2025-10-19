--命运再临
function c71500109.initial_effect(c)
	aux.AddSetNameMonsterList(c,0x78f1)
	--act in h
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(71500109,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(c71500109.aihcost)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCost(c71500109.spcost)
	e1:SetTarget(c71500109.sptg)
	e1:SetOperation(c71500109.spop)
	c:RegisterEffect(e1)
	--to deck 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCost(c71500109.tdcost)
	e2:SetTarget(c71500109.tdtg)
	e2:SetOperation(c71500109.tdop)
	c:RegisterEffect(e2)
end
function c71500109.aihcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x78f1,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x78f1,2,REASON_COST) 
end
function c71500109.spfilter(c,e,tp)
	return c:IsCode(71500100) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c71500109.costfilter(c,e,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c71500109.spfilter,tp,LOCATION_HAND,0,1,c,e,tp)
end
function c71500109.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71500109.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c71500109.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c71500109.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71500109.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c71500109.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c71500109.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)
	end 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_CHAIN_END) 
	e1:SetLabel(0)
	e1:SetOperation(c71500109.xtdop1)  
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_END) 
	e1:SetCountLimit(1)  
	e1:SetOperation(c71500109.xtdop2) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
end
function c71500109.xtdop1(e,tp,eg,ep,ev,re,r,rp) 
	if e:GetLabel()==0 then 
		e:SetLabel(1) 
	else 
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,0,nil) 
		Duel.Hint(HINT_CARD,0,71500109)
		if g:GetCount()>0 then  
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end   
		e:Reset() 
	end 
end
function c71500109.xtdop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,0,nil) 
	Duel.Hint(HINT_CARD,0,71500109)
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end 
end
function c71500109.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)  
end
function c71500109.tdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return g:GetCount()>0 end 
end
function c71500109.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then 
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)  
	end 
end 


