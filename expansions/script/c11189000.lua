--湮潮之域
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x452)
	aux.AddCodeList(c,0x452)
	if not CATEGORY_SSET then CATEGORY_SSET=0 end
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e4)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_FZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	--
	local e0_1=Effect.CreateEffect(c)
	e0_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0_1:SetCode(EVENT_CHAIN_SOLVED)
	e0_1:SetRange(LOCATION_FZONE)
	e0_1:SetOperation(s.counterop)
	c:RegisterEffect(e0_1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SSET)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.indcost)
	e2:SetTarget(s.indtg)
	e2:SetOperation(s.indop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1118)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCost(s.tkcost)
	e3:SetTarget(s.tktg)
	e3:SetOperation(s.tkop)
	c:RegisterEffect(e3)
end
function s.counterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)>=3 then return end
	if c:GetFlagEffect(1)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		c:AddCounter(0x452,1)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x5454) and (c:IsAbleToRemove() or c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable())
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToRemove() and (not (tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSSetable()) or Duel.SelectOption(tp,1102,1153)==0) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		else
			Duel.SSet(tp,tc,tp)
		end
	end
end
function s.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x452,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x452,2,REASON_COST)
end
function s.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+1)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(s.indfilter)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(s.indfilter)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function s.indfilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0x5454)
end
function s.cfilter(c,e,tp)
	return c:IsSetCard(0x5454) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function s.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.cfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,s.cfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x5454,TYPES_TOKEN_MONSTER,0,0,1,RACE_PLANT,ATTRIBUTE_LIGHT) and e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x5454,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,1,RACE_PLANT,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,id+o)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end