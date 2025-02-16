--汐击龙的汐驰
local cm,m=GetID()
function cm.initial_effect(c)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetCondition(aux.ThisCardInGraveAlreadyCheckReg)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetLabelObject(e0)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_MOVE)
	e5:SetCondition(cm.spcon2)
	c:RegisterEffect(e5)
	aux.RegisterMergedDelayedEvent(c,m,EVENT_SPSUMMON_SUCCESS)
	if not cm.global_check then
		cm.global_check=true
		cm.chain_with_stridgon=0
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
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local bool=re:GetHandler():IsSetCard(0x9977)
	cm[ev]={re,bool}
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm[ev]={re,false}
end
function cm.clearcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	local i=1
	local res=false
	while type(cm[i])=="table" do
		local te,bool=table.unpack(cm[i])
		if bool and (i>1 or e:GetCode()~=EVENT_CHAIN_NEGATED) then res=true end
		cm[i]=nil
		i=i+1
	end
	local tp=e:GetHandler():GetOwner()
	Duel.ResetFlagEffect(tp,m)
	--local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+m)}
	--for _,te in pairs(eset) do te:Reset() end
	if res then
		cm.chain_with_stridgon=cm.chain_with_stridgon+1
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(m,math.min(cm.chain_with_stridgon,3)+2))
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetTargetRange(1,0)
		e3:SetCode(EFFECT_FLAG_EFFECT+m)
		Duel.RegisterEffect(e3,tp)
	else
		cm.chain_with_stridgon=0
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x9977)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.chain_with_stridgon>=3 end
	Duel.RegisterFlagEffect(0,11451760,RESET_CHAIN,0,1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.spfilter(c,se)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.spfilter,1,nil,se)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local bool,ceg=Duel.CheckEvent(EVENT_CUSTOM+m,true)
	return eg:IsContains(e:GetHandler()) and bool and ceg:IsExists(cm.spfilter,1,nil) and (re==nil or not re:IsActivated())
end
function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0x9977) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) and c:GetFlagEffect(m-10)==0 end
	c:RegisterFlagEffect(m-10,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsRelateToEffect(e) and c:IsAbleToHand() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end