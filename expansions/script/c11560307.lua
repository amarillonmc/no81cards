--次元的战场勒比卢
function c11560307.initial_effect(c)
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0) 
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_END) 
	e1:SetCondition(c11560307.descon)
	e1:SetOperation(c11560307.desop)
	c:RegisterEffect(e1)  
	--Activate
	local e11=Effect.CreateEffect(c) 
	e11:SetType(EFFECT_TYPE_ACTIVATE) 
	e11:SetCode(EVENT_FREE_CHAIN) 
	e11:SetCountLimit(1,11560307)
	e11:SetTarget(c11560307.rmtg) 
	e11:SetOperation(c11560307.rmop) 
	c:RegisterEffect(e11)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0xff,0xff) 
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)  
	--remove 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_FZONE)   
	e3:SetCountLimit(1,11560307) 
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e3:SetTarget(c11560307.rmtg) 
	e3:SetOperation(c11560307.rmop) 
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetRange(LOCATION_REMOVED) 
	e4:SetCountLimit(1,21560307)  
	e4:SetTarget(c11560307.rthtg)
	e4:SetOperation(c11560307.rthop)
	c:RegisterEffect(e4)
end
c11560307.SetCard_XdMcy=true  
function c11560307.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c11560307.ctfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end 
function c11560307.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	if Duel.IsExistingMatchingCard(c11560307.ctfil,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(6283472,0)) then
	local g=Duel.SelectMatchingCard(tp,c11560307.ctfil,tp,LOCATION_REMOVED,0,1,1,nil) 
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	else Duel.Destroy(c,REASON_COST) end
end
function c11560307.rmfil(c,tp) 
	return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c11560307.thfil,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,nil,c)  
end  
function c11560307.thfil(c,rc) 
	return c.SetCard_XdMcy and c:IsAbleToHand() and not c:IsCode(rc:GetCode())
end 
function c11560307.rmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return Duel.IsExistingMatchingCard(c11560307.rmfil,tp,LOCATION_HAND,0,1,nil,tp) and g:GetCount()==g:FilterCount(Card.IsAbleToRemove,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end 
function c11560307.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c11560307.rmfil,tp,LOCATION_HAND,0,nil,tp)
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst()  
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) 
		local sg=Duel.SelectMatchingCard(tp,c11560307.thfil,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil,tc) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		local xg=Duel.GetDecktopGroup(tp,1)
		if xg:GetCount()==xg:FilterCount(Card.IsAbleToRemove,nil) then 
			Duel.BreakEffect() 
			Duel.Remove(xg,POS_FACEUP,REASON_EFFECT)
		end 
	end 
end 
function c11560307.rgck(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)==1 
	   and g:FilterCount(Card.IsType,nil,TYPE_SPELL)==1 
	   and g:FilterCount(Card.IsType,nil,TYPE_TRAP)==1
end 
function c11560307.rthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeckAsCost,tp,LOCATION_REMOVED,0,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(c11560307.rgck,3,3) and e:GetHandler():CheckActivateEffect(false,true,false)~=nil end 
	local sg=g:SelectSubGroup(tp,c11560307.rgck,false,3,3) 
	Duel.SendtoDeck(sg,nil,2,REASON_COST) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)  
end
function c11560307.rthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end 
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=c:GetActivateEffect()
		local tep=c:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end 
end 









