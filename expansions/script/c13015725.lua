--深海姬的巫女
function c13015725.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCondition(c13015725.hspcon)
	e1:SetOperation(c13015725.hspop) 
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1) 
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)   
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,13015725)
	e1:SetCost(c13015725.cost)
	e1:SetTarget(c13015725.thtg) 
	e1:SetOperation(c13015725.thop) 
	c:RegisterEffect(e1) 
	--remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_PHASE+PHASE_END) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,23015725)
	e2:SetTarget(c13015725.rmtg) 
	e2:SetOperation(c13015725.rmop) 
	c:RegisterEffect(e2)  
end
function c13015725.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_COST)
end
function c13015725.tgfil1(c,e,tp) 
	return c:IsFaceup() and c:IsSummonLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(c13015725.tgfil2,tp,LOCATION_ONFIELD,0,1,c,e,tp) 
end 
function c13015725.tgfil2(c,e,tp) 
	return c:IsFaceup() and c:IsSetCard(0xe01) 
end 
function c13015725.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	return Duel.IsExistingMatchingCard(c13015725.tgfil1,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function c13015725.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sc=Duel.SelectMatchingCard(tp,c13015725.tgfil1,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	local g=Duel.SelectMatchingCard(tp,c13015725.tgfil2,tp,LOCATION_ONFIELD,0,1,1,sc,e,tp)
	g:AddCard(sc) 
	Duel.SendtoGrave(g,REASON_COST) 
end
function c13015725.thfil(c)  
	return c:IsAbleToHand() and c:IsSetCard(0xe01)   
end 
function c13015725.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c13015725.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c13015725.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c13015725.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end  
end 
function c13015725.rmgck(g,tp) 
	return Duel.GetDecktopGroup(tp,g:GetCount()):FilterCount(Card.IsAbleToRemove,nil)==g:GetCount()   
end 
function c13015725.rmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToRemove() and c:IsSetCard(0xe01) end,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c13015725.rmgck,1,5,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end 
function c13015725.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToRemove() and c:IsSetCard(0xe01) end,tp,LOCATION_GRAVE,0,nil) 
	if g:CheckSubGroup(c13015725.rmgck,1,5,tp) then 
		local sg=g:SelectSubGroup(tp,c13015725.rmgck,false,1,5,tp) 
		local x=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT) 
		if x>0 then 
			Duel.BreakEffect()
			local g=Duel.GetDecktopGroup(1-tp,x) 
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)   
		end  
	end 
end
