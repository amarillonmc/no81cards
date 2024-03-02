-- ～至点的序曲～ / ～Preludio al Solstizio～
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_HAND_LIMIT)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTargetRange(1,0)
		ge1:SetCondition(s.econ)
		ge1:SetValue(100)
		Duel.RegisterEffect(ge1,0)
		Duel.RegisterEffect(ge1,1)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_CANNOT_TO_HAND)
		ge2:SetTargetRange(LOCATION_DECK,0)
		ge2:SetCondition(s.econ)
		Duel.RegisterEffect(ge2,0)
		Duel.RegisterEffect(ge2,1)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD)
		ge3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge3:SetCode(EFFECT_CANNOT_DRAW)
		ge3:SetCondition(s.econ)
		ge3:SetTargetRange(1,0)
		Duel.RegisterEffect(ge3,0)
		Duel.RegisterEffect(ge3,1)
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD)
		ge5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge5:SetCode(EFFECT_DRAW_COUNT)
		ge5:SetTargetRange(1,0)
		ge5:SetCondition(s.econ)
		ge5:SetValue(0)
		Duel.RegisterEffect(ge5,0)
		Duel.RegisterEffect(ge5,1)
		local ge4=Effect.CreateEffect(c)
		ge4:SetDescription(aux.Stringid(id,1))
		ge4:SetType(EFFECT_TYPE_FIELD)
		ge4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		ge4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		ge4:SetTargetRange(1,0)
		ge4:SetCondition(s.econ)
		ge4:SetTarget(s.sumlimit)
		Duel.RegisterEffect(ge4,0)
		Duel.RegisterEffect(ge4,1)
	end
end
function s.public(c)
	return c:IsPublic() and c:GetFlagEffect(id)>0
end
function s.econ(e)
	return Duel.IsExistingMatchingCard(s.public,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end

function s.matchtype(c,typ)
	if typ==TYPE_SPELL or typ==TYPE_TRAP then
		return c:GetType()==typ
	else
		return c:GetType()&typ==typ
	end
end

s.thchecks=aux.CreateChecks(s.matchtype,{TYPE_NORMAL+TYPE_MONSTER,TYPE_EFFECT+TYPE_MONSTER,TYPE_PENDULUM+TYPE_MONSTER,TYPE_SPELL,TYPE_CONTINUOUS+TYPE_SPELL,TYPE_EQUIP+TYPE_SPELL,TYPE_FIELD+TYPE_SPELL,
										 TYPE_RITUAL+TYPE_SPELL,TYPE_QUICKPLAY+TYPE_SPELL,TYPE_TRAP,TYPE_CONTINUOUS+TYPE_TRAP,TYPE_COUNTER+TYPE_TRAP})


function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and #g>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
end
function s.fgoal(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #rg>=12 and rg:CheckSubGroupEach(s.thchecks,s.fgoal) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,12,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local rg=g:SelectSubGroupEach(tp,s.thchecks,false,s.fgoal)
	if rg and rg:GetCount()==12 and Duel.SendtoHand(rg,nil,REASON_EFFECT)~=0 and rg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
		local sg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		end
	end
end
