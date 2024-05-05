--[[
亡命铁心之愿
Compassion of Desperado Heart
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_COMPASSION_OF_DESPERADO_HEART,LOCATION_SZONE|LOCATION_MZONE)
	c:Activation(false,false,false,false,s.regop)
	--[[Each time a "Desperado Trickster" monster(s) is destroyed: Place 1 counter on this card for each of those destroyed monsters.]]
	local SZChk=aux.AddThisCardInSZoneAlreadyCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetLabelObject(SZChk)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--[[Once per turn: You can remove 1 counter from this card; Set 1 "Desperado Trickster" monster or 1 "Desperado Heart" card from your GY to your field.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:OPT()
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--[[During your Main Phase, except the turn this card was activated: You can Special Summon this card from your Spell & Trap Zone to your field as an Effect Monster named "Desperado Heart" (FIRE/Psychic/Level 1/ATK 0/DEF 0) and with the following effects (This card is NOT treated as a Spell).
	● Cannot be destroyed by card effects.
	● This card gains 500 ATK/DEF for each counter on it]]
	aux.RegisterDesperadoSpellMonsterEffect(c,id,COUNTER_COMPASSION_OF_DESPERADO_HEART)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetCondition(aux.ProcSummonedCond)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(aux.ProcSummonedCond)
	e4:SetValue(s.statval)
	c:RegisterEffect(e4)
	e4:UpdateDefenseClone(c)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,0)
end

--E1
function s.cfilter(c)
	if c:IsPreviousLocation(LOCATION_MZONE) then
		return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(ARCHE_DESPERADO_TRICKSTER)
	else
		return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and not c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsMonster()
	end
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(aux.AlreadyInRangeFilter(e,s.cfilter),1,nil)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=eg:FilterCount(s.cfilter,nil)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,tp,COUNTER_COMPASSION_OF_DESPERADO_HEART)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetTargetParam()
	if ct and ct>0 and c:IsCanAddCounter(COUNTER_COMPASSION_OF_DESPERADO_HEART,ct,true) then
		c:AddCounter(COUNTER_COMPASSION_OF_DESPERADO_HEART,ct,true)
	end
end

--E2
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,COUNTER_COMPASSION_OF_DESPERADO_HEART,1,REASON_COST) end
	c:RemoveCounter(tp,COUNTER_COMPASSION_OF_DESPERADO_HEART,1,REASON_COST)
end
function s.setfilter(c,e,tp,ft)
	if c:IsMonster() then
		return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		return c:IsSetCard(ARCHE_DESPERADO_HEART) and c:IsSSetable()
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetMZoneCount(tp)
		return Duel.IsExists(false,s.setfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.Select(HINTMSG_SET,false,tp,aux.Necro(s.setfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,Duel.GetMZoneCount(tp)):GetFirst()
	if not tc then return end
	if tc:IsMonster() then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
			Duel.ConfirmCards(1-tp,Group.FromCards(tc))
		end
	else
		Duel.SSet(tp,tc)
	end
end

--E4
function s.statval(e,c)
	return c:GetCounter(COUNTER_COMPASSION_OF_DESPERADO_HEART)*500
end