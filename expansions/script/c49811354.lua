--炎冶号 赫菲斯托斯尔普
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetValue(SUMMON_TYPE_XYZ)
	e0:SetCondition(s.spcon)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
	--cannot be material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCost(s.thcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetCondition(s.chkcon)
		ge1:SetOperation(s.chkop)
		Duel.RegisterEffect(ge1,0)
		local _CRegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(c,e,bool)
			if (e:GetCode()==EFFECT_CHANGE_TYPE or e:GetCode()==EFFECT_EQUIP_LIMIT) and c:GetOriginalType()&TYPE_MONSTER>0 and not c:IsPreviousLocation(LOCATION_SZONE) and c:IsLocation(LOCATION_SZONE) and c:GetOwner()~=e:GetOwnerPlayer() then
				c:RegisterFlagEffect(id+200,RESET_EVENT+RESETS_STANDARD,0,1)
			end
			return _CRegisterEffect(c,e,bool)
		end
	end
end
function s.chainfilter(e)
	return e:GetActivateLocation()~=LOCATION_HAND
end
function s.matfilter(c)
	return c:IsFaceup() and c:IsCanOverlay()
end
function s.ovfilter(c,tp)
	return c:GetOwner()==tp and c:GetOriginalType()&TYPE_MONSTER>0
end
function s.msfilter(c,tp)
	return c:GetOwner()==tp and c:GetFlagEffect(id+200)>0
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetFieldGroup(tp,LOCATION_SZONE,LOCATION_SZONE)
	local g=Duel.GetOverlayGroup(tp,0,LOCATION_MZONE)
	return (g1:IsExists(s.msfilter,1,nil,tp) or g:IsExists(s.ovfilter,1,nil,tp)) and Duel.IsExistingMatchingCard(s.matfilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local oc=Duel.SelectMatchingCard(tp,s.matfilter,tp,0,LOCATION_MZONE,1,1,nil,c):GetFirst()
	if oc then
		local og=oc:GetOverlayGroup()
		if og:GetCount()>0 then Duel.Overlay(c,og) end
		Duel.Overlay(c,oc)
	end
end
function s.chkfilter(c,ce,cp)
	local tp=c:GetOwner()
	if not ce then return false end
	return c:IsLocation(LOCATION_SZONE) and c:GetOriginalType()&TYPE_MONSTER>0 and not c:IsPreviousLocation(LOCATION_SZONE) and cp==1-tp
end
function s.chkcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then return false end
	local ce,cp=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local g=eg:Filter(s.chkfilter,nil,ce,cp)
	if g:GetCount()>0 then e:SetLabelObject(g) return true end
	return false
end
function s.chkop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		Duel.RegisterFlagEffect(tc:GetOwner(),id+200,RESET_PHASE+PHASE_END,0,2)
	end
end
function s.efilter(e,re)
	if not re:IsActivated() then return false end
	local ce,loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
	return ce==re and loc&LOCATION_ONFIELD~=0
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end