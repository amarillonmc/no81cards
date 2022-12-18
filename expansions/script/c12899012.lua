--H.P.K.-EX001
local m=12899012
local cm=_G["c"..m]
function cm.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,nil,6,3,cm.ovfilter,aux.Stringid(m,0),3,cm.xyzop)
	c:EnableReviveLimit()
	 --attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.mattg)
	e1:SetOperation(cm.matop)
	c:RegisterEffect(e1)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(cm.condition2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
 --disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsCode(12899002)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.ckfilter(c)
	return ((not c:IsSetCard(0x5a71)) and c:IsFaceup()) or c:IsFacedown()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.ckfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) 
end
function cm.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetFieldGroupCount(1-tp,0,LOCATION_DECK)>4 and  e:GetHandler():IsType(TYPE_XYZ) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,5)
	if c:IsRelateToEffect(e) and g:GetCount()==5 then	  
		Duel.ConfirmCards(tp,g)
		local g2=g:Select(tp,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.Overlay(c,g2)
	end
end

function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return (not Duel.IsExistingMatchingCard(cm.ckfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil))
	and e:GetHandler():GetOverlayGroup():GetCount()>0 
end










