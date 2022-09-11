--俱舍怒威族 奥德赛 
if not aux.tz_qh_qechk then
	aux.tz_qh_qechk=true
	_rge=Card.RegisterEffect 
	function Card.RegisterEffect(c,ie,ob) --ReplaceEffect   
		local b=ob or false  
		if not (c:IsRank(7) and c:IsType(TYPE_XYZ))
			or not (ie:IsHasType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)) then
			return _rge(c,ie,b) 
		end  
		local n1=_rge(c,ie,b) 
		local qe=ie:Clone() 
		if ie:GetCondition() then  
			local con=ie:GetCondition()  
			qe:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)   
				return e:GetHandler():IsLocation(LOCATION_MZONE) and Duel.IsPlayerAffectedByEffect(tp,34433000)
					and con(e,1-tp,eg,ep,ev,re,r,rp) 
				end)
		else	
			qe:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)  
			return e:GetHandler():IsLocation(LOCATION_MZONE) and Duel.IsPlayerAffectedByEffect(tp,34433000) end)
		end
		local n2=_rge(c,qe,b)
		return n1,n2
	end
end
function c34433000.initial_effect(c) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c34433000.spcon)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)   
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,34433000) 
	e2:SetTarget(c34433000.thtg) 
	e2:SetOperation(c34433000.thop) 
	c:RegisterEffect(e2)  
	--TTT
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(34433000)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
end  
function c34433000.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c34433000.thfil(c)
	return c:IsSetCard(0x189) and c:IsAbleToHand()
end
function c34433000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==1-tp and Duel.IsExistingMatchingCard(c34433000.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c34433000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c34433000.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end






