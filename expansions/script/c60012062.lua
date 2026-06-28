-- 黑白乱舞·诺尔和卜朗
--Duel.LoadScript("c.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--eup
	local ee1=Effect.CreateEffect(c)
	ee1:SetType(EFFECT_TYPE_SINGLE)
	ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee1:SetRange(LOCATION_MZONE)
	ee1:SetCode(EFFECT_UPDATE_ATTACK)
	ee1:SetCondition(cm.incon)
	ee1:SetValue(3000)
	c:RegisterEffect(ee1)
	local ee2=ee1:Clone()
	ee2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ee2)
	--immune
	local ee3=Effect.CreateEffect(c)
	ee3:SetType(EFFECT_TYPE_SINGLE)
	ee3:SetCode(EFFECT_IMMUNE_EFFECT)
	ee3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee3:SetRange(LOCATION_MZONE)
	ee3:SetCondition(cm.incon)
	ee3:SetValue(cm.efilter)
	c:RegisterEffect(ee3)

	local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_REMOVE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetRange(LOCATION_MZONE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCountLimit(1)
  e1:SetOperation(cm.endeffop)
  c:RegisterEffect(e1)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DISCARD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.AnXitg)
	e1:SetOperation(cm.AnXiop)
	c:RegisterEffect(e1)

end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.endeffop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,60012060)>2 then
		c:AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
	end
end
function cm.AnXitg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.AnXiop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end