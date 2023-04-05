--幽底斗姬 百变
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
	if not BATTLE_CARD_CHECK then
		BATTLE_CARD_CHECK={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_START)
		ge1:SetOperation(cm.check2)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear2)
		Duel.RegisterEffect(ge2,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(cm.adjustop)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		Duel.RegisterEffect(e2,1)
	end
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetCondition(cm.clearcon)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_CHAIN_NEGATED)
		ge4:SetCondition(cm.rscon)
		ge4:SetOperation(cm.reset)
		Duel.RegisterEffect(ge4,0)
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_ADJUST)
		ge5:SetCondition(cm.con5)
		ge5:SetOperation(cm.check5)
		Duel.RegisterEffect(ge5,0)
	end
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function cm.check5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.RegisterFlagEffect(0,11451771,RESET_PHASE+PHASE_END,0,1)
end
function cm.rfilter(c)
	return c:GetFlagEffect(11451771)>0
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase>=PHASE_BATTLE_START and phase<=PHASE_BATTLE then return end
	local rg=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_HAND,0,nil)
	if #rg>0 and Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		og:ForEach(Card.RegisterFlagEffect,11451771,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451771,2))
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(11451771,3))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		e1:SetLabelObject(og)
		Duel.RegisterEffect(e1,tp)
		Duel.Readjust()
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local tf=re:GetHandler():IsRelateToEffect(re)
	local cid=re:GetHandler():GetRealFieldID()
	cm[ev]={re,tf,cid}
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm[ev]={re,false,0}
end
function cm.clearcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	local i=1
	while cm[i] do
		cm[i]=nil
		i=i+1
	end
end
function cm.check2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()==nil then return end
	table.insert(BATTLE_CARD_CHECK,Duel.GetAttacker():GetCode())
end
function cm.clear2(e,tp,eg,ep,ev,re,r,rp)
	BATTLE_CARD_CHECK={}
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE --and Duel.GetFlagEffect(0,11451771)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local st=false
	local i=1
	while type(cm[i])=="table" do
		local te,tf,cid=table.unpack(cm[i])
		if te:IsHasType(EFFECT_TYPE_ACTIVATE) then st=true end
		i=i+1
	end
	if st then
		--destroy sub
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EFFECT_DESTROY_REPLACE)
		e4:SetTarget(cm.desreptg)
		e4:SetValue(cm.desrepval)
		e4:SetOperation(cm.desrepop)
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if not eg:IsExists(Card.IsReason,1,nil,REASON_BATTLE) then return false end
		local at=Duel.GetAttacker()
		if not at then return false end
		local g=Group.FromCards(at)
		local tt=Duel.GetAttackTarget()
		if tt then g:AddCard(tt) end
		local tg=g:Filter(Card.IsAbleToHand,nil)
		return #tg>0
	end
	return true
end
function cm.desrepval(e,c)
	return c:IsReason(REASON_BATTLE)
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if not at then return false end
	local g=Group.FromCards(at)
	local tt=Duel.GetAttackTarget()
	if tt then g:AddCard(tt) end
	local tg=g:Filter(Card.IsAbleToHand,nil)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	e:Reset()
end
function cm.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,e:GetLabel())
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
end
function cm.atkval(e,c)
	return cm[e:GetHandlerPlayer()]
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.drop2)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetLabelObject(e1)
	e3:SetOperation(cm.resop)
	Duel.RegisterEffect(e3,tp)
end
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToBattle() and c:IsLocation(LOCATION_MZONE) and c:IsDisabled() then return end
	if #BATTLE_CARD_CHECK>0 then
		local hash={}
		local class=0
		for i=1,#BATTLE_CARD_CHECK do
			local code=BATTLE_CARD_CHECK[i]
			if not hash[code] and (i~=#BATTLE_CARD_CHECK or Duel.GetAttacker()~=e:GetHandler()) then
				class=class+1
				hash[code]=1
			elseif hash[code] then
				hash[code]=hash[code]+1
			end
		end
		if class>0 then
			class=math.ceil(class/2)
			local tg=Group.CreateGroup()
			Duel.Draw(tp,class,REASON_EFFECT)
			tg:Merge(Duel.GetOperatedGroup())
			Duel.Draw(1-tp,class,REASON_EFFECT)
			tg:Merge(Duel.GetOperatedGroup())
			if #tg>0 then tg:ForEach(Card.RegisterFlagEffect,11451771,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451771,1)) end
		end
	end
end
function cm.resop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te~=nil and aux.GetValueType(te)=="Effect" then te:Reset() end
	e:Reset()
end
function cm.filter6(c)
	return c:GetFlagEffect(11451771)>0
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g and not g:IsExists(cm.filter6,1,nil) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g then return end
	local sg=g:Filter(cm.filter6,nil)
	g:DeleteGroup()
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end