--墨染山河 雪景寒林图
local s,id,o=GetID()
Duel.LoadScript("c33201381.lua")
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,s.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOKEN)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,id+20000)
	e0:SetLabel(id,id-40)
	e0:SetTarget(VHisc_MRSH.tg)
	e0:SetOperation(VHisc_MRSH.gop)
	c:RegisterEffect(e0)   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(s.atktg)
	e2:SetCondition(s.atkcon)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
end
s.VHisc_MRSH=true
s.VHisc_CNTreasure=true

function s.matfilter1(c,syncard)
	return c.VHisc_CNTreasure
end

function s.spfilter(c,e,tp)
	return c.VHisc_CNTreasure and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.top(c,e)
	Duel.Hint(HINT_CARD,c:GetPreviousControler(),id-40)
	local tp=c:GetPreviousControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function s.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and (Duel.GetAttackTarget()==e:GetHandler() or Duel.GetAttacker()==e:GetHandler())
end
function s.atktg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
