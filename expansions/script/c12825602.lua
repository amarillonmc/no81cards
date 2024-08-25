---铳影-朴景丽
Duel.LoadScript("c17035101.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3)
	c:EnableReviveLimit()
	chiki.c4a71Limit(c)
	s.c4a71tohand(c)
	s.c4a71kang(c,s.discon,s.distg,s.disop,CATEGORY_NEGATE,12825602,1131,12825607)
end
function s.c4a71kang(c,con,tg,op,category,cardcode,message,excode)
	local con=con 
	if not con then con=Chikichikibanban.c4a71kangdiscon end
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local cardcode=cardcode 
	local excode=excode
	local category=category 
	if not category then category=CATEGORY_TOHAND+CATEGORY_SEARCH end
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(message)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,cardcode)
	e1:SetCost(s.c4a71kangcost0)
	e1:SetCondition(con)
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1,cardcode+o)
	e2:SetCondition(s.c4a71kangdiscon2)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(Chikichikibanban.sumsuc)
	c:RegisterEffect(e3)
end

function s.c4a71kangdiscon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,12825607) and s.discon(e,tp,eg,ep,ev,re,r,rp) and Duel.GetFlagEffect(tp,id)>0
end
function s.c4a71kangcost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,e:GetHandler():GetCode())==0 or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	if Duel.GetFlagEffect(tp,e:GetHandler():GetCode())==0 then
		Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	else
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetFlagEffect(12825612)>0 
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateActivation(ev)
end
function s.c4a71tohand(c,tg,op,category)
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local category=category 
	if not category then category=CATEGORY_TOHAND end
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1110)
	e1:SetCategory(category)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
end
