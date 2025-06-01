--魔法少女 巴麻美
function c60151902.initial_effect(c)
	c:SetUniqueOnField(1,0,60151902)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c60151902.mfilter,nil,1,1)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60151902.regcon)
	e1:SetOperation(c60151902.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c60151902.splimit)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c60151902.e1tg)
	c:RegisterEffect(e3)
	--pendulum set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60151902,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCondition(c60151902.e2con)
	e4:SetTarget(c60151902.e2tg)
	e4:SetOperation(c60151902.e2op)
	c:RegisterEffect(e4)
	--SEARCH
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60151902,3))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c60151902.e3tg)
	e5:SetOperation(c60151902.e3op)
	c:RegisterEffect(e5)
	if not c60151902.global_check then
		c60151902.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c60151902.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c60151902.mfilter(c)
	return Duel.GetFlagEffect(c:GetControler(),60151902)==0 and c:IsCode(60151901)
end
function c60151902.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c60151902.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60151902.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c60151902.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsCode(60151902)
end
function c60151902.splimit(e,se,sp,st,spos,tgp)
	return bit.band(st,SUMMON_TYPE_XYZ)~=SUMMON_TYPE_XYZ or Duel.GetFlagEffect(tgp,60151902)==0
end
function c60151902.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if not tc:IsCode(60151902) and tc:GetSummonLocation()==LOCATION_EXTRA then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,60151902,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,60151902,RESET_PHASE+PHASE_END,0,1) end
end
function c60151902.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local dam=Duel.GetBattleDamage(tp)
	if chk==0 then return c:IsFaceup() and c:IsReason(REASON_BATTLE) and c:IsAttackPos() 
		and not c:IsReason(REASON_REPLACE) end
	if dam>=0 then
		Duel.Hint(HINT_CARD,0,60151902)
		Duel.SetLP(tp,Duel.GetLP(tp)-dam)
		return true
	else return false end
end
function c60151902.e2con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function c60151902.e2tgf(c)
	return c:IsSetCard(0xab26) and not c:IsForbidden() and c:IsFacedown()
end
function c60151902.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) 
		and Duel.IsExistingMatchingCard(c60151902.e2tgf,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151902.e2op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c60151902.e2tgf,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		Duel.SetLP(tp,Duel.GetLP(tp)-500)
	end
end
function c60151902.thfilter(c)
	return (c:IsSetCard(0x6b26) or c:IsSetCard(0x9b26)) and c:IsAbleToHand()
end
function c60151902.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151902.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151902.e3op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60151902.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.SetLP(tp,Duel.GetLP(tp)-1000)
	end
end
