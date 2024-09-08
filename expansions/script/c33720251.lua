--[[
【月】【背景音台】ANTHEM - 轮回
【Ｒ】Anthem - Reincarnation
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
if not TYPE_DOUBLESIDED then
	Duel.LoadScript("glitchylib_doublesided.lua")
end
if not TYPE_SOUNDSTAGE then
	Duel.LoadScript("glitchylib_soundstage.lua")
end
function s.initial_effect(c)
	aux.AddDoubleSidedProc(c,SIDE_REVERSE,id-1,id)
	local e0=c:Activation()
	aux.AddSoundStageProc(c,e0,id,3,7)
	--You cannot Special Summon monsters.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--[[During your Draw Phase, before you draw, you can choose up to 3 of the following effects to apply this turn. (You cannot choose to apply the same effect multiple times)]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:OPT()
	e1:SetRange(LOCATION_FZONE)
	e1:SetFunctions(s.condition,nil,nil,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetDrawCount(tp)>0
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chosen=0
	local iter=0
	while iter<3 do
		iter=iter+1
		local checks={}
		for i=0,4 do
			table.insert(checks,chosen&(1<<i)==0)
		end
		local opt=aux.Option(tp,id,2,table.unpack(checks))
		chosen=chosen|(1<<opt)
		
		if opt==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_DRAW_COUNT)
			e1:SetTargetRange(1,0)
			e1:SetValue(s.drawval)
			e1:SetOwnerPlayer(tp)
			e1:SetReset(RESET_PHASE|PHASE_DRAW)
			Duel.RegisterEffect(e1,tp)
		
		elseif opt==1 then
			local e1=Effect.CreateEffect(c)
			e1:Desc(3,id)
			e1:SetCategory(CATEGORY_TOHAND)
			e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
			e1:OPT()
			e1:SetCondition(s.spcon)
			e1:SetOperation(s.spop)
			e1:SetReset(RESET_PHASE|PHASE_STANDBY)
			Duel.RegisterEffect(e1,tp)
		
		elseif opt==2 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(10)
			e1:SetReset(RESET_PHASE|PHASE_END)
			Duel.RegisterEffect(e1,tp)
		
		elseif opt==3 then
			local e1=Effect.CreateEffect(c)
			e1:Desc(4,id)
			e1:SetCategory(CATEGORY_TOGRAVE)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:OPT()
			e1:SetFunctions(s.bpcon,nil,s.bptg,s.bpop)
			e1:SetReset(RESET_PHASE|PHASE_END)
			Duel.RegisterEffect(e1,tp)
		
		elseif opt==4 then
			local e1=Effect.CreateEffect(c)
			e1:Desc(5,id)
			e1:SetCategory(CATEGORY_RECOVER)
			e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE|PHASE_END)
			e1:OPT()
			e1:SetOperation(s.epop)
			e1:SetReset(RESET_PHASE|PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
		
		if iter<3 and not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			iter=3
		end
	end
end

--DP
function s.drawval(e)
	local tp=e:GetOwnerPlayer()
	return math.max(0,7-Duel.GetHandCount(tp))
end

--SP
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.Necro(Card.IsAbleToHand),tp,LOCATION_GRAVE,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(aux.Necro(Card.IsAbleToHand),tp,LOCATION_GRAVE,0,1,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,3,nil)
		if #sg>0 then
			Duel.Search(sg)
		end
	end
end

--BP
function s.bpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(tp) and Duel.IsBattlePhase() and Duel.GetCurrentChain()==0
end
function s.bptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if chk==0 then
		return ct>0 and Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,ct,nil)
	Duel.SetCardOperationInfo(g,CATEGORY_TOGRAVE)
end
function s.bpop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards():Filter(Card.IsControler,nil,1-tp)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--EP
function s.epop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Recover(tp,5000,REASON_EFFECT)
end