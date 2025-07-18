local s,id=GetID()
function c13000755.initial_effect(c)
	  --synchro summon
	c:SetSPSummonOnce(13000755)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCondition(s.hspcon)
	e1:SetOperation(s.hspop) 
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1) 
local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end
function s.tgfil1(c,e,tp) 
	return c:IsFaceup() and c:IsLevelAbove(5) and c:IsType(TYPE_SYNCHRO)
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	return Duel.IsExistingMatchingCard(s.tgfil1,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sc=Duel.SelectMatchingCard(tp,s.tgfil1,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.Release(sc,REASON_COST) 
end
function s.drop(e,tp,eg,ep,ev,re,r,rp,c)
local c=e:GetHandler()
local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e2:SetCountLimit(1)
		e2:SetCondition(s.stcon)
		e2:SetOperation(s.stop)
		e2:SetReset(RESET_PHASE+PHASE_END)   
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetTargetRange(0,1)
		e3:SetValue(0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
end
function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil)
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,2,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end



