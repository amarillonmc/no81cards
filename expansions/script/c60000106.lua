--Org.0000真典·杀星者
function c60000106.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()   
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_XYZ)
	e1:SetCondition(c60000106.sprcon)
	e1:SetOperation(c60000106.sprop)
	c:RegisterEffect(e1)   
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c60000106.thcost)
	e2:SetTarget(c60000106.thtg)
	e2:SetOperation(c60000106.thop)
	c:RegisterEffect(e2) 
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c60000106.actcon)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60000106.actcon1)
	e3:SetOperation(c60000106.actop)
	c:RegisterEffect(e3)
end
function c60000106.sprfilter(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsFaceup() and (lv==9  or (c:IsSetCard(0xa6a1) or c:IsSetCard(0xa6a2) or (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x56a9)))) 
end 
function c60000106.spgckfil(g,e,tp) 
	return Duel.GetLocationCountFromEx(tp,tp,g,nil)
end  
function c60000106.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c60000106.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c60000106.spgckfil,5,5,e,tp)
end
function c60000106.sprop(e,tp,eg,ep,ev,re,r,rp,c) 
	local g=Duel.GetMatchingGroup(c60000106.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=g:SelectSubGroup(tp,c60000106.spgckfil,false,5,5,e,tp)
	c:SetMaterial(g1) 
	Duel.Overlay(c,g1)
end
function c60000106.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60000106.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
end
function c60000106.ckfil(c)
	return not c:IsSetCard(0x36a0)
end
function c60000106.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()<=0 then return end
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	if not c:GetOverlayGroup():IsExists(c60000106.ckfil,1,nil) then 
	Duel.BreakEffect()
	--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)	
	end
end
function c60000106.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and not e:GetHandler():GetOverlayGroup():IsExists(c60000106.ckfil,1,nil)
end
function c60000106.actcon1(e,tp,eg,ep,ev,re,r,rp)
	return  re:GetHandler()==e:GetHandler() and not e:GetHandler():GetOverlayGroup():IsExists(c60000106.ckfil,1,nil) 
end
function c60000106.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60000106)
	Duel.SetChainLimit(c60000106.chainlm)
end
function c60000106.chainlm(e,rp,tp)
	return tp==rp
end






