--战吼斗士·戴娜玛刻
local s,id,o=GetID()
function s.initial_effect(c)
	--record
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_BATTLE_PHASE+TIMING_BATTLE_END,TIMING_BATTLE_PHASE+TIMING_BATTLE_END)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.spcost)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_CONFIRM)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.filter(c)
	return c:IsSetCard(0x15f) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		table_effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect and bit.band(effect:GetType(),EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)==EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O and effect:GetCode()==EVENT_BATTLED then
				local eff=effect:Clone()
				table.insert(table_effect,eff)
			end
			if effect and bit.band(effect:GetType(),EFFECT_TYPE_QUICK_O)==EFFECT_TYPE_QUICK_O and effect:GetCode()==EVENT_FREE_CHAIN and effect:GetCondition()
			then
				local eff=effect:Clone()
				table.insert(table_effect,eff)
			end
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				s[tc:GetOriginalCode()]=eff
			end
		end
		Card.RegisterEffect=cregister
	end
	e:Reset()
end
function s.check(c)
	return c and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c0,c1=Duel.GetBattleMonster(0)
	if s.check(c0) then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
	end
	if s.check(c1) then
		Duel.RegisterFlagEffect(1,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.val(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)*100
end
function s.spcfilter(c,tp)
	if c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return false end
	if not c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	return c:IsFaceup() and c:IsSetCard(0x15f) and c:IsAbleToHandAsCost()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
		and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and aux.dscon()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,s.spcfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
	if not g:GetFirst():IsType(TYPE_MONSTER) and g:GetFirst():CancelToGrave() then return false end
	g:KeepAlive()
	e:SetLabelObject(g)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	local te={}
	if tc:IsType(TYPE_MONSTER) then
		te=s[tc:GetOriginalCode()]
	else
		te=tc:GetActivateEffect()
	end
	if not te then return false end
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		local tg=te:GetTarget()
		local op=te:GetOperation()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp) end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
