local m=53796146
local cm=_G["c"..m]
cm.name="永恒的守护神"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetOperation(cm.adjustop)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		Duel.RegisterEffect(ge4,1)
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_CHANGE_POS)
		ge5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return not Pos_Changed_by_Effect end)
		ge5:SetOperation(cm.reset)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge5:Clone()
		Duel.RegisterEffect(ge6,1)
		Exxod_IsStatus=Card.IsStatus
		Card.IsStatus=function(tc,int)
			if int&(STATUS_SUMMON_TURN|STATUS_SPSUMMON_TURN)~=0 and tc:GetFlagEffect(m)>0 then return true else return Exxod_IsStatus(tc,int) end
		end
		Exxod_ChangePosition=Duel.ChangePosition
		Duel.ChangePosition=function(...)
			Pos_Changed_by_Effect=true
			local op=Exxod_ChangePosition(...)
			Pos_Changed_by_Effect=false
			return op
		end
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do tc:RegisterFlagEffect(m,RESET_EVENT+0xec0000+RESET_PHASE+PHASE_END,0,1,e:GetCode()) end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if #eg~=1 or not tc:IsControler(tp) or tc:GetFlagEffect(m)==0 then return end
	Duel.ResetFlagEffect(tp,m+500)
end
function cm.thfilter(c)
	return (c:IsCode(55737443,53569894) or (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5c))) and c:IsAbleToHand()
end
function cm.check(g)
	if #g==1 then return true end
	local res=0x0
	if g:IsExists(Card.IsCode,1,nil,55737443) then res=res+0x1 end
	if g:IsExists(Card.IsCode,1,nil,53569894) then res=res+0x2 end
	if g:IsExists(Card.IsSetCard,1,nil,0x5c) then res=res+0x4 end
	return res~=0x1 and res~=0x2 and res~=0x4
end
function cm.filter(c,e,tp)
	return c:IsLevelAbove(5) and c:IsLevelBelow(8) and c:IsRace(RACE_ROCK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,cm.check,false,1,2)
		local ct=Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		if ct~=0 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
		end
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
end
function cm.spfilter(c,e,tp)
	return c:IsCode(2326738,2694423,52323207,75209824,92736188) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then return end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,m+500,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(cm.adjustop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,0)
	local e2=e1:Clone()
	Duel.RegisterEffect(e2,1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local fg=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(m)>0 end,tp,0x4,0,nil)
	if Duel.GetFlagEffect(tp,m+500)>0 then
		for tc in aux.Next(fg) do
			if tc:IsFacedown() then
				if tc:GetFlagEffectLabel(m)==1100 then tc:SetStatus(STATUS_SUMMON_TURN,false) else tc:SetStatus(STATUS_SPSUMMON_TURN,false) end
			else
				if tc:GetFlagEffectLabel(m)==1100 then tc:SetStatus(STATUS_SUMMON_TURN,true) else tc:SetStatus(STATUS_SPSUMMON_TURN,true) end
			end
		end
	else
		for tc in aux.Next(fg) do
			if tc:GetFlagEffectLabel(m)==1100 then tc:SetStatus(STATUS_SUMMON_TURN,true) else tc:SetStatus(STATUS_SPSUMMON_TURN,true) end
		end
		e:Reset()
		Duel.Readjust()
	end
end
