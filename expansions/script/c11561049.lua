--纯白巫女 公主·可可落
local m=11561049
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,aux.TRUE,c11561049.xyzcheck,3,99)  
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--count
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11561049+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c11561049.ctcon)
	e2:SetTarget(c11561049.cttg)
	e2:SetOperation(c11561049.ctop)
	c:RegisterEffect(e2)
	--Remove counter replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11561049,0))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_RCOUNTER_REPLACE+0x1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c11561049.rcon)
	e3:SetOperation(c11561049.rop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c11561049.atkcon)
	e4:SetValue(c11561049.atkval)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c11561049.destg)
	e5:SetValue(1)
	e5:SetOperation(c11561049.desop)
	c:RegisterEffect(e5)


end
function c11561049.dfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c11561049.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c11561049.dfilter,nil,tp)
		e:SetLabel(count)
		return e:GetHandler():GetOverlayCount()>4 and count>0 and Duel.IsCanRemoveCounter(tp,1,0,0x1,count,REASON_COST)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c11561049.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	Duel.RemoveCounter(tp,1,0,0x1,count,REASON_COST)
end

function c11561049.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>2
end
function c11561049.atkval(e)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x1)*100
end
function c11561049.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0 and re:IsActivated() and bit.band(r,REASON_COST)~=0 and ep==e:GetOwnerPlayer() and e:GetHandler():GetCounter(0x1)>=ev
end
function c11561049.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1,ev,REASON_EFFECT)
end
function c11561049.cfilter(c)
	return c:IsCanHaveCounter(0x1)
end
function c11561049.matfilter(c)
	return c:IsCanHaveCounter(0x1) and c:IsCanOverlay() and (c:IsFaceupEx() or not c:IsLocation(LOCATION_REMOVED))
end


function c11561049.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c11561049.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c11561049.matfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x1)
end
function c11561049.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cct=Duel.GetMatchingGroupCount(c11561049.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if c:IsFaceup() and c:IsRelateToEffect(e) and cct>0 and c:AddCounter(0x1,cct)~=0 and Duel.IsExistingMatchingCard(c11561049.matfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,cct,nil) then 
			Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11561049.matfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,cct,cct,nil,e,tp)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end
function c11561049.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c11561049.xyzfilter(c)
	return c:GetCounter(0x1)==0
end
function c11561049.xyzcheck(g)
	return g:Filter(c11561049.xyzfilter,nil):GetClassCount(Card.GetOriginalLevel)==1 and g:IsExists(Card.IsLevelAbove,1,nil,1)
end