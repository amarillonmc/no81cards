--电子化天使-A-
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--change effect type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(id)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--
	if not s.global_activate_check then
		s.global_activate_check=true
		--special summon
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_FIELD)
		e01:SetCode(EFFECT_SPSUMMON_PROC)
		e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e01:SetRange(LOCATION_HAND)
		e01:SetValue(SUMMON_TYPE_RITUAL)
		e01:SetCondition(s.rspcon)
		e01:SetOperation(s.rspcop)
		--SpecialSummon from ex
		local ge1=Effect.CreateEffect(c)
		ge1:SetDescription(aux.Stringid(id,2))
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_FREE_CHAIN)
		ge1:SetRange(LOCATION_HAND)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetHintTiming(TIMING_BATTLE_PHASE)
		ge1:SetLabelObject(e01)
		ge1:SetCondition(s.spcon)
		ge1:SetTarget(s.sptarget)
		ge1:SetOperation(s.spactivate)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge3:SetTargetRange(LOCATION_HAND,0)
		ge3:SetTarget(s.eftg)
		ge3:SetLabelObject(ge1)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		Duel.RegisterEffect(ge4,1)
	end
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsSetCard(0x93) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

-------------------------------Global Effect-------------------------------

function s.eftg(e,c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0x2093)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.IsPlayerAffectedByEffect(tp,id)
end
function s.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local ritual_e=e:GetLabelObject()
		if not ritual_e then return false end
		local ritual_e2=ritual_e:Clone()
		e:GetHandler():RegisterEffect(ritual_e2)
		local boolean=e:GetHandler():IsSpecialSummonable() and e:GetHandler():GetFlagEffect(id)==0 
		ritual_e2:Reset()
		return boolean
	end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function s.spactivate(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
	local ritual_e=e:GetLabelObject()
	if not ritual_e then return false end
	local ritual_e2=ritual_e:Clone()
	e:GetHandler():RegisterEffect(ritual_e2)
	if e:GetHandler():IsSpecialSummonable() then
		Duel.SpecialSummonRule(tp,e:GetHandler())
	end
	ritual_e2:Reset()
end
function s.mfilter(c)
	return c:IsReleasable(REASON_EFFECT|REASON_MATERIAL|REASON_RITUAL)
end
function s.rspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local m1=Duel.GetRitualMaterial(tp)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg1=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_DECK,0,nil)
	local mg=Group.__add(mg1,mg2):Filter(Card.IsCode,nil,id)
	mg:RemoveCard(c)
	local lv=c:GetLevel()
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,"Greater")
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,"Greater")
	aux.GCheckAdditional=nil
	return res
end
function s.rspcop(e,tp,eg,ep,ev,re,r,rp,c)
	--::cancel::
	local c=e:GetHandler()
	if not c then return false end
	local mg=Duel.GetRitualMaterial(tp)
	mg:RemoveCard(c)
	if c then
		local lv=c:GetLevel()
		local mg1=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
		local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_DECK,0,nil)
		local mg=Group.__add(mg1,mg2):Filter(Card.IsCode,nil,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,lv,tp,c,lv,"Greater")
		aux.GCheckAdditional=nil
		c:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
	end
end

