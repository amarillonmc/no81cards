--战吼斗士·沃尔夫
local s,id,o=GetID()
function s.initial_effect(c)
	--record
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	--Tribute Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.tscon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE)
	e2:SetHintTiming(TIMING_BATTLE_PHASE+TIMING_BATTLE_END,TIMING_BATTLE_PHASE+TIMING_BATTLE_END)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.thcost)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_CONFIRM)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.filter(c)
	return c:IsSetCard(0x15f) and not c:IsCode(id)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		table_effect={}
		esetrange=Effect.SetRange
		table_range={}
		Effect.SetRange=function(effect,range)
			table_range[effect]=range
			return esetrange(effect,range)
			end
		s.GetRange=function(effect)
			if table_range[effect] then 
				return table_range[effect]
			end
			return nil
			end
		Card.RegisterEffect=function(card,effect,flag)
			if effect and (s.GetRange(effect)==LOCATION_MZONE or s.GetRange(effect)==LOCATION_FZONE or s.GetRange(effect)==LOCATION_SZONE or s.GetRange(effect)==LOCATION_ONFIELD) and (((effect:IsHasType(EFFECT_TYPE_TRIGGER_O) or effect:IsHasType(EFFECT_TYPE_TRIGGER_F)) and effect:GetCode()==EVENT_BATTLED) or effect:IsHasType(EFFECT_TYPE_TRIGGER_O) or effect:IsHasType(EFFECT_TYPE_TRIGGER_F) or effect:IsHasType(EFFECT_TYPE_IGNITION))  then
				local eff=effect:Clone()
				table.insert(table_effect,eff)
			end
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				s[tc:GetOriginalCode()]=eff
			end
		end
		Card.RegisterEffect=cregister
		Effect.SetRange=esetrange
	end
	e:Reset()
end
function s.check(c)
	return c and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c0,c1=Duel.GetBattleMonster(0)
	if s.check(c0) then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
	end
	if s.check(c1) then
		Duel.RegisterFlagEffect(1,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_WARRIOR)
end
function s.tscon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil))
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	if c:IsLocation(LOCATION_HAND) and not c:IsPublic() then
		Duel.ConfirmCards(1-tp,c)
	end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
		and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and aux.dscon()
end
function s.thfilter(c)
	return c:IsSetCard(0x15f) and c:IsAbleToHand()
end
function s.efffilter(c)
	return c:IsSetCard(0x15f) and c:IsFaceup() and s[c:GetOriginalCodeRule()]
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(s.efffilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			local sg=Duel.SelectMatchingCard(tp,s.efffilter,tp,LOCATION_ONFIELD,0,1,1,nil)
			if #sg>0 then
				Duel.HintSelection(sg)
				local te=s[sg:GetFirst():GetOriginalCodeRule()]
				if not te then return false end
				Duel.Hint(HINT_CARD,0,sg:GetFirst():GetOriginalCode())
				local tg=te:GetTarget()
				local op=te:GetOperation()
				if tg then tg(e,tp,eg,ep,ev,re,r,rp) end
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
		end
	end
end
