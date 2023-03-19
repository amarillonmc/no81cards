--幽底斗姬 残酷假面
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
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
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge3:SetOperation(cm.clear)
		Duel.RegisterEffect(ge3,0)
	end
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
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(0,m)
	Duel.ResetFlagEffect(1,m)
end
function cm.check2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()==nil then return end
	table.insert(BATTLE_CARD_CHECK,Duel.GetAttacker():GetCode())
end
function cm.clear2(e,tp,eg,ep,ev,re,r,rp)
	BATTLE_CARD_CHECK={}
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function cm.nfilter(c)
	return c~=Duel.GetAttacker() and c~=Duel.GetAttackTarget()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.GetCurrentPhase()==PHASE_BATTLE_STEP and Duel.GetAttacker() and Duel.GetFlagEffect(tp,m)==0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_BATTLE_STEP,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=g:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		Duel.Destroy(tg,REASON_EFFECT)
	elseif c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp)
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
	local sg=g:Filter(cm.filter6,nil)
	g:DeleteGroup()
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end