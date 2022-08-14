--暗幕龙
local m=40010146
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(cm.spcost)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.atkcost)
	e1:SetOperation(cm.adchange)
	c:RegisterEffect(e1) 
	   --Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_SPECIAL)~=SUMMON_TYPE_SPECIAL then return true end
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.adchange(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SWAP_BASE_AD)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateAttack() then
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local fid=c:GetFieldID()
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetLabel(fid)
			e2:SetLabelObject(c)
			e2:SetCondition(cm.rmcon)
			e2:SetOperation(cm.rmop)
			Duel.RegisterEffect(e2,tp)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.rmfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end


