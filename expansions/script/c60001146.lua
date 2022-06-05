--钢铁律命“天神”杜拉斯特
function c60001146.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c60001146.mfilter,c60001146.xyzcheck,2,2) 
	--ds and sp 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e0:SetCode(EVENT_PHASE+PHASE_END) 
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,60001146)
	e0:SetCondition(c60001146.dscon) 
	e0:SetOperation(c60001146.dsop) 
	c:RegisterEffect(e0)	 
	--direct 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetTarget(c60001146.dttg) 
	e1:SetOperation(c60001146.dtop)
	c:RegisterEffect(e1) 
	--ov 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c60001146.ovcon) 
	e2:SetOperation(c60001146.ovop) 
	c:RegisterEffect(e2) 
	if not c60001146.global_check then
		c60001146.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING) 
		ge1:SetCondition(c60001146.checkcon)
		ge1:SetOperation(c60001146.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60001146.checkcon(e,tp,eg,ep,ev,re,r,rp) 
	return re:GetHandler():IsRace(RACE_MACHINE)  
end 
function c60001146.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	Duel.RegisterFlagEffect(tc:GetControler(),60001146,RESET_PHASE+PHASE_END,0,1)
end
function c60001146.mfilter(c) 
	return c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_XYZ+TYPE_SYNCHRO)
end
function c60001146.xyzcheck(g) 
	local cls=0 
	if g:IsExists(Card.IsType,1,nil,TYPE_RITUAL) then 
	cls=cls+1 
	end 
	if g:IsExists(Card.IsType,1,nil,TYPE_FUSION) then 
	cls=cls+1 
	end 
	if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) then 
	cls=cls+1 
	end 
	if g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then 
	cls=cls+1 
	end 
	return cls>=2 
end 
function c60001146.mtfil(c,e,tp) 
	return c:IsCanBeXyzMaterial(e:GetHandler())   
end 
function c60001146.gck(g,e,tp) 
	return e:GetHandler():IsXyzSummonable(g) and Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())>0 
end 
function c60001146.dscon(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetMatchingGroup(c60001146.mtfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)  
	return g:CheckSubGroup(c60001146.gck,2,2,e,tp) and Duel.GetFlagEffect(1-tp,60001146)~=0   
end 
function c60001146.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c60001146.mtfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp) 
	if Duel.SelectYesNo(tp,aux.Stringid(60001146,0)) then 
	local sg=g:SelectSubGroup(tp,c60001146.gck,false,2,2,e,tp) 
	Duel.XyzSummon(tp,c,sg) 
	end 
end 
function c60001146.dtcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end 
function c60001146.dttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c60001146.dtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(HALF_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end 
function c60001146.ovfil(c,e,tp) 
	return c:IsPreviousControler(tp) and c:IsCanOverlay()  
end 
function c60001146.ovcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c60001146.ovfil,1,nil,e,tp) 
end  
function c60001146.ovop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local og=eg:Filter(c60001146.ovfil,nil,e,tp) 
	if Duel.SelectYesNo(tp,aux.Stringid(60001146,1)) then 
	local tc=og:Select(tp,1,1,nil) 
	Duel.Overlay(c,tc) 
	Duel.RegisterFlagEffect(tp,60001146,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetFlagEffect(tp,60001146)==0 then 
	local e1=Effect.CreateEffect(c)   
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_END) 
	e1:SetCountLimit(1) 
	e1:SetCondition(c60001146.xthcon) 
	e1:SetOperation(c60001146.xthop) 
	c:RegisterEffect(e1) 
	end  
	end   
end 
function c60001146.xthfil(c) 
	return c:IsAbleToHand() and c:IsRace(RACE_FAIRY) and c:IsLevelBelow(2) 
end 
function c60001146.xthcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c60001146.xthfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,60001146)>=3  
end 
function c60001146.xthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if Duel.SelectYesNo(tp,aux.Stringid(60001146,2)) then 
	Duel.Hint(HINT_CARD,0,60001146)
	local sg=Duel.SelectMatchingCard(tp,c60001146.xthfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.ConfirmCards(1-tp,sg)  
	end 
end  




