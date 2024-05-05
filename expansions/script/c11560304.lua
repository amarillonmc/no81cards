--次元反叛者 巴隆
function c11560304.initial_effect(c)
	c:EnableReviveLimit()
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0) 
	--cannot special summon
	--local e1=Effect.CreateEffect(c)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	--e1:SetValue(aux.ritlimit)
	--c:RegisterEffect(e1)  
	--SpecialSummon
	local e2=Effect.CreateEffect(c)   
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY)   
	e2:SetTarget(c11560304.sptg)  
	e2:SetOperation(c11560304.spop) 
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,11560304)
	e4:SetTarget(c11560304.rthtg)
	e4:SetOperation(c11560304.rthop)
	c:RegisterEffect(e4)
end
c11560304.SetCard_XdMcy=true 
function c11560304.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local gc=g:GetCount()
	if chk==0 then return gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc and Duel.IsPlayerCanDraw(tp) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,gc,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,gc) 
end 
function c11560304.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local gc=g:GetCount()
	if gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc then
		local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if oc>0 then
		Duel.Draw(tp,oc,REASON_EFFECT) 
		local xg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,10,nil) and xg:GetCount()>0 and Duel.IsPlayerCanDraw(1-tp) then 
		local x=Duel.SendtoGrave(xg,REASON_EFFECT+REASON_DISCARD) 
		Duel.Draw(1-tp,x,REASON_EFFECT)
		end 
		end
	end
end
function c11560304.rthfil(c)
	return c.SetCard_XdMcy and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11560304.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11560304.rthfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11560304.rthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11560304.rthfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end









