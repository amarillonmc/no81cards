--企鹅物流-大帝
function c79029378.initial_effect(c)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029378,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,79029378+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c79029378.spcost)
	e2:SetTarget(c79029378.sptg)
	e2:SetOperation(c79029378.spop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--ep
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,09029378+EFFECT_COUNT_CODE_DUEL)
	e4:SetCost(c79029378.epcost)
	e4:SetTarget(c79029378.eptg)
	e4:SetOperation(c79029378.epop)
	c:RegisterEffect(e4)
	--kami
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,19029378+EFFECT_COUNT_CODE_DUEL)
	e5:SetCost(c79029378.kacost)
	e5:SetTarget(c79029378.katg)
	e5:SetOperation(c79029378.kaop)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(79029378,ACTIVITY_SPSUMMON,c79029378.counterfilter)
end
function c79029378.counterfilter(c)
	return (c:IsSetCard(0xa900) or c:IsSetCard(0xdd))
end
function c79029378.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(79029378,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79029378,0))
	Duel.SelectOption(tp,aux.Stringid(79029378,1))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(79029378,1))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029378.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029378.splimit(e,c,tp,sumtp,sumpos)
	return not (c:IsSetCard(0xa900) or c:IsSetCard(0xdd))
end
function c79029378.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 and Duel.IsPlayerCanSpecialSummonMonster(tp,89631146,0,0x4011,3000,2500,8,RACE_DRAGON,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0)
end
function c79029378.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local x=3
	local chk=true
	while chk do	
	local token=Duel.CreateToken(tp,89631146)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	x=x-1
	if x<=0 then 
	chk=false
	end
	end
end
function c79029378.epcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79029378,0))
	Duel.SelectOption(tp,aux.Stringid(79029378,2))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(79029378,2))
end
function c79029378.eptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	op=Duel.SelectOption(tp,aux.Stringid(79029378,4),aux.Stringid(79029378,5))
	e:SetLabel(op)
	if op==0 then
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,0)
	else
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,0)
	end
end
function c79029378.epop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then 
	local tc1=Duel.CreateToken(tp,21082832)
	local tc2=Duel.CreateToken(tp,55410871)
	local g=Group.FromCards(tc1,tc2)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	else
	local tc1=Duel.CreateToken(tp,24094653)
	Duel.SendtoHand(tc1,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc1)
	local tc2=Duel.CreateToken(tp,56532353)
	Duel.SendtoDeck(tc2,tp,2,REASON_EFFECT)
	end
end
function c79029378.kacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79029378,0))
	Duel.SelectOption(tp,aux.Stringid(79029378,3))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(79029378,3))
end
function c79029378.katg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 and Duel.IsPlayerCanSpecialSummonMonster(tp,10000000,0,0x4011,4000,4000,12,RACE_DEVINE,ATTRIBUTE_DEVINE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c79029378.kaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local token=Duel.CreateToken(tp,10000000)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(token)
		e1:SetDescription(aux.Stringid(79029378,6))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c79029378.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
end
function c79029378.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end




















