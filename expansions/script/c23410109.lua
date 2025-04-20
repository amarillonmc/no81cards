--迅烈如火
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,23410101)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcFunRep(c,cm.ffilter,6,true)
	--code
	aux.EnableChangeCode(c,23410101,LOCATION_MZONE)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(cm.top)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(aux.bdcon)
	e1:SetOperation(cm.flagop)
	c:RegisterEffect(e1)
	
	local ce2=Effect.CreateEffect(c)
	ce2:SetType(EFFECT_TYPE_SINGLE)
	ce2:SetCode(EFFECT_UPDATE_ATTACK)
	ce2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ce2:SetRange(LOCATION_MZONE)
	ce2:SetCondition(cm.tttcon)
	ce2:SetValue(1000)
	c:RegisterEffect(ce2)
	local ce3=ce2:Clone()
	ce3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ce3)
	local ce4=Effect.CreateEffect(c)
	ce4:SetType(EFFECT_TYPE_SINGLE)
	ce4:SetCode(EFFECT_PIERCE)
	ce4:SetValue(DOUBLE_DAMAGE)
	ce4:SetCondition(cm.tttcon)
	c:RegisterEffect(ce4)
	--search
	local ce5=Effect.CreateEffect(c)
	ce5:SetDescription(aux.Stringid(23410107,2))
	ce5:SetCategory(CATEGORY_DESTROY)
	ce5:SetType(EFFECT_TYPE_QUICK_O)
	ce5:SetCode(EVENT_FREE_CHAIN)
	ce5:SetRange(LOCATION_MZONE)
	ce5:SetCountLimit(1)
	ce5:SetCost(cm.dcost)
	ce5:SetCondition(cm.tttcon)
	ce5:SetTarget(cm.dtg)
	ce5:SetOperation(cm.dop)
	c:RegisterEffect(ce5)
	
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	e4:SetCondition(cm.oxcon)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(cm.atkcon)
	e3:SetCost(cm.atkcost)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end
function cm.ffilter(c)
	return c:IsRace(RACE_ILLUSION)
end
function cm.m(c)
	return c:IsRace(RACE_ILLUSION) and c:IsAbleToGraveAsCost()
end
function cm.mm(card)
	if card:IsCode(23410101) then 
		return 2
	else
		return 1
	end
end
function cm.mmm(mg,fc)
	local tp=fc:GetControler()
	local x=0
	for tc in aux.Next(mg) do
		x = x + cm.mm(tc)
		if x>=6 then break end
	end
	return x>=6 and Duel.GetLocationCountFromEx(tp,tp,mg,fc)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.m,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return mg:CheckSubGroup(cm.mmm,3,6,e:GetHandler()) and Duel.GetLocationCountFromEx(tp,tp,mg,e:GetHandler())>0
		and rp==1-tp end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.m,tp,LOCATION_MZONE,0,nil)
	if not mg:CheckSubGroup(cm.mmm,3,6,c) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	local sg=Group.CreateGroup()
	while #sg<6 do
		local button=false
		local cg=mg:Filter(cm.m,sg,c)
		if #cg==0 then break end
		local cancel_group=sg:Clone()
		if gc then cancel_group:RemoveCard(gc) end
		if cm.mmm(sg,c) then button=true end
		local og=mg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
		if #og>0 and #sg==5 and Duel.GetLocationCountFromEx(tp,tp,sg,c)==0 then
			cg=og
		end	   
		Duel.Hint(3,tp,HINTMSG_FMATERIAL)
		local tc=cg:SelectUnselect(cancel_group,tp,button,false,3,6)
		if not tc then break end
		if sg:IsContains(tc) then
			 sg:RemoveCard(tc)
		else
			sg:AddCard(tc)
		end	   
	end
	c:SetMaterial(sg)
	if sg:IsExists(Card.IsFacedown,1,nil) then 
		Duel.ConfirmCards(1,sg:Filter(Card.IsFacedown,nil))
		Duel.ConfirmCards(0,sg:Filter(Card.IsFacedown,nil))
	end
	if sg and Duel.SendtoGrave(sg,REASON_MATERIAL)~=0 then 
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end

function cm.indtg(e,c)
	local tc=e:GetHandler()
	return c==tc or c==tc:GetBattleTarget()
end

function cm.top(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,1-tp)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
end
function cm.flagcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)==0
end
function cm.flagop(e,tp,eg,ep,ev,re,r,rp,c)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end

function cm.tttcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),23410101) and e:GetHandler():GetFlagEffect(m)~=0
end
function cm.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil):Select(tp,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function cm.oxcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end

function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and c:GetFlagEffect(m)~=0 and not bc:IsType(TYPE_LINK) and not bc:IsPosition(POS_FACEDOWN_DEFENSE)
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m+10000000)==0 end
	c:RegisterFlagEffect(m+10000000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and bc:IsRelateToBattle() and c:GetFlagEffect(m)~=0 and not bc:IsType(TYPE_LINK) and not bc:IsPosition(POS_FACEDOWN_DEFENSE) then
		Duel.ChangePosition(bc,POS_FACEDOWN_DEFENSE)
	end
end









