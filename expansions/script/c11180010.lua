-- 龙裔显现
local s, id = GetID()

function s.initial_effect(c)
	-- Card type (Monster)
		aux.EnablePendulumAttribute(c)
	-- ①: Special Summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return c:IsLevel(3) or c:IsLink(3) or c:IsRank(3)
end
function s.splimit(e,c)
	return not (c:IsLevel(3) or c:IsLink(3) or c:IsRank(3))
end
function s.costfilter(c,tp)
	return c:IsAbleToGraveAsCost() or c:IsAbleToRemoveAsCost()
end
function s.cfilter(c)
	return c:GetSequence()<5
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc:IsAbleToGraveAsCost() and (not tc:IsAbleToRemoveAsCost() or Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0) then
		Duel.SendtoGrave(tc,REASON_COST)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	end
		e:SetLabelObject(tc)
end

function s.dragonfilter(c,ty)
	return c:IsSetCard(0x6450) and not c:IsType(ty) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	if not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) then
	e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	e:SetLabel(0)
	else
	e:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)   
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_GRAVE) 
	e:SetLabel(1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		local num=e:GetLabel()  
		local ty=bit.band(e:GetLabelObject():GetType(),0x7)
		-- Additional effect if no monsters before summon
		if num==0 then
			local g2=Duel.GetMatchingGroup(s.dragonfilter,tp,LOCATION_DECK,0,nil,ty)
			if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local sg=g2:Select(tp,1,1,nil)
			 local tc=sg:GetFirst()
				if tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0) then
					Duel.SendtoGrave(tc,REASON_EFFECT)
				else
					Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				end
			end
		else
			-- Different effects based on card type sent
			if ty&TYPE_MONSTER~=0 and #g>0  then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg=g:Select(tp,1,1,nil)
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			elseif ty&TYPE_SPELL~=0 then
				local g3=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)
				local g4=g3:Filter(Card.IsSetCard,nil,0x6450)
				local g5=g4:Filter(Card.IsType,nil,TYPE_TRAP)
				if #g5>0  then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
					local sg=g5:Select(tp,1,1,nil)
					Duel.SSet(tp,sg)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
					e1:SetValue(LOCATION_DECKSHF)
					c:RegisterEffect(e1)
				end
			end
		end
	end
end


