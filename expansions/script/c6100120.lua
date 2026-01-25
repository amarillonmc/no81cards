--女神之令- 信轩
local s,id=GetID()
function s.initial_effect(c)
	--effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.e1con)
	e1:SetCost(s.e1cost)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	--effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.e2cost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end
function s.e1con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) then return true end
	return c:IsLocation(LOCATION_MZONE) and (c:IsStatus(STATUS_SUMMON_TURN) or c:IsStatus(STATUS_SPSUMMON_TURN))
end
function s.rvfilter(c,e,tp,mc)
	if not (c:IsSetCard(0x611) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsPublic()) then return false end
	if c:IsType(TYPE_SPELL) then
		return c:IsAbleToGrave() --展示的卡要能送墓
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	elseif c:IsType(TYPE_TRAP) then
		return mc:IsAbleToGrave()
			and Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_REMOVED,0,1,nil)
	end
	return false
end
--检索仪式怪兽的Filter
function s.thfilter(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thfilter1(c)
	return c:IsSetCard(0x611) and c:IsAbleToGrave()
end
function s.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,c)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
	Duel.ShuffleHand(tp)
end
function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetLabelObject()
	if chk==0 then return true end
	if rc:IsType(TYPE_SPELL) then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
		--提示：展示卡送墓
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,rc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	end
end
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	local c=e:GetHandler()
	if rc:IsType(TYPE_SPELL) then
		--●魔法卡：给人观看的卡送去墓地，从卡组把1只「女神之令」仪式怪兽加入手卡
		--注意：rc此时还在手卡，需要确认它还在手卡才能处理
		if rc:IsLocation(LOCATION_HAND) and Duel.SendtoGrave(rc,REASON_EFFECT)>0 and rc:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	elseif rc:IsType(TYPE_TRAP) then
		if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_REMOVED,0,1,1,nil)
			if #g>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function s.costfilter(c,tp)
	local type1=c:GetType()&0x7
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil,type1)
end
function s.thfilter2(c,type1)
	return c:IsSetCard(0x611) and not c:IsType(type1) and c:IsAbleToHand()
end
function s.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetType()&0x7)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cost_type=e:GetLabel()
	
	--1. 特殊召唤
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		
		--2. 检索不同种类
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil,cost_type)
		if #g>0 then
			if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
				Duel.ConfirmCards(1-tp,g)
				
				--3. 可选升星
				if c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then --"要让等级上升吗？"
					Duel.BreakEffect()
					local val=Duel.AnnounceNumber(tp,1,2,3,4)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_LEVEL)
					e1:SetValue(val)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
					c:RegisterEffect(e1)
				end
			end
		end
	end
end