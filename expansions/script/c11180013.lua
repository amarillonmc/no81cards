-- 幻殇龙裔（新效果）
local s, id = GetID()

function s.initial_effect(c)
	-- 1回合1次
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_TODECK)
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

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	local tc=g:GetFirst()
	if tc:IsAbleToGraveAsCost() and (not tc:IsAbleToRemoveAsCost() or Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))==0) then
		Duel.SendtoGrave(tc,REASON_COST)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	end
		e:SetLabelObject(tc)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	if not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) then
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_ONFIELD)  
	e:SetLabel(0)
	else
		if bit.band(e:GetLabelObject():GetType(),0x7)==TYPE_MONSTER then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
			e:SetCategory(CATEGORY_GRAVE_SPSUMMON)
		else
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
		end
	e:SetLabel(1)   
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local num=e:GetLabel()  
		local ty=bit.band(e:GetLabelObject():GetType(),0x7)
		-- 如果主要怪兽区原本没有怪兽
		if num==0 then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if #g>0 and  Duel.SelectYesNo(tp,aux.Stringid(id,3))  then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local sg=g:FilterSelect(tp,function(c,ty) return not c:IsType(ty) end,1,1,nil,ty)
				Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		else
			-- 主要怪兽区有怪兽时的效果
			if ty&TYPE_MONSTER~=0 then
				-- 如果是怪兽，从墓地或手卡特召1只「幻殇」怪兽
				local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)
				if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=g:Select(tp,1,1,nil)
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			elseif ty&TYPE_SPELL~=0 then
				-- 如果是魔法卡，从除外区特召1只「幻殇」怪兽
				local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
				if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=g:Select(tp,1,1,nil)
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
		-- 离场返回卡组
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_DECKSHF)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1)
	end
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3450) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
