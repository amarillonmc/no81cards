--菌树逆转
local s,id=GetID()
s.named_with_FungalTree=1

s.TOKEN_MUSHROOM_BED=40020825

function s.FungalTree(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FungalTree
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_HANDES_SELF+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES_SELF,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g==0 then return end
	local ct=Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	if ct>0 then
		local og=Duel.GetOperatedGroup()
		local has_fungal = og:IsExists(function(c) return s.FungalTree(c) and c:IsLocation(LOCATION_GRAVE) end,1,nil)
		if has_fungal then
			local op_hand_ct=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
			local my_hand_ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
			local draw_ct=op_hand_ct - my_hand_ct
			if draw_ct>0 and Duel.IsPlayerCanDraw(tp,draw_ct) then
				Duel.BreakEffect()
				Duel.Draw(tp,draw_ct,REASON_EFFECT)
			end
		end
	end
end

function s.bedfilter(c)
	return c:IsFaceup() and c:IsCode(s.TOKEN_MUSHROOM_BED) and c:IsLocation(LOCATION_SZONE)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return c:IsAbleToHand() 
		   and Duel.IsExistingMatchingCard(s.bedfilter,tp,LOCATION_SZONE,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.bedfilter,tp,LOCATION_SZONE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			if c:IsRelateToEffect(e) then
				Duel.SendtoHand(c,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,c)
			end
		end
	end
end
