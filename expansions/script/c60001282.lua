--时烬归隅
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_CHAINING)
		ge:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge,0)
	end
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(cm.stg)
	e2:SetOperation(cm.sop)
	c:RegisterEffect(e2)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		local sg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x1ff,0,nil,m)
		local num=Duel.GetFlagEffect(tp,m)
		if sg and num<13 then
			for tc in aux.Next(sg) do
				tc:RegisterFlagEffect(0,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,num-1))
			end
		end
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=Duel.GetFlagEffect(tp,m)
	if num>12 then num=1 else num=13-num end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=num end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetFlagEffect(tp,m)
	if num>12 then num=1 else num=13-num end
	Duel.ConfirmDecktop(tp,num)
	local g=Duel.GetDecktopGroup(tp,num)
	if g:GetClassCount(Card.GetCode)==1 then
		local turnp=Duel.GetTurnPlayer()
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m+10000000)==0 end
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m+10000000,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:GetHandler():IsRace(RACE_FAIRY) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
