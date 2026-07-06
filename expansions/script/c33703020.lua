--动物朋友 Hello Kitty 薮猫√
function c33703020.initial_effect(c)
	c:EnableReviveLimit()
--这张卡的卡名在墓地也当作「动物朋友 薮猫」使用。
	aux.EnableChangeCode(c,33700055,LOCATION_GRAVE)
--这张卡不能同调召唤。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
--自己场上没有怪兽存在的场合，可以从卡组把1只「动物朋友」怪兽送去墓地，这张卡从额外卡组特殊召唤。
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33703020,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(c33703020.sprcon)
	e3:SetCost(c33703020.spcost)
	e3:SetTarget(c33703020.sptg)
	e3:SetOperation(c33703020.spop)
	c:RegisterEffect(e3)
end
function c33703020.sprcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c33703020.costfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c33703020.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c33703020.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.ConfirmCards(1-tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c33703020.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c33703020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33703020.filter(c)
	return c:IsSetCard(0x442) and c:IsDiscardable()-- and 
end 
function c33703020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		local p=Duel.GetTurnPlayer()
		Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		if Duel.IsExistingMatchingCard(c33703020.filter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33703020,0)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local g=Duel.SelectMatchingCard(tp,c33703020.filter,tp,LOCATION_HAND,0,1,3,nil)
			if g:GetCount()>0 then 
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
				local og=Duel.GetOperatedGroup()
				if og:GetCount()>0 then
					--●1张以上：这张卡不会被战斗破坏。
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(33703020,1))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
					e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
					e1:SetRange(LOCATION_MZONE)
					e1:SetValue(1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					c:RegisterEffect(e1)
				end
				--●2张以上：这张卡不会被效果破坏。
				if og:GetCount()>1 then 
					local e2=Effect.CreateEffect(c)
					e2:SetDescription(aux.Stringid(33703020,2))
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
					e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
					e2:SetRange(LOCATION_MZONE)
					e2:SetValue(1)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					c:RegisterEffect(e2)
				end
				--●3张：这张卡成为效果·攻击对象时才能发动。从卡组把1张「动物朋友」卡送去墓地。
				if og:GetCount()==3 then
					local e3=Effect.CreateEffect(c)
					e3:SetDescription(aux.Stringid(33703020,3))
					e3:SetType(EFFECT_TYPE_QUICK_O)
					e3:SetCode(EVENT_CHAINING)
					e3:SetRange(LOCATION_MZONE)
					e3:SetCondition(c33703020.tocon)
					e3:SetTarget(c33703020.totg)
					e3:SetOperation(c33703020.toop)
					c:RegisterEffect(e3)
					local e4=e3:Clone()
					e4:SetCode(EVENT_BE_BATTLE_TARGET)
					e4:SetCondition(c33703020.totocon)
					c:RegisterEffect(e4)
				end
			end
		end
	end
end
function c33703020.tofiler(c)
	return c:IsSetCard(0x442) and c:IsAbleToGrave()
end
function c33703020.tocon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function c33703020.totocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==e:GetHandler()
end
function c33703020.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33703020.tofiler,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c33703020.toop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33703020.tofiler,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

