--女神之令-光秀
local s,id=GetID()
function s.initial_effect(c)
	--①：展示手卡发动
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
	--②：特召 & 赋予Flag & 可选堆墓
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end

--条件：手卡 或 (场上+Flag)
function s.e1con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_HAND) or e:GetHandler():GetFlagEffect(id)>0
end

--Target过滤：回收怪兽
function s.thfilter1(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
--Target过滤：检索魔法
function s.thfilter2(c)
	return c:IsSetCard(0x611) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end

--Cost过滤：展示本家S/T
function s.rvfilter(c,e,tp,mc)
	if not (c:IsSetCard(0x611) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsPublic()) then return false end
	--魔法卡分支检查：展示卡送墓，回收墓地/除外怪兽
	if c:IsType(TYPE_SPELL) then
		return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	--陷阱卡分支检查：自身送墓，检索魔法
	elseif c:IsType(TYPE_TRAP) then
		return mc:IsAbleToGrave() 
			and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil)
	end
	return false
end

function s.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,c)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst()) --记录展示的卡
	Duel.ShuffleHand(tp)
end

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetLabelObject()
	if chk==0 then return true end
	
	if rc:IsType(TYPE_SPELL) then
		--魔法：送墓展示卡，回收
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,rc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	else
		--陷阱：送墓自身，检索
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	local c=e:GetHandler()
	
	--分支：魔法卡
	if rc:IsType(TYPE_SPELL) then
		--1. 给人观看的卡送去墓地 (需确认还在手卡)
		if rc:IsLocation(LOCATION_HAND) and Duel.SendtoGrave(rc,REASON_EFFECT)>0 and rc:IsLocation(LOCATION_GRAVE) then
			--2. 回收
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
		
	--分支：陷阱卡
	elseif rc:IsType(TYPE_TRAP) then
		--1. 这张卡送去墓地
		if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE) then
			--2. 检索魔法
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end

function s.otherfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x611)
end

function s.tgfilter(c)
	return c:IsSetCard(0x611) and c:IsAbleToGrave()
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local ct={1,2,3,4}
		local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ac)
		c:RegisterEffect(e1)
		--赋予①效果在场上发动的能力
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		
		--检查场上是否有其他本家怪兽
		local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
		if Duel.IsExistingMatchingCard(s.otherfilter,tp,LOCATION_MZONE,0,1,c) 
			and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end