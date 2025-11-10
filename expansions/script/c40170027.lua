--娱乐伙伴 灵摆魔术搭档
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,s.ffilter1,s.ffilter2,false)
	aux.AddContactFusionProcedure(c,s.contfilter,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,aux.ContactFusionSendToDeck(c))
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--pendulum sum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--cannot activate 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(s.pencon)
	e4:SetTarget(s.pentg)
	e4:SetOperation(s.penop)
	c:RegisterEffect(e4)
end
function s.ffilter1(c)
	return c:IsFusionType(TYPE_PENDULUM) and c:IsFusionSetCard(0x9f)
end
function s.ffilter2(c)
	return c:IsFusionType(TYPE_PENDULUM) and c:IsFusionSetCard(0xf2)
end
function s.contfilter(c)
	if c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() then return false end
	return c:IsAbleToDeckOrExtraAsCost()
end
function s.splimit(e,se,sp,st)
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION or st&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM 
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp) and Duel.IsMainPhase()
end
function s.check(e,tp,exc)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return false end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_EXTRA,0,exc,TYPE_PENDULUM)
	if #g==0 then return false end
	return aux.PendCondition(e,lpz,g)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s.check(e,tp,nil) end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,TYPE_PENDULUM)
	if #g==0 then return end
	--the summon should be done after the chain end
	local sg=Group.CreateGroup()
	aux.PendOperation(e,tp,eg,ep,ev,re,r,rp,lpz,sg,g)
	Duel.RaiseEvent(sg,EVENT_SPSUMMON_SUCCESS_G_P,e,REASON_EFFECT,tp,tp,0)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
end
function s.GetScale(c)
	if not c:IsType(TYPE_PENDULUM) then return NULL_VALUE end
	local sc=NULL_VALUE
	if c:IsLocation(LOCATION_PZONE) then
		local seq=c:GetSequence()
		if seq==0
		or seq==6
		then sc=c:GetLeftScale() else sc=c:GetRightScale() end
	else
		sc=c:GetLeftScale()
	end
	return sc
end
function s.GetScaleDiff(g)
	if not #g==2 then return NULL_VALUE end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1 and tc2 then
		local sc1,sc2=s.GetScale(tc1),s.GetScale(tc2)
		return math.abs(sc1-sc2)
	end
	return NULL_VALUE
end
function s.aclimit(e,re,tp)
	local lv=re:GetHandler():GetLevel()
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if not (re:IsActiveType(TYPE_MONSTER) and lv>1) then return false end
	return g and s.GetScaleDiff(g)>=lv
end
function s.thcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9f) and c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(s.thcfilter,1,nil)
end
function s.IsScale(c,scale)
	return c:GetLeftScale()==scale
end
function s.thfilter(c,g)
	return c:IsSetCard(0x9f) and c:IsType(TYPE_PENDULUM) and not g:IsExists(s.IsScale,1,nil,c:GetLeftScale())
end 
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.thcfilter,nil)
	if chk==0 then return g and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,g) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tg)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,1,nil)
	if Duel.Destroy(sg,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end