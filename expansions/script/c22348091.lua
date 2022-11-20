--墓 园 侵 染
local m=22348091
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c22348091.cgcon)
	e2:SetOperation(c22348091.cgop)
	c:RegisterEffect(e2)
	--Activate2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348091,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCategory(CATEGORY_LEAVE_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c22348091.accon)
	e4:SetTarget(c22348091.actg)
	e4:SetOperation(c22348091.acop)
	c:RegisterEffect(e4)
	
end
function c22348091.cgcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
end
function c22348091.cgop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRace(RACE_ZOMBIE) and rc:IsFaceup() then
			Duel.Hint(HINT_CARD,0,22348091)
			if rc:IsLocation(LOCATION_MZONE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_ZOMBIE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e1) end
	elseif rc:IsRace(RACE_ZOMBIE) and not rc:IsSetCard(0x703) and rc:IsFaceup() then
			Duel.Hint(HINT_CARD,0,22348091)
			if rc:IsLocation(LOCATION_MZONE) then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			e0:SetCode(EFFECT_CHANGE_CODE)
			e0:SetValue(22348080)
			rc:RegisterEffect(e0) end
	elseif rc:IsCode(22348080) and rc:IsFaceup() and aux.NegateEffectMonsterFilter(rc) then
		Duel.Hint(HINT_CARD,0,22348091)
			if rc:IsLocation(LOCATION_MZONE) then
		Duel.NegateEffect(ev)
		Duel.NegateRelatedChain(rc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e3)
			end
	end
end
function c22348091.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function c22348091.accon(e,tp,eg,ep,ev,re,r,rp)
	local ex,g,gc,dp,dv=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	return ex and rp==1-tp and (dv&LOCATION_GRAVE==LOCATION_GRAVE or g and g:IsExists(c22348091.cfilter,1,nil)) or re:IsHasCategory(CATEGORY_GRAVE_SPSUMMON) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c22348091.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c22348091.acop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=c:GetActivateEffect()
			local tep=c:GetControler()
	end
end
 --rp==1-tp and