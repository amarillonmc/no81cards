--幽底斗姬 无瑕
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
	if not BATTLE_ACT_CHECK then
		BATTLE_ACT_CHECK={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.check2)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge2:SetOperation(cm.clear)
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
	if cm.counter==nil then
		cm.counter=true
		cm[0]=0
		cm[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(cm.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_TO_GRAVE)
		e3:SetOperation(cm.addcount)
		Duel.RegisterEffect(e3,0)
	end
	if not cm.global_check then
		cm.global_check=true
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
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_ONFIELD) then
			local p=tc:GetPreviousControler()
			cm[p]=cm[p]+1
		end
		tc=eg:GetNext()
	end
end
function cm.rfilter(c)
	return c:GetFlagEffect(11451771)>0
end
function Group.ForEach(group,func,...)
    if aux.GetValueType(group)=="Group" and group:GetCount()>0 then
        local d_group=group:Clone()
        for tc in aux.Next(d_group) do
            func(tc,...)
        end
    end
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
function cm.check2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()==nil then return end
	local code=re:GetHandler():GetCode()
	table.insert(BATTLE_ACT_CHECK,code)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetLabel(ev,#BATTLE_ACT_CHECK)
	e1:SetOperation(cm.reset2)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,0)
end
function cm.reset2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()==nil then return end
	local ev0,loc=e:GetLabel()
	if ev==ev0 then table.remove(BATTLE_ACT_CHECK,loc) end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	BATTLE_ACT_CHECK={}
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE --and Duel.GetFlagEffect(0,11451771)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
	if not Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(cm.atkval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.atkval(e,c)
	return cm[e:GetHandlerPlayer()]*300
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
	if #BATTLE_ACT_CHECK>0 then
		local hash={}
		local class=0
		for i=1,#BATTLE_ACT_CHECK do
			local code=BATTLE_ACT_CHECK[i]
			if not hash[code] then
				class=class+1
				hash[code]=1
			else
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
		--BATTLE_ACT_CHECK={}
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
	if not (g and aux.GetValueType(g)=="Group") or not g:IsExists(cm.filter6,1,nil) then
		if aux.GetValueType(g)=="Group" then g:DeleteGroup() end
		e:Reset()
		return false
	else return true end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g then return end
	local sg=g:Filter(cm.filter6,nil)
	g:DeleteGroup()
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
end