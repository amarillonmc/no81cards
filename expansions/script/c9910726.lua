--远古造物 白垩刺甲鲨
require("expansions/script/c9910700")
function c9910726.initial_effect(c)
	--special summon
	Ygzw.AddSpProcedure(c,2)
	c:EnableReviveLimit()
	--to grave / remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c9910726.tgtg)
	e1:SetOperation(c9910726.tgop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c9910726.setcost)
	e2:SetTarget(c9910726.settg)
	e2:SetOperation(c9910726.setop)
	c:RegisterEffect(e2)
end
function c9910726.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910726,0))
		sel=Duel.SelectOption(tp,aux.Stringid(9910726,1),aux.Stringid(9910726,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(9910726,1))
	else
		Duel.SelectOption(tp,aux.Stringid(9910726,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	else
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
	end
end
function c9910726.tgop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if sel==1 then
		if g1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg1=g1:Select(tp,1,2,nil)
			Duel.HintSelection(sg1)
			Duel.SendtoGrave(sg1,REASON_EFFECT)
		end
	else
		if g2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg2=g2:Select(tp,1,3,nil)
			Duel.HintSelection(sg2)
			Duel.Remove(sg2,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c9910726.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local id=Duel.GetTurnCount()
	if chk==0 then return c:GetTurnID()<id and not c:IsReason(REASON_RETURN)
		and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9910726.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Ygzw.SetFilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c9910726.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,Ygzw.SetFilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then Ygzw.Set(tc,e,tp) end
end
