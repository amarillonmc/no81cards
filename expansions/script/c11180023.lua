-- 玉龙·幻殇·苍龙
local s, id = GetID()

function s.initial_effect(c)
	-- 可以在「幻殇」怪兽上叠放超量召唤
	c:EnableReviveLimit()   
	aux.AddXyzProcedure(c,nil,3,2,s.ovfilter,aux.Stringid(id,0))
	-- ①效果：1回合1次，去素材送墓/除外并堆墓
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.rmcost)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	
	-- ②效果：从墓地/除外返回卡组并送墓/除外场上卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(2,id+1) -- 1回合2次
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3450) and not c:IsCode(id)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

-- ①效果处理
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g1=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g1>0 then
		local tc=g1:GetFirst()
		if tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0) then
			Duel.SendtoGrave(tc,REASON_COST)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_COST)
		end
	end
end
function s.rmfilter(c)
	return c:IsAbleToGraveAsCost() or c:IsAbleToRemoveAsCost()
end
function s.tgfilter(c)
	return (c:IsSetCard(0x6450) or c:IsSetCard(0x3450)) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	-- 选择场上1张卡送墓/除外
	-- 从卡组堆1张「幻殇」或「龙裔」卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g2=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g2>0 then
		local tc=g2:GetFirst()
		if tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end

-- ②效果处理
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		-- 选择自己场上最多3张卡送墓/除外
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg=g:Select(tp,1,3,nil)
			for tc in aux.Next(sg) do
				if tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0) then
					Duel.SendtoGrave(tc,REASON_EFFECT)
				else
					Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				end
			end
		end
	end
end
