--动物朋友 朱雀 ～净化的炎舞～
function c33711103.initial_effect(c)
   --synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x442),2,99) 
	--De
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33711103,1))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33711103)
	e1:SetTarget(c33711103.netg)
	e1:SetOperation(c33711103.neop)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c33711103.desreptg)
	e2:SetOperation(c33711103.desrepop)
	c:RegisterEffect(e2)
end
function c33711103.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c33711103.neop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		if oc:IsSetCard(0x442) then
			if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 then 
				if Duel.SelectEffectYesNo(tp,aux.Stringid(33711103,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
					local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
					Duel.Destroy(g,REASON_EFFECT)
				end
			elseif Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_DECK)>0 and Duel.SelectYesNo(tp,aux.Stringid(33711103,3)) then
				local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
				local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
				local op=1
				if b1 and b2 then
					op=Duel.SelectOption(tp,aux.Stringid(33711103,4),aux.Stringid(33711103,5))
				
				elseif b1 then
					op=Duel.SelectOption(tp,aux.Stringid(33711103,4))
				else
					op=Duel.SelectOption(tp,aux.Stringid(33711103,5))+1
				end
				if op==0 then
					local g=Duel.GetDecktopGroup(1-tp,1)
					Duel.Destroy(g,REASON_EFFECT)
				else
					local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
					local sg=g:RandomSelect(tp,1)
					Duel.Destroy(sg,REASON_EFFECT)
				end 
			end
		end
	end
end
function c33711103.repfilter(c)
	return c:IsSetCard(0x442)
		and c:IsAbleToDeck()
end
function c33711103.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c33711103.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c33711103.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		e:SetLabelObject(g:GetFirst())
		return true
	else return false end
end
function c33711103.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,tp,0,REASON_EFFECT+REASON_REPLACE)
end