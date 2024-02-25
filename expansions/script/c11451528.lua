--珂拉琪的拼图箱庭
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.recon)
	e3:SetOperation(cm.reop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e6)
	--Win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(cm.regop2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(cm.wincon)
	e5:SetOperation(cm.winop)
	c:RegisterEffect(e5)
end
function cm.filter(c)
	return c:IsSetCard(0x97c) and c:IsType(TYPE_PENDULUM)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function cm.fselect(g)
	return g:GetClassCount(Card.GetLeftScale)==#g
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if #g==0 then return end
	local num=g:GetClassCount(Card.GetLeftScale)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m-1,4))
	local sg=g:SelectSubGroup(tp,cm.fselect,false,num,num)
	Duel.SendtoExtraP(sg,tp,REASON_EFFECT)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(cm.sop)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,tp)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1) end
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1 and (e:GetHandler():GetFlagEffect(m)>0 or (ep~=tp and e:GetCode()~=EVENT_CHAIN_NEGATED))
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_ONFIELD,0,e:GetHandler(),REASON_RULE)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:Select(tp,1,1,nil)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Release(sg,REASON_RULE)
end
function cm.spfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=eg:FilterCount(cm.spfilter,nil,tp)
	if num>0 then
		local flag=c:GetFlagEffectLabel(m+1)
		if flag then
			flag=flag+1
			c:ResetFlagEffect(m+1)
			c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(m,flag))
		else
			c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(m,1))
		end
	end
end
function cm.wincon(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetHandler():GetFlagEffectLabel(m+1)
	return flag and flag==16
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_COLLAGE = 0x69
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m-1,5))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m-1,5))
	Duel.Win(tp,WIN_REASON_COLLAGE)
end