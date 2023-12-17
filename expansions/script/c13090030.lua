--额外爆破
local m=13090030
local cm=_G["c"..m]
function c13090030.initial_effect(c)
	 local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e0) 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.extg)
	e1:SetOperation(cm.exop)
	c:RegisterEffect(e1)
end
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) and  Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	g:RemoveCard(sg:GetFirst())
	Duel.ShuffleExtra(1-tp)

	local lg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	Duel.ConfirmCards(1-tp,lg)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local lsg=lg:FilterSelect(1-tp,Card.IsAbleToRemove,1,1,nil)
	Duel.Remove(lsg,POS_FACEUP,REASON_EFFECT)
	lg:RemoveCard(lsg:GetFirst())
	Duel.ShuffleExtra(tp)
	if Duel.SelectYesNo(tp,aux.Stringid(13090030,0)) then
		local ta=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,0,nil)
		local b1=Duel.IsExistingMatchingCard(function(c) return c:IsAbleToRemove() and c:IsFaceup() and c:IsType(TYPE_PENDULUM) end,tp,0,LOCATION_EXTRA,1,nil)
		local b2=ta:GetClassCount(Card.GetCode)>=2
	local op=0
	if b1 and not b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))
	end
	if not b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	end
	if op==0 then
	   local tb=g:FilterSelect(tp,function(c) return c:IsAbleToRemove() and c:IsFaceup() and c:IsType(TYPE_PENDULUM) end,1,3,nil)
	   Duel.Remove(tb,POS_FACEUP,REASON_EFFECT)
	end
	if op==1 then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		 local aa=lg:Select(tp,1,1,nil):GetFirst()
	lg:Remove(Card.IsCode,nil,aa:GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local bb=lg:Select(tp,1,1,nil):GetFirst()
		if Duel.IsExistingMatchingCard(function(c) return c:IsCode(aa:GetCode()) end,tp,0,LOCATION_EXTRA,1,nil) and Duel.IsExistingMatchingCard(function(c) return c:IsCode(bb:GetCode()) end,tp,0,LOCATION_EXTRA,1,nil) then
		   Duel.ConfirmCards(1-tp,g)
		   local cc=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
		   Duel.Remove(cc,POS_FACEUP,REASON_EFFECT)
		end
		Duel.ShuffleExtra(tp)
		Duel.ShuffleExtra(1-tp)
	end
  end
end














