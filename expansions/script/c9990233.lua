--冰电龙 狂欢曲
function c9990233.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9990233,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9990233)
	e1:SetTarget(c9990233.target)
	e1:SetOperation(c9990233.activate)
	c:RegisterEffect(e1)
	--confirm 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9990233,1))
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9990234)
	e2:SetTarget(c9990233.target2)
	e2:SetOperation(c9990233.operation)
	c:RegisterEffect(e2)
	--public
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e3)
end
function c9990233.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local gc=g:GetCount()
	if chk==0 then return gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc and Duel.IsPlayerCanDraw(1-tp,gc) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,gc,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,gc)
end
function c9990233.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local gc=g:GetCount()
	if gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc then
		local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if oc>0 then
			Duel.Draw(1-tp,oc,REASON_EFFECT)
		end
	end
end
function c9990233.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK)>0 end
end
function c9990233.operation(e,tp,eg,ep,ev,re,r,rp)
		local cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		if cm1>10 then cm1=10 end
		if cm2>10 then cm2=10 end
		local g=Duel.GetDecktopGroup(tp,cm1)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,tp,cm1)
		local g=Duel.GetDecktopGroup(1-tp,cm2)
		  Duel.ConfirmCards(tp,g)
		  Duel.SortDecktop(tp,1-tp,cm2)
end

