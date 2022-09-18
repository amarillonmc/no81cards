-- 聚 合 假 日 灵 魂 / Festività A m a l g a m a t a
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--alt proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.XyzLevelFreeCondition(nil,s.xyzcheck,3,3))
	e1:SetTarget(aux.XyzLevelFreeTarget(nil,s.xyzcheck,3,3))
	e1:SetOperation(aux.XyzLevelFreeOperation(nil,s.xyzcheck,3,3))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.prcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e2x=Effect.CreateEffect(c)
	e2x:SetType(EFFECT_TYPE_SINGLE)
	e2x:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2x:SetCode(EFFECT_IMMUNE_EFFECT)
	e2x:SetRange(LOCATION_MZONE)
	e2x:SetCondition(s.prcon)
	e2x:SetValue(s.efilter)
	c:RegisterEffect(e2x)
	--overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.prcon)
	e3:SetTarget(s.ovtg)
	e3:SetOperation(s.ovop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetCountLimit(1)
	e4:SetCost(s.thcost)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
	--mark cards
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_IGNORE_IMMUNE,1)
		tc=eg:GetNext()
	end
end

function s.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==1
end
function s.prcon(e)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function s.ofilter(c,e)
	return c:IsCanOverlay() and c:GetFlagEffect(id)>0 and (not e or not c:IsImmuneToEffect(e))
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c and c:IsType(TYPE_XYZ) and c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.ofilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
		if #g>0 then
			Duel.Overlay(c,g)
		end
	end
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then
		local res=e:GetLabel()==0 or #g>=2
		e:SetLabel(0)
		return res and g:IsExists(Card.IsAbleToHand,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=c:GetOverlayGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,tp,REASON_EFFECT)
		end
	end
end