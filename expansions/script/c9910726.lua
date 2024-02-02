--远古造物 白垩刺甲鲨
dofile("expansions/script/c9910700.lua")
function c9910726.initial_effect(c)
	--special summon
	QutryYgzw.AddSpProcedure(c,2)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--to grave / remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c9910726.tgtg)
	e1:SetOperation(c9910726.tgop)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
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
