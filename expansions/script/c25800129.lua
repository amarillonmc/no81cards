--舰娘舰装-彩色装备箱
local m=25800129
local cm=_G["c"..m]

function cm.initial_effect(c)
		--pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.thcon)
	e0:SetTarget(cm.pentg0)
	e0:SetOperation(cm.penop0)
	c:RegisterEffect(e0)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon1)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.pentg1)
	e2:SetOperation(cm.penop1)
	c:RegisterEffect(e2)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(cm.pentg2)
	e1:SetOperation(cm.penop2)
	c:RegisterEffect(e1)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x5211) 
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end
function cm.cfilter(c)
	return  c:IsType(TYPE_PENDULUM) and c:IsAbleToRemove() and  c:IsFaceup() and c:IsSetCard(0x211)
end

function cm.pentg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) 
	or Duel.CheckLocation(tp,LOCATION_PZONE,1)) 
	and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_EXTRA,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.penop0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
----
function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.pentg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
-----
function cm.penfilter(c)
	return  c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x211)  and not c:IsForbidden() 
end
function cm.pentg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.penop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end