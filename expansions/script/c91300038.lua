--猎兽魔石：希尔瓦
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	--flip
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e4:SetCost(s.drcost)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.dract)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(s.thcost)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
	--deck
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_MOVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(s.condition1)
	e6:SetOperation(s.operation1)
	c:RegisterEffect(e6)
	local e10=e6:Clone()
	e10:SetCode(EVENT_CUSTOM+id+1)
	e10:SetCondition(aux.TRUE)
	c:RegisterEffect(e10)
	--hand
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_MOVE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(s.condition2)
	e7:SetOperation(s.operation1)
	c:RegisterEffect(e7)
	local e20=e7:Clone()
	e20:SetCode(EVENT_CUSTOM+id+2)
	e20:SetCondition(aux.TRUE)
	c:RegisterEffect(e20)
	--mzone
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(s.condition3)
	e8:SetOperation(s.operation1)
	c:RegisterEffect(e8)
	--szone
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_LEAVE_FIELD)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCondition(s.condition4)
	e9:SetOperation(s.operation1)
	c:RegisterEffect(e9)
	--grave
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_LEAVE_GRAVE)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCondition(s.condition5)
	e11:SetOperation(s.operation1)
	c:RegisterEffect(e11)
	--extra
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_LEAVE_DECK)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(s.condition6)
	e12:SetOperation(s.operation1)
	c:RegisterEffect(e12)
	--excep
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_LEAVE_DECK)
	e13:SetProperty(EFFECT_FLAG_DELAY)
	e13:SetRange(LOCATION_SZONE)
	e13:SetCondition(s.condition7)
	e13:SetOperation(s.operation1)
	c:RegisterEffect(e13)
	if not s.global_check then
		s.global_check=true
		local _Overlay=Duel.Overlay
		function Duel.Overlay(xc,v,...)
			local t=Auxiliary.GetValueType(v)
			local g=Group.CreateGroup()
			if t=="Card" then g:AddCard(v) else g=v end
			if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
				Duel.RaiseEvent(g:Filter(Card.IsLocation,nil,LOCATION_DECK),EVENT_CUSTOM+id+1,e,0,0,0,0)
			end
			if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
				Duel.RaiseEvent(g:Filter(Card.IsLocation,nil,LOCATION_HAND),EVENT_CUSTOM+id+2,e,0,0,0,0)
			end
			return _Overlay(xc,v,...)
		end
	end
end
s.hackclad=3
function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)<=1
end
function s.drfilter(c)
	return c:IsAbleToRemoveAsCost(POS_FACEUP)
end
function s.cfilter1(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and not c:IsLocation(LOCATION_DECK)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil)
end
function s.cfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and not c:IsLocation(LOCATION_HAND)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter2,1,nil)
end
function s.cfilter3(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) --and c:IsPreviousControler(tp)
end
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter3,1,nil)
end
function s.cfilter4(c,e,tp)
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()<5 and c:GetReasonEffect()~=e --and c:IsPreviousControler(tp)
end
function s.condition4(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter4,nil,e)
	if #g==0 then return false end
	local lab=0
	for tc in aux.Next(g) do
		local seq=tc:GetPreviousSequence()
		if tc:IsPreviousControler(tp) then seq=4-seq end
		lab=lab|1<<seq
	end
	e:SetLabel(lab)
	return true
end
function s.cfilter5(c,tp)
	return c:IsPreviousControler(tp)
end
function s.condition5(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter5,1,nil)
end
function s.cfilter6(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA)
end
function s.condition6(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter6,1,nil)
end
function s.cfilter7(c,tp)
	return c:GetPreviousLocation()==LOCATION_REMOVED and c:GetPreviousPosition()&POS_FACEDOWN>0
end
function s.condition7(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter7,1,nil)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=c:GetFlagEffect(id)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	if flag>=3 then Duel.RaiseEvent(eg,EVENT_CUSTOM+id,re,r,rp,ep,e:GetLabel()) end
end
function s.spfilter(c,e,tp)
	return c.hackclad==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.drcfilter(c,tp)
	return c:IsType(TYPE_MONSTER)
end
function s.thfilter(c)
	return _G["c"..c:GetCode()]  and _G["c"..c:GetCode()].hackclad and not c:IsCode(id) and c:IsAbleToHand()
end
function s.mvfilter(c,tp)
	return c:IsFaceup() and _G["c"..c:GetCode()]  and _G["c"..c:GetCode()].hackclad and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)>0
end
function s.mvfilter2(c,tp)
	return c:IsFaceup() and _G["c"..c:GetCode()]  and _G["c"..c:GetCode()].hackclad and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)>1
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,2000,2000,5,RACE_ROCK,ATTRIBUTE_DARK,POS_FACEDOWN_DEFENSE)  and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.IsExistingMatchingCard(s.mvfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_SZONE+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local oe=e:GetLabelObject()
	if not c:IsRelateToEffect(e) and not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,2000,2000,5,RACE_ROCK,ATTRIBUTE_DARK,POS_FACEDOWN_DEFENSE)  then return end
	c:AddMonsterAttribute(TYPE_EFFECT)
	if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,1-tp,true,false,POS_FACEDOWN_DEFENSE)>0 and c:IsLocation(LOCATION_MZONE) then
		Duel.AdjustAll()
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and Duel.IsExistingMatchingCard(s.mvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,0)},
			{b2,aux.Stringid(id,1)})
		if op==1 then
			e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g2:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		elseif op==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
			local g3=Duel.SelectMatchingCard(tp,s.mvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			local tc=g3:GetFirst()
			if not tc then return end
			if tc:IsControler(tp) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
				local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
				local nseq=math.log(s,2)
				Duel.MoveSequence(g3:GetFirst(),nseq)
			else
				local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
				local nseq=math.log(bit.rshift(s,16),2)
				Duel.MoveSequence(g3:GetFirst(),nseq)
			end
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MAX_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.mvalue)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.mvalue(e,fp,rp,r)
	return 1-Duel.GetFieldGroupCount(fp,LOCATION_SZONE,0)
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.drfilter,1-tp,LOCATION_EXTRA,0,2,nil) end
	local g=Duel.GetMatchingGroup(s.drfilter,1-tp,LOCATION_EXTRA,0,nil)
	local rg=g:RandomSelect(1-tp,2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.dract(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.ShuffleHand(p)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(p,Card.IsRace,p,LOCATION_HAND,0,1,1,nil,RACE_MACHINE)
	local tg=g:GetFirst()
	if tg then
		if Duel.SendtoGrave(tg,REASON_EFFECT)==0 then
			Duel.ConfirmCards(1-p,tg)
			Duel.ShuffleHand(p)
		end
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DRAW)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,p)
	end
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end